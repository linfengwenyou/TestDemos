//
//  ViewController.swift
//  SmartWebViewDemo
//
//  Created by Buck on 2025/6/11.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let vc = LBKWebController(url: URL(string: "https://m.lbk.world/zh-TC/js-bridge")!)
        navigationController?.pushViewController(vc, animated: true)
        
        // 或加载 HTML
//        let vc = LBKWebController(html: "<html><body>Hello World</body></html>")
//        navigationController?.pushViewController(vc, animated: true)
    }
}

