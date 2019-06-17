//:### [Previous](@previous)
//: ---
import Foundation

//: 基本枚举
enum Direction {
    case left, right, top , bottom
}

let dire = Direction.left




//: 参数枚举【关联值】
enum Trade {
    case Buy(stock:String, amount:Int)
    case Sell(stock:String, amount:Int)
}

let trade = Trade.Sell(stock: "0123943", amount: 100)

switch trade {
case .Buy(let stock, let amount):
    print("buy \(stock)---\(amount)")
case .Sell(let stock, let amount):
    print("sell \(stock)---\(amount)")
}

//: 方法属性
enum Device {
    case iPad, iPhone, AppleTV, AppleWatch
    func introduced() -> String {   // 相当于枚举实例的一个方法，用来返回实际值
        switch self {
        case .iPad:
            return "iPad"
        case .iPhone:
            return "iPhone"
        case .AppleTV:
            return "AppleTV"
        case .AppleWatch:
            return "AppleWatch"
        }
    }
}


print(Device.iPhone.introduced())

//: 属性
// 枚举不允许存储属性，但是可以创建计算属性，当然，计算属性的内容都是建立在枚举值下或者枚举关联值得到的
enum DeviceIvar {
    case iPad, iPhone
    var year: Int {
        switch self {
        case .iPad:
            return 2007
        case .iPhone:
            return 100
        }
    }
}

let pad = DeviceIvar.iPad
print(pad.year)

//: 静态方法
enum DeviceStatic {
    case iPad, iPhone, AppleTV, AppleWatch
    func introduced() -> String {
        switch self {
        case .iPad:
            return "iPad"
        case .iPhone:
            return "iPhone"
        case .AppleWatch:
            return "AppleWatch"
        case .AppleTV:
            return "AppleTV"
        }
    }
    
    static func fromSlang(term: String) -> DeviceStatic? {
        if term == "iPad" {
            return .iPad
        }
        return nil
    }
    
}

print(DeviceStatic.fromSlang(term: "iPad"))

//: 协议
enum DeviceProtocol:CustomStringConvertible {
    case iPad, iPhone
    var description: String {
        switch self {
        case .iPad:
            return "this is iPad"
        case .iPhone:
            return "this is iPhone"
        }
    }
}

let a = DeviceProtocol.iPhone
print(a.description)


// https://www.jianshu.com/p/9c7a07163e5b
//: 扩展
enum Hands {
    case left, right
}

extension Hands: CustomStringConvertible {
    func introduced() -> String {
        switch self {
        case .left:
            return "this is left"
        case .right:
            return "this is right"
        }
    }
    
    var description: String {
        switch self {
        case .left:
            return "this is left"
        case .right:
            return "this is right"
        }
    }
    
}

let b = Hands.left
print(b.introduced())
print(b.description)

//: 泛型
enum Rubbish<T> {
    case price(T)
    func getPrice()->T {
        switch self {
        case .price(let value):
            return value
        }
    }
}


let c = Rubbish<Int>.price(100).getPrice()
let d = Rubbish<String>.price("10").getPrice()

print(c)
print(d)
//: ---
//:### [Next](@next)
