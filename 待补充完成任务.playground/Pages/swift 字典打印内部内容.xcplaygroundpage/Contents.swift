//: [Previous](@previous)

import Foundation

let dict = ["key1":"value1","key2":"value2","key3":"value3"]

/*直接打印：
po dict
▿ 3 elements
▿ 0 : 2 elements
- key : "key2"
- value : "value2"
▿ 1 : 2 elements
- key : "key1"
- value : "value1"
▿ 2 : 2 elements
- key : "key3"
- value : "value3"
*/

//使用 dict.description 来获取数据即可
//po dict.description
//"[\"key2\": \"value2\", \"key1\": \"value1\", \"key3\": \"value3\"]"
// JSON 解析出来的结构
print(dict)
//: [Next](@next)
