//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

/*:
 #### 单元测试注意点
 
 */
let param = ["mobile":"17657633326","code":"123456","nickname":"肉松","password":"111111","sex":0] as [String: Any]

let exception = self.expectation(description: "测试注册信息") // 此处需要使用self.exceptation来创建一个异常信息

NetworkManager.post(url: API.phoneRegister.rawValue, param:param).responseDealedJSON { (isError, data, msg) in
    exception.fulfill()     // 填充异常信息或者结束
    XCTAssertTrue(true)     // 断言结果
}

self.waitForExpectations(timeout: 10) { (error) in          // 等待异常，并处理错误信息
    print("结束测试:error:\(error.debugDescription)")
}

//: [Next](@next)
