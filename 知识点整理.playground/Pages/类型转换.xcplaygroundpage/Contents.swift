//:### [Previous](@previous)
//: ---
import Foundation

class Person {
    var name:String
    var age:Int
    init(_ name: String, age:Int) {
        self.name = name
        self.age = age
    }
}

class Student:Person {
    var grade:Int?
    var className:String?
    init(_ name: String, age: Int ,grade:Int, className:String) {
        super.init(name, age: age)
        self.grade = grade
        self.className = className
    }
}

class Adult:Person {
    var workName:String?
    init(_ name: String, age: Int, workName:String) {
        super.init(name, age: age)
        self.workName = workName
    }
}

let lili = Student("liusong", age: 27, grade: 12, className: "学习班")//Student("liusong", age: 27,grade:12,className:"学习班")

print(lili.name)
let jimmy = lili as! Person
print(jimmy.name)
print(jimmy is Adult)

//switch lili {
//case let jimmy = lili as! Adult:
//     print("lili 是 Student类型")
//case let jimmy = lili as! Student:
//    print("lili 是 Student")
//default:
//     print("lili ")
//}

//if let a = lili as Person {
//    print("lili 是 Person类型")
//}
//
//if let a = lili as? Adult {
//    print("lili 是 Adult类型")
//}
//
//if let a = lili as? Student {
//    print("lili 是 Student类型")
//}

/*:
 > as
 用于向上转换，由派生类转换为基类
 
 > as!
 强制转换，从上向下转换,转换失败会crash
 
 > as?
 非强制转换，从上向下，转换失败会返回一个nil
 
 参考地址：https://www.jianshu.com/p/49ea11865156
 */


//: ---
//: ### [Next](@next)
