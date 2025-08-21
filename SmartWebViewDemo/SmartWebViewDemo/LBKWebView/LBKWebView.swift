//
//  LBKWebView.swift
//  SmartWebViewDemo
//
//  Created by Buck on 2025/6/11.
//

import Foundation
import UIKit
import WebKit
//import SnapKit

let injectJSString = """
!function () {
if (window.LBKJsBridge) {
    return;
}
window.LBKJsBridge = {
    invoke: function (args) {
        window.webkit.messageHandlers.NativeListener.postMessage(args);
    }
};
}()
"""

// JS调用Native
enum LBKJSCallType: String {
    /// 获取用户信息
    case getUserInfo = "getauthinfo"
    /// 拉起登录页
    case requireLogin = "requireauth"
    /// 显示分享视图
    case showShare = "showShareWindow"
    /// 打开新的H5
    case openNewWeb = "openNewPage"
    /// 回退上一页
    case toPrevious = "goBackToPage"
    /// 获取基本信息: 版本号、build号、网络、语言、主题、手机系统版本、机型、设备ID、渠道信息、当前时区、当前选中的法币、客户端类型、运营商、是否使用VPN
    case getSystemInfo = "getSystemInfo"
    /// 存储数据
    case setItemSync = "setItemSync"
    /// 获取存储的数据
    case getItemSync = "getItemSync"
    /// 移除存储的数据
    case removeItemSync = "removeItemSync"
    
    /// 跳转原生页面
    case toNativePage = "jumpNativeUiView"  // -> jumpNativeUIViewController
    /// 设置导航条
    case setupNavigationBar = "setNavigationbar"//  -> setNavigationBar
    /// 选择图片
    case chooseImage = "chooseImage"
    /// 拦截弹框
    case showAlert = "setBreakbackInfos"  // -> setBreakBackInfos
    /// 关闭弹框---> 这个是否有必要
    case hideAlert = "clearBreakBackInfos"
    /// 下载图片
    case downloadImage = "downloadImage"

}


// Native调用JS
enum LBKNativeCallType: String {
    case done = "onClientCallDone"
    case failed = "onClientCallFailed"
    case canceled = "onClientCallCancelled"
}


// 页面加载生命周期控制
enum LBKWebLifeCycle: String {
    case beforeCreate
    case mounted
    case destroyed
}

class SmartWebView: UIView, SmartWebViewJSHandler,WKNavigationDelegate {
    private(set) var webView: WKWebView
    private let bridge = JSBridge()
    
    init(userAgent: String? = nil) {
        self.webView = SmartWebView.createConfiguredWebView(userAgent: userAgent, bridge: bridge, injectedJS: injectJSString)
        super.init(frame: .zero)
        
        self.webView.navigationDelegate = self
        #warning("上线前需要移除")
        if #available(iOS 16.4, *) {
            self.webView.isInspectable = true;  // 支持是否可以调试
        }
        bridge.delegate = self
        addSubview(webView)
        #warning("约束的处理")
        webView.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-100)
//        webView.snp.makeConstraints { make in
//            make.edges.equalTo(self)
//        }
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:  Loaders
    func load(url: URL) {
        webView.load(URLRequest(url: url))
    }
    
    func load(html: String, baseURL: URL? = nil) {
        webView.loadHTMLString(html, baseURL: baseURL)
    }
    
    // MARK:  Recycle
    func recycle() {
        WebViewPool.shared.enqueue(webView)
    }
    
    /// 页面销毁
    deinit {
        fireEvent(.destroyed)
    }
}

// MARK: - Factory
extension SmartWebView {
    // 配置信息
    static func createConfiguredWebView(userAgent: String? = nil, bridge: WKScriptMessageHandler, injectedJS: String) -> WKWebView {
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        
        contentController.add(bridge, name: "NativeListener")
        
        let userScript = WKUserScript(
            source: injectedJS,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: false
        )
        contentController.addUserScript(userScript)
        
        config.userContentController = contentController
        
        if let ua = userAgent {
            let defaultUa = userAgentString() + "," + ua
            config.applicationNameForUserAgent = defaultUa
        }
        
        config.allowsInlineMediaPlayback = true
        
        
        return WebViewPool.shared.dequeueWebView(configuration: config)
    }
    
