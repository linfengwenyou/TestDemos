//: [Previous](@previous)

import Foundation

class Person {
    var name:String = ""
    init(_ name:String) {
        self.name = name
    }
}



// 配置数据信息
let p2 = Person.init("hello word")
let nameKeyPath = \Person.name
let name = p2[keyPath:nameKeyPath]
print(name)

//: \Person.name 就是Swift4中新的key path用法，他是一个独立的类型，带有类型的信息。因此，编译器会发现错误类型的赋值，因此不会吧这个错误延迟到运行时


p2[keyPath:nameKeyPath] = "word"
print(p2.name)



//: [Next](@next)
