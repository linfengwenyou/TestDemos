//: ### [Previous](@previous)
//: ---
import Foundation


/*: 基本语法
```
{(argument) in
    // 事件
}
```
 */
let myBlock = {(str:String) in
    print(str)
}

myBlock("hello word")


func doWork(block:()->()) {
    block()
}

doWork{
    print("do work")
}

//: 完整写法
// 有时会出现无法获取正当值得情况
func dowWorkComplete(_ block:()->()) -> () {
    block()
}

dowWorkComplete {
    print("this is complete version")
}
//: 逃逸闭包
// 如果闭包不是立刻执行，而是等待一段时间，就需要将其标记为可以存储一段时间，使用@escaping
func doWorkEscap(block:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline:.now() + 2.5) {
        block()
    }
}


doWorkEscap {
    print("hello work")
}

//: 别名
typealias Block = (String)->()
let a:Block = {print($0)}

a("hello typealias block")

//: 返回一个block
func giveMeAblock(str: String) -> (String)->() {
    return {(a) in print(str + a)}
}

let b = giveMeAblock(str: "hello this is a given block")
b(" hey -----")

//: ---
//: ### [Next](@next)