    static func userAgentString() -> String {
        /*
         识别 Lbank 标识：LBank
         识别 Lbank 版本：LbankVersion/1.x.x
         识别 Lbank Theme: LbankTheme/light
         */
//        NSString *customUserAgent = [NSString stringWithFormat:@"_LBANK_LBANK/iOS/%@_%@/%@/%@/2_LBANK_", [LBVersionTool getCurrentVersion], [LBVersionTool getCurrentBuildNum], [NSString getCurrentDeviceModel], [[UIDevice currentDevice] systemVersion]];
//        configuration.applicationNameForUserAgent = customUserAgent;
        return "iOS"
    }
    
}

// MARK: - WKNavigationDelegate
extension SmartWebView {
    // 页面开始加载---> 这个线不用
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        let scheme = url.scheme?.lowercased() ?? ""
        
        // 如果是自定义 Scheme（非 http/https）
        if scheme != "http" && scheme != "https" {
//            if UIApplication.shared.canOpenURL(url) { // 这个需要配置 LSApplicationQueriesSchemes 校验用的scheme
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }
            // 拦截 WebView，不让它自己跳转
            decisionHandler(.cancel)
            return
        }
        
        
        fireEvent(.beforeCreate)
        decisionHandler(.allow)
    }
    
    // 加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        fireEvent(.mounted)
    }

}



// MARK: - JS -> Native
extension SmartWebView {
    func handleJSCall(_ message: WKScriptMessage, webView: WKWebView) {
        guard let bodyString = message.body as? String,
              let body = bodyString.jsonObject() as? [String: Any],
              let cmd = body["cmd"] as? String else {
            handleUnknownJSCall(message, webView: webView)
            return
        }
        
        let params = body["params"]
        let clientcallid = body["clientcallid"] as? String
        print("====params:",params ?? "无");
        let response = LBKSendMessageMode(code: 0, cmd: cmd, clientcallid: clientcallid, message: nil,  data:nil)
        
        // TODO: Add specific action handlers here
        switch LBKJSCallType(rawValue: cmd) {
        case .getUserInfo:
            getUserInfo(message: response)
            print(cmd)
            
        case .requireLogin:
            print(cmd)
        case .showShare:
            print(cmd)
        case .openNewWeb:
            print(cmd)
        case .toPrevious:
            print(cmd)
        case .getSystemInfo:
            print(cmd)
        case .setItemSync:
            print(cmd)
        case .getItemSync:
            print(cmd)
        case .removeItemSync:
            print(cmd)
        case .toNativePage:
            print(cmd)
        case .setupNavigationBar:
            print(cmd)
        case .chooseImage:
            print(cmd)
        case .showAlert:
            print(cmd)
        case .hideAlert:
            print(cmd)
        case .downloadImage:
            print(cmd)
            
        default:
            print("未知指令：\(cmd)")
            handleUnknownJSCall(message, webView: webView)
        }
    }
    
    /// 处理未知指令信息
    func handleUnknownJSCall(_ message: WKScriptMessage, webView: WKWebView) {
        print("未知的 JS 调用，未处理：\(message.body)")
        let js = "window._nativeCallback && window._nativeCallback({ success: false, error: 'native method not found' });"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    // 新增各种处理方法，回调也需要补充，然后看消息队列需要怎么实现
 
}


// MARK: - Native -> JS
extension SmartWebView {
    
    func callJSBridge(status: LBKNativeCallType,
                      result:[String: Any],
                      completion:((Result<Any?, Error>) -> Void)? = nil) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: []),
              let jsonString = String(data: jsonData, encoding: .utf8)?.urlEncode() else {
            print("无法序列化 result")
            return
        }
        
        let jsCode = "LBKJsBridge.\(status.rawValue)('\(jsonString)');"
//        print(jsCode)
        evaluateJS(jsCode, completion: completion)
    }
    
    func fireEvent(_ event: LBKWebLifeCycle, completion: ((Result<Any?, Error>) -> Void)? = nil) {
        let jsCode = "LBKJsBridge.fireEvent('\(event.rawValue)');"
        evaluateJS(jsCode, completion: completion)
    }
    
    
    func evaluateJS(_ script: String, completion: ((Result<Any?, Error>) -> Void)? = nil) {
        webView.evaluateJavaScript(script) { result, error in
            if let error = error {
                completion?(.failure(error))
            } else {
                completion?(.success(result))
            }
        }
    }
}
