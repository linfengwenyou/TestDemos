//
//  LBKWebViewBridge.swift
//  SmartWebViewDemo
//
//  Created by Buck on 2025/6/11.
//

import Foundation
import WebKit

protocol SmartWebViewJSHandler: AnyObject {
    func handleJSCall(_ message: WKScriptMessage, webView: WKWebView)
    func handleUnknownJSCall(_ message: WKScriptMessage, webView: WKWebView)
}


final class JSBridge: NSObject, WKScriptMessageHandler {
    weak var delegate: SmartWebViewJSHandler?
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "NativeListener" {
            delegate?.handleJSCall(message, webView: message.webView!)
        } else {
            delegate?.handleUnknownJSCall(message, webView: message.webView!)
        }
    }
}
