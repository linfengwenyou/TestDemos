//
//  LBKWebViewPool.swift
//  SmartWebViewDemo
//
//  Created by Buck on 2025/6/11.
//

import WebKit

final class WebViewPool {
    static let shared = WebViewPool()
    private var pool: [WKWebView] = []
    
    private init() {}
    
    func dequeueWebView(configuration: WKWebViewConfiguration? = nil) -> WKWebView {
        if let webView = pool.popLast() {
            return webView
        }
        return WKWebView(frame: .zero, configuration: configuration ?? WKWebViewConfiguration())
    }
    
    func enqueue(_ webView: WKWebView) {
        webView.stopLoading()
        webView.navigationDelegate = nil
        webView.uiDelegate = nil
        pool.append(webView)
    }
}
