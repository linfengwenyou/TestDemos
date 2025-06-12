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

let EASY_JS_INJECT_STRING = """
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

enum LBKListeCallType: String {
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



class SmartWebView: UIView, SmartWebViewJSHandler {
    private(set) var webView: WKWebView
    private let bridge = JSBridge()
    
    init(userAgent: String? = nil) {
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        contentController.add(bridge, name: "NativeListener")
        
        let userScript = WKUserScript(
            source: EASY_JS_INJECT_STRING,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: false
        )
        
       contentController.addUserScript(userScript)

        config.userContentController = contentController
        if let ua = userAgent {
            config.applicationNameForUserAgent = ua
        }
        self.webView = WebViewPool.shared.dequeueWebView(configuration: config)
        super.init(frame: .zero)
        
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
        switch LBKListeCallType(rawValue: cmd) {
        case .getUserInfo:
            let result = [
                "success": true,
                "data": ["userId": "123456", "token": "abcdefg"]
            ] as [String : Any]
            respondToJS(webView: webView, callId: clientcallid ?? "", result: result)
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
    
    func respondToJS(webView: WKWebView, callId: String, result: [String: Any]) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: result),
              let jsonString = String(data: jsonData, encoding: .utf8) else { return }
        
        let js = "window._nativeCallback && window._nativeCallback({ clientcallid: '\(callId)', result: \(jsonString) });"
        webView.evaluateJavaScript(js, completionHandler: nil)
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
