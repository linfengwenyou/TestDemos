//:### [Previous](@previous)
//: ---

import Foundation

/*:
 map 和flatMap是Swift常用的两个函数
 map用于将每个元素进行响应的映射，便捷处理个中数据信息
 flatMap有两个功能： 1. 数组降维； 2. 数据去空
 */

//: map转换内部元素
var numbers = [1,2,3,4]
let result = numbers.map { "\($0) haha" }
let result1 = numbers.map{ i -> Int? in
    if(i % 2 == 0) { return i }
    else { return nil }
}

//: flatMap功能1：数组降维
let arr1 = [[1,2,3],[4,5,6]]

var flatValue = arr1.flatMap { (tmpArr) -> [Int] in
    tmpArr.map({ $0 * 10 })
}

var flatValue1 = arr1.flatMap { $0 }

//: flatMap功能2：数据去重
let arr2 = [12,3,nil,10]
var nonilArr = arr2.flatMap{ $0 }
print(nonilArr)


//: 练习：从一个数组中获取所有的奇数
// 1. 使用Filter
numbers = [1,2,3,4,5,6,7,8,9,10]
let values = numbers.filter{$0%2 != 0}
print(values)

// 2. 使用map
let values1 = numbers.map ({ (i) -> Int? in
    if(i % 2 != 0) { return i }
    else { return nil }
}).filter { $0 != nil}
print(values1)

// 3. 使用flatMap
let values2 = numbers.flatMap{ (i) -> Int? in
    if(i % 2 != 0) { return i }
    else { return nil }
}
print(values2)


// 延伸使用日期转换
let date:NSDate? = NSDate()
let formatter = DateFormatter()
formatter.dateFormat = "YYYY-MM-dd"
var formatedDate:String? = nil
if let date = date {
    formatedDate = formatter.string(from: date as Date)
}

print(formatedDate)

let date2:NSDate? = NSDate()
let formatter2 = DateFormatter()
formatter.dateFormat = "YYYY-MM-dd"
let formatedDate2 = date2.map{ formatter.string(from: $0 as Date) }
print(formatedDate2)

let formatedDate3 = date2.flatMap{ formatter.string(from: $0 as Date) }     // 为什么不使用Date 是因为Date没有map方法
print(formatedDate3)



//: ---
//:### [Next](@next)
