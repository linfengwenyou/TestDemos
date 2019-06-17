//: ### [Previous](@previous)
//: ---

import Foundation


//: ### 与异常一起的处理
//: > try? / try! / try

//: * try?
//: try? 会将一个错误转换为可选值，当调用try? + 函数 或方法语句的时候，如果函数或方法抛出错误，程序不会崩溃，而返回一个nil，如果没有抛出错则返回可选值
//: try! 取消异常捕获逻辑，明知可能抛出异常，但自信这段代码不会抛出异常。是try?的补充，会中断异常链的传递
//: try! try? 是用于直接使用而 try只在do catch内部才使用
/*:
 try 可以接!标识强制执行，这代表你确定知道这次调用不会抛出异常。如果在调用中出现了异常的话，你的程序将会崩溃，这和我们在对Optional值用!进行强制解包时的行为是一致的。
 
 另外，我们也可以在try后面加上?来进行尝试性的运行。try?会返回一个Optional值：如果运行成功，没有抛出错误的话，他会包含这条语句的返回值，否则将为nil.和其他返回Optional的方法类似，一个典型的try?的应用场景是和if let 这样的语句搭配使用，不过如果你用来try?的话，就意味着你无视了错误的具体类型：
 
 
 __注意__ 在一个可以throw的方法里，我们永远不应该返回一个Optional的值。因为结合try?使用的话，这个Optional的返回值将被再次包装一层Optional，使用这种双重Optional的值非常容易产生错误，也容易让人迷惑
 */
enum DAOError:Error {
    case NoData
}

let listData = [String]()
func findAll() throws -> [String] {
    guard listData.count > 0 else {
        throw DAOError.NoData
    }
    return listData
}

let datas = try?findAll() // 使用这种方式和使用下面tryCatch是一样的，只是如果有异常则返回nil
print(datas)

//let datas: [String]?
//do {
//    datas = try findAll()
//} catch DAOError.NoData {
//    print("无数据异常")
//    datas = nil
//}
//
//print(data)




//: ---
//: ### [Next](@next)
