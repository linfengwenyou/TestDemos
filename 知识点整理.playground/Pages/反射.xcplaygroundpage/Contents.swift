//: ### [Previous](@previous)
//: ---

/*:
 反射就是动态获取类型，成员信息，再运行时可以调用方法、属性等行为的特性。
 在OC开发是很少强调反射的概念，是因为OC的Runtime要比其他语言中的反射强大的多。不过Swift中并不提倡使用Runtime,而是像其他语言一样使用反射(Reflect),尽管目前swift中的反射功能还比较弱，只能访问获取类型，成员信息。
 
 Swift的反射机制是基于一个叫Mirror的结构体来实现的
 ##### Mirror用到的属性
 * subjectType: 对象类型，可以对子元素使用此属性来判断格式
 * children: 反射对象的属性集合
 * displayStyle: 反射对象展示类型
 */


import Foundation

class Person {
    var name:String?
    var age:Int = 0
}

let p = Person()
p.name = "小强"
p.age = 13

print(p)
print(String(reflecting:p))


let mirror = Mirror(reflecting:p)
print("获取对象类型\(mirror.subjectType)")
//print("displayType:\(mirror.displayStyle)")


for (label, value) in mirror.children {
    print("label:\(label!) value:\(value)")
}

//: 获取对象属性名及对应值
for p in mirror.children {
    let propertyNameString = p.label!
    let value = p.value
    let vMirror = Mirror(reflecting:value)
    print("属性\(propertyNameString) 类型为：\(vMirror.subjectType) dispalyStyle:\(vMirror.displayStyle)")
}


//: 获取指定索引下的属性类型
let children = mirror.children
let p0 = children.index(children.startIndex, offsetBy: 1)
let poM = Mirror(reflecting: children[p0].value)
print(p0)
let p0M = Mirror(reflecting: children[p0].value)

print("获取属性\(children[p0].label!)的类型为\(p0M.subjectType)")


// 测试用例
class User {
    var name:String = ""  //姓名
    var nickname:String?  //昵称
    var age:Int?   //年龄
    var emails:[String]?  //邮件地址
    var tels:[Telephone]? //电话
}

struct Telephone {
    var title:String  //电话标题
    var number:String  //电话号码
}

protocol JSON {
    func toJSONModel() -> Any?
}

extension JSON {
    func toJSONModel() -> Any? {
        let mirror = Mirror(reflecting: self)
        if mirror.children.count > 0 {
            var result:[String:Any] = [:]
            for children in mirror.children {
                let propertyNameString = children.label!
                let value = children.value
                
                if let jsonValue = value as? JSON {
                    result[propertyNameString] = jsonValue.toJSONModel()
                }
            }
            return result
        }
        return self
    }
}


extension Optional:JSON {
    func toJSONModel() -> Any? {
        if let x = self {
            if let value = x as? JSON {
                return value.toJSONModel()
            }
        }
        return nil
    }
}


// 扩展两个自定义类型，使其遵循JSON协议
extension User:JSON {}
extension Telephone:JSON{}
extension String: JSON{}
extension Int:JSON{}
extension Bool:JSON{}
extension Dictionary:JSON{}
extension Array:JSON{}


// 创建一个USer实例对象模型
let user1 = User()
user1.name = "航哥"
user1.age = 100
user1.emails = ["hangge@sina.com","asldkfj@gmail.com"]

let tel1 = Telephone(title: "手机", number: "1721312312")
let tel2 = Telephone(title: "手机", number: "1721312334")

user1.tels = [tel1, tel2]

if let model = user1.toJSONModel() {
    print(model)
}



//: ### 反射子级

struct A {
    let label:String = "Label A"
    let b:B
}

struct B {
    let label:String = "label two"
    let two:C
}

struct C {
    let d:D
    let data:String = "hahaha"
}

struct D {
    let e:String
}


let a = A(b: B(two: C(d: D(e: "hello word"))))

let myMirror = Mirror.init(reflecting: a)

let data = myMirror.descendant(1, 1, 0, 0)
/*:
 > descendant使用的是多参【可以使用数字，可以使用key】
 
    * 1 代表第1个，默认从0开始 A的第一个为b:B
    * 1 B的第一个为 two:C
    * 0 C的第0个为d:D
    * 0 D的第0个为e:String
*/
print(data)
// Optional("hello word")
let data1 = myMirror.descendant(1, 1, "data")
// Optional("hahaha")
//: #### 内部实现逻辑为下


var result: Any? = nil
let children = myMirror.children
if let i0 = children.index(
    children.startIndex, offsetBy: 1, limitedBy: children.endIndex),
    i0 != children.endIndex
{
    let grandChildren = Mirror(reflecting: children[i0].value).children
    if let i1 = grandChildren.firstIndex(where: { $0.label == "two" }) {
        let greatGrandChildren =
            Mirror(reflecting: grandChildren[i1].value).children
        if let i2 = greatGrandChildren.index(
            greatGrandChildren.startIndex,
            offsetBy: 1,
            limitedBy: greatGrandChildren.endIndex),
            i2 != greatGrandChildren.endIndex
        {
            // Success!
            result = greatGrandChildren[i2].value
        }
    }
}

print(result)




//: ---
//: ### [Next](@next)
