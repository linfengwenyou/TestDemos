//:### [Previous](@previous)
//: ---
import Foundation

//:#### 泛型
/*:
 > 使用泛型：
 * 按类型处理，抽象化方法
 * 优化内存展示
 *
 */

//let numbers: Buffer = [1,1,1,1,1,1,2,2,3,4,4,5]               // 整型数组 占用内存相当规整
//let numbers:Buffer = [1,1,2,32,234,3,34,"hahah",234]          // Any 类型数组，占据内存就比较大了，如果是Rect对象将会更加明显

struct Buffer<Element> {
    var count: Int {
        return arr.count
    }
    var arr:Array<Element>
    subscript(at: Int)-> Element {
        return arr[at]
    }
}

var b:Buffer<Int> = Buffer(arr: [1,2,23,4,5,5])
print(b[2])
//:----
// 框架内部使用，但是需要开放出Item给外部使用，为了统一规范使用
protocol CommonDelegate {
    associatedtype Item
    func invoke(with item: Item)
}

protocol MainDelegate:CommonDelegate {
    func save(with Item:Item)
}


// 自己的代理配置信息
protocol FooDelegate {
    var name:String {get set}
    var id:Int {get set}
    var desc:String {get}
}


class Foo:FooDelegate {
    var name: String
    var id:Int
    
    var desc:String {
        return "\(name):\(id)"
    }
    
    init(name:String, id: Int) {
        self.name = name
        self.id = id
    }
}

//class Main {
//    var delegate:MainDelegate!   // 此处需要配置出Item值信息
//
//    fun breed() {
//    let newFoo = Foo(name:"hopy", id:1)
//    self.delegate.save(with:newFoo)
//    }
//}

class Main<T> where T: MainDelegate, T.Item:FooDelegate {
    var delegate:T!
    
    func breed() {
        let newFoo = Foo(name: "hopy", id: 1) as! T.Item
        self.delegate.save(with: newFoo)
    }
}


class Maker: MainDelegate {
    typealias Item  = Foo
    var main:Main<Maker>!
    
    func didLoad() {
        main = Main<Maker> ()
        main.delegate = self
        main.breed()
    }
    
    func invoke(with item:Item) {
        print("invoke item:\(item.desc) done!!!")
    }
    
    func save(with item:Item) {
        print("save item [\(item.desc)] done!!!")
    }
    
}
//: ---
//: ### [Next](@next)
