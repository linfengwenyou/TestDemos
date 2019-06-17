//: ### [Previous](@previous)
//: ---
import Foundation

/** 问题所在：
同一个类中怎样定义，初始化方法，convienience

 */

class ClassA:NSObject {
    let numA: Int
    var numbC: Int?
    
     init(num: Int) {
        print("\(#function) line:\(#line)" )
        numA = num
    }
    
    init(num: Int, c:Int = 0) {
    print("\(#function) line:\(#line)" )
        numA = num
        numbC = c
    }
    
    convenience init(bigNum: Bool) {
    print("\(#function) line:\(#line)" )
        self.init(num: bigNum ? 100000 : 1)
    }
}


class ClassB: ClassA {
    var numB: Int?
    
    convenience init(b:Int) {
        self.init(num: b+1)
        numB = b
    }
    
}



//# 如果有ClassC 是不是写init(num:c:)就可以不用写override

let b  = ClassB.init(num: 10)
b.numB
print("-----------")
let c = ClassB.init(bigNum:true )
print(c.numA)

let d = ClassB.init(bigNum: false)
print(d.numA)


let e = ClassB.init(b: 10)
print(e.numB)

/*:
 
 > Swift初始化顺序：
 * 1. 初始化自己的成员变量
 * 2. 调用父类的初始化方法，如果无第三步，可以省略
 * 3. 修改父类成员变量，可选
 
 
  > designated 方法可以被继承，如果标记为required那么所有子类实现必须实现这个方法
 
  > convenience方法可以被继承,如果需要子类重写convenience方法需要继承
  > 如果不继承，想要调用到此方法，有两种途径
  * 1. 子类不写任何designated方法
  * 2. 子类写全部的designated方法
 
  > required 只是一个标识符，用来表示子类继承时必须实现相关的方法
 
 */

//:#####  可失败的初始化


class Product {
    let name: String
    init?(nam: String) {
        if nam.isEmpty {
            return nil
        }
        name = nam
    }
}

let p = Product(nam: "")
print(p?.name)

let p1 = Product(nam: "hahah")
print(p1?.name)
//: ---
//:### [Next](@next)
