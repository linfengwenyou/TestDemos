//
//  LBKWebView.swift
//  SmartWebViewDemo
//
//  Created by Buck on 2025/6/11.
//

import Foundation
import UIKit
import WebKit
import SnapKit

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
    /// 打开新的H5
    case openNewWeb = "openNewPage"
    /// 跳转原生页面
    case toNativePage = "jumpNativeUiView"
    /// 设置导航条
    case setupNavigationBar = "setNavigationbar"
    /// 回退上一页
    case toPrevious = "goBackToPage"
    /// 拦截弹框
    case showAlert = "setBreakbackInfos"
    /// 关闭弹框---> 这个是否有必要
    case hideAlert = "clearBreakBackInfos"
    
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
        self.webView = SmartWebView.createConfiguredWebView(bridge: bridge, injectedJS: injectJSString)
        super.init(frame: .zero)
        
        self.webView.navigationDelegate = self
        
        bridge.delegate = self
        addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
       
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
            config.applicationNameForUserAgent = ua
        }
        
        return WebViewPool.shared.dequeueWebView(configuration: config)
    }
}

// MARK: - WKNavigationDelegate
extension SmartWebView {
    // 页面开始加载
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void) {
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
//        print("JS 调用原生方法：\(cmd), 参数: \(String(describing: params)), 调用ID: \(String(describing: clientcallid))")
        // TODO: Add specific action handlers here
        switch LBKJSCallType(rawValue: cmd) {
        case .getUserInfo:
//            let result = [
//                "success": true,
//                "data": ["userId": "123456", "token": "abcdefg"]
//            ] as [String : Any]
//            respondToJS(webView: webView, callId: clientcallid ?? "", result: result)
            print(cmd)
            
        case .requireLogin:
            print(cmd)
        case .openNewWeb:
            print(cmd)
        case .toNativePage:
            print(cmd)
        case .setupNavigationBar:
            print(cmd)
        case .toPrevious:
            print(cmd)
        case .showAlert:
            print(cmd)
        case .hideAlert:
            print(cmd)
            
        default:
            print("未知指令：\(cmd)")
            handleUnknownJSCall(message, webView: webView)
        }
    }
    
    func handleUnknownJSCall(_ message: WKScriptMessage, webView: WKWebView) {
        print("未知的 JS 调用，未处理：\(message.body)")
        let js = "window._nativeCallback && window._nativeCallback({ success: false, error: 'native method not found' });"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    
    // 新增各种处理方法，回调也需要补充，然后看消息队列需要怎么实现
    
    
}


// MARK: - Native -> JS
extension SmartWebView {
    
//    func respondToJS(webView: WKWebView, callId: String, result: [String: Any]) {
//        guard let jsonData = try? JSONSerialization.data(withJSONObject: result),
//              let jsonString = String(data: jsonData, encoding: .utf8) else { return }
//        
//        let js = "window._nativeCallback && window._nativeCallback({ clientcallid: '\(callId)', result: \(jsonString) });"
//        webView.evaluateJavaScript(js, completionHandler: nil)
//    }
    
    
    func callJSBridge(status: LBKNativeCallType,
                      result:[String: Any],
                      completion:((Result<Any?, Error>) -> Void)? = nil) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: []),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            print("无法序列化 result")
            return
        }
        let jsCode = "LBKJsBridge.\(status.rawValue)(\(jsonString));"
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
