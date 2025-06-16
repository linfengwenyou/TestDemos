//
//  LBKWebCommands.swift
//  SmartWebViewDemo
//
//  Created by Buck on 2025/6/16.
//

import Foundation
extension SmartWebView {
    // 获取用户信息
    func getUserInfo(message: LBKSendMessageMode) {
        let data = ["test":222,"success":true].toJsonString()
        // 这个data是实际要展示的数据，要方便外部传入，至于，其他的可以外部要求
        message.data = data
        message.code = 200
        callJSBridge(status: .done, result: message.toDictionary())
      
    }
    
    
}
/*
 //            let failedModel = LBKSendMessageMode(code: 400, cmd: cmd, clientcallid: clientcallid,message: "sucess get userInfo", data:data)
 //            callJSBridge(status: .failed, result: failedModel.toDictionary())
 
 //            let cancelModel = LBKSendMessageMode(code: 400, cmd: cmd, clientcallid: clientcallid, message: nil, data: data)
 //            callJSBridge(status: .canceled, result: cancelModel.toDictionary())
 
 
 */
