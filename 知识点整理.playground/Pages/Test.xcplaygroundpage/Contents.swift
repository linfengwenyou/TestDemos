//: [Previous](@previous)

import Foundation


struct A {
    let b:B
}

struct B {
    let c:C
}

struct C {
    let d:D
}

struct D {
    let e:String
}


let a = A(b: B(c: C(d: D(e: "helloword"))))

let myMirror = Mirror.init(reflecting: a)

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
            offsetBy: 3,
            limitedBy: greatGrandChildren.endIndex),
            i2 != greatGrandChildren.endIndex
        {
            // Success!
            result = greatGrandChildren[i2].value
        }
    }
}

print("this is a test")
print(result)


//: [Next](@next)
