//: [Previous](@previous)

import Foundation

/*:
 正则表达式用处：
 * 1. 获取匹配的字符串，可能是个数组
 * 2. 验证字符串是否符合规格
 * 3. 计算匹配到的数量
 */

/*:
 ```
 let regular = try? NSRegularExpression(pattern: pattern, options: [])
 ```
 ## 参数分析：
 ### pattern 表示模式，以这个表达式为模式去判断别的字符串是否符合这个模式
 ### options 表示正则操作中需要进行的配置处理
 * caseInsensitive:      忽略模式中大小写
 
 ```
 pattern = "t h e"   可以匹配成功字符串 "the"
 ```
 
 * allowCommentsAndWhitespace  忽略模式中的空格，和前缀字符 ’#‘
 ```
 
 var pattern = """
 t
 # look for a T
 [a-z] # then any lowercase letter
 e # then an e
 """
 
 可以成功匹配"the"
 ```
 * ignoreMetacharacters  忽略掉元字符的意义； 元字符有特殊含义，比如 . 代表任意， * 零个或多个， \d 匹配任何数组，如果使用此配置就会忽略掉元字符，把它们当成普通字符来处理
 ```
 var pattern = "t+he"
 
 这里的 ’+‘ 不代表元字符，1个多个的意思，只用来当成普通的加号展示
 能匹配成功的只有"t+h3"
 ```
 
 * dotMatchesLineSeparators
 默认情况下, 元字符'.'匹配除换行符之外的任何单个字符，并且通常与两次一起使用，以匹配*和?匹配位置文本的范围。
 使用这个操作意思就是 '.' 也可以匹配换行符
 
 ```
 var pattern = "The.+cat.+sat"
 
 可以匹配字符串， sat前面是一个换行符， 使用这个选项可以让 '.' 匹配换行符
 let str = """
 The cat
 sat on
 the mat
 """
 
 ```
 
 * anchorsMatchLines
 
 在'^'和'$' 元字符允许我们行的开始和结束匹配，但这只是个期望，现实却不是那么回事。
 正则表达式最初设计为一次处理一行文本，但现在一次解析数百甚至数千个更常见。
 为了保持向后兼容性，大多数程序化正则表达式引擎(即代码中使用的引擎)都将行的开头和结尾视为整个文本的开头和结尾，无论它有多少个换行符
 
 ```
 var pattern = "^sat"
 
 let str = """
 The cat
 sat on
 the mat
 """
 
 设置其他类型处理不了，只有使用这种anchorsMatchLines才能正常匹配
 
 ```
 
 
 
 * useUnixLineSeparators
 如果你再跨平台环境中工作，会更有用。历史上，换行符已经以多种方式标识，并且正则表达式旨在和他们一起使用。例如,Unix和macOS换行符被写为'\n',但windows换行符被写为'\r\n'。 如果你特别想限制你的正则表达式，使他们只匹配Unix / macOS换行符，你应该使用.useUnixLineSeparators选项
 
 * useUnicodeWordBoundaries
 
 很长一段时间的一个湖色区域是单词边界，单词的起点和终点是什么？
 ```
 示例：如果不使用配置，下面的串可以进行匹配
 let str = """
 The child's cat
 sat on
 the mat
 """
 var pattern = "\\bchild\\b"
 ```
 
 但是我们却不想匹配child's 为child类型。幸运的是，Unicode联盟做出了非常出色的贡献，写出了一个关于什么构成单词便捷的正则定义。结果成为Unicode TR # 29, 我们可以通过添加.useUnicodeWordBoundaries来使用正则表达式启用它
 
 使用此配置后 child便无法匹配 child's了
 */

let str = """
The child's cat
sat on
the mat
"""
var pattern = "child\\b"
let regular = try? NSRegularExpression(pattern: pattern, options: [.useUnicodeWordBoundaries])


if let index = regular?.firstMatch(in: str, options: .init(rawValue: 0), range: NSMakeRange(0, str.count)) {
    print("Match！")
} else {
    print("No match.")
}





// 更简便的方式
let source:NSString = "For NSSet and NSDictionary, the breadking ..."
let typePattern = "[A-Z]{3,}[A-Za-z0-9]"

let range = source.range(of: typePattern, options: .regularExpression)




let string = source.substring(with: range)
print(string)

//: [Next](@next)

