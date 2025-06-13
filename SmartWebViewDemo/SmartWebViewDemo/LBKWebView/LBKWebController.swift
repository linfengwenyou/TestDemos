//
//  LBKWebController.swift
//  SmartWebViewDemo
//
//  Created by Buck on 2025/6/11.
//

import Foundation
import UIKit
import SnapKit

// MARK: - LBKWebController
class LBKWebController: UIViewController {
    private let smartWebView = SmartWebView(userAgent: "LBKApp/1.0")
    private let urlToLoad: URL?
    private let htmlToLoad: String?
    private let baseURL: URL?
    
    init(url: URL) {
        self.urlToLoad = url
        self.htmlToLoad = nil
        self.baseURL = nil
        super.init(nibName: nil, bundle: nil)
    }
    
    init(html: String, baseURL: URL? = nil) {
        self.urlToLoad = nil
        self.htmlToLoad = html
        self.baseURL = baseURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(smartWebView)
        smartWebView.frame = UIScreen.main.bounds
//        smartWebView.snp.makeConstraints {make in
//            make.leading.trailing.equalTo(0)
//            make.top.equalTo(self.view.safeAreaInsets.top).offset(44)
//            make.bottom.equalTo(-self.view.safeAreaInsets.bottom)
//        }
       
        
        if let url = urlToLoad {
            smartWebView.load(url: url)
        } else if let html = htmlToLoad {
            smartWebView.load(html: html, baseURL: baseURL)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        smartWebView.recycle()
    }
}
