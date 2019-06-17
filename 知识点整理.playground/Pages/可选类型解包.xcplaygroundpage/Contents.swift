//: ### [Previous](preView)
//: ---
import Foundation

var num: Int?
//: 意思不是“我声明了一个Optional的Int值”，而是"我声明了一个Optional类型值，它可能包含一个Int值，也可能什么都不包含"
num = 10
if num is Optional<Int> {
    print("它是可选类型")
} else {
    print("它是Int类型")
}

//:### 解包策略

//: * 强制解包
func getHeight(_ height: Float?) -> Float? {
    if height != nil {
        return height! / 100
    }
    return nil
}

getHeight(nil)

//: * if 解包
func getHeight_if(_ height: Float?) -> Float? {
    if let unwrapHeight = height {
        return unwrapHeight / 100
    }
    return nil
}

getHeight_if(1)

//: * guard 解包
func getHeight_guard(_ height: Float?) -> Float? {
    guard let unwrapHight = height else {
        return nil
    }
    return unwrapHight / 100
}

getHeight_guard(10)



//: ---
//: ### [Next: try Catch](@next)
