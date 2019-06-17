//: [Previous](@previous)

import Foundation


// 集合



// 职权分离，
// 序列 只读， 获取整体长度
// 遍历 只用来遍历，需要协议开放需要的类型用作处理信息，
// 算法 用来处理各种其他的计算结构


struct FiboIterator: IteratorProtocol {
    typealias Element = Int
    private var state = (0,1)
    mutating func next() -> Int? {
        let nextNumber = state.0
        self.state = (state.1, state.0 + state.1)
        return nextNumber
    }
}

struct Fibonacci: Sequence {
    typealias Element = Int
    typealias Iterator = FiboIterator
    
    func makeIterator() -> Fibonacci.Iterator {
        return FiboIterator()
    }
}

// 定义一个协议时，有的时候声明一个或多个关联类型作为协议定义的一部分将会非常有用。关联类型为协议中的某个类型提供了一个占位名（或者说别名），其代表的类型再协议被采纳时才会被指定。你可以通过associatedtype关键字来指定关联类型。

print("\(Int.self == Int.self)")

var one = Fibonacci().makeIterator()
print(one.next()!)

print(one.next()!)
print(one.next()!)
print(one.next()!)

// Self 只能用于类中返回当前类型，或者用于协议中返回自身； 不能直接用于结构体的返回结构中

class A {
    
    class func classMethod() -> Self {
        
        let dd = Template(type: self)
        return dd
    }
    
    class func Template<T>(type: T.Type) -> T {
        return A() as! T
    }
    
    //    required init() {}
    func instanceMethod() -> Self {
        
        return self
    }
}
//: [Next](@next)
