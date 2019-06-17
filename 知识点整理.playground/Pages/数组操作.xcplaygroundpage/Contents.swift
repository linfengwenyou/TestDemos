//: [Previous](@previous)

import Foundation

//: 非空数组的情况
let temp = [1,20,34,12]
// 求和
let sum = temp.reduce(0,+)
print(sum)

// 求最大值
let max = temp.reduce(temp.first!) { (x, y) in
    x > y ? x : y
}
print(max)

// 求最小值
let min = temp.reduce(temp.first!) { (x , y) -> Int in
    x < y ? x : y
}
print(min)

//: 空数组的情况
let temp1:[Int] = []

// 求和
let sum1 = temp1.reduce(0, +)
print("sum1:\(sum1)")

// 求最大值
let max1 = temp1.first.flatMap{
    temp1.reduce($0, { (x, y) -> Int in
        x > y ? x : y
    })
}

print("max1:\(max1)")

// 求最小值
let min1 = temp1.first.flatMap{
    temp1.reduce($0, { (x , y ) -> Int in
        x < y ? x : y
    })
}

print("min1:\(min1)")


// 打印乘法口诀
for i in 11...19 {
    var tempString = ""
    for j in 11...i {
        tempString.append(String.init(format: "\(j) x \(i) = %-5d ", i*j))
    }
    print(tempString)
}




//: [Next](@next)
