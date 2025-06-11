//
//  LBKWebMessageModel.swift
//  SmartWebViewDemo
//
//  Created by Buck on 2025/6/11.
//

import Foundation

// native->JS使用的模型
struct LBKSendMessageMode: Codable {
    let code: Int
    let message: String
    let cmd: String
    let clientcallid: String?
    let data: String?
    
    // 参数比较少，直接转换，效率高
    func toDict() -> [String: Any] {
        var dict: [String: Any] = [
            "code": code,
            "message": message,
            "cmd": cmd,
            "clientcallid": clientcallid
        ]
        if let data = data {
            dict["data"] = data
        }
        return dict
    }
    
}



extension String {
    
    func messageModel() -> LBKSendMessageMode? {
        guard let jsonData = self.data(using: .utf8) else {return nil}
        guard let result = try? JSONDecoder().decode(LBKSendMessageMode.self, from: jsonData)  else {
            return nil
        }
        return result
    }
    
    // 转换为JSON对象
    func jsonObject() -> Any? {
        guard let data = self.data(using: .utf8) else {return nil}
        return try? JSONSerialization.jsonObject(with: data, options: [])
    }
}
