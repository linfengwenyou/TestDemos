//: ### [Previous](@previous)
//: ---
import Foundation

class MyView {

    //: 懒加载一个字符串
    lazy var tmpString = "这是个懒加载的串"
    
    //: 懒加载一个闭包
    lazy var tmpArr : Array = {
        return ["测试1","测试2","测试3"]
    }()
    
    // 懒加载一个函数
    lazy var tmpFunction: String = MyView.test()
    static func test()->String {
        return "这个是函数懒加载测试"
    }
    
    /*:
     
     以上为三种
     其中第二种使用起来最方便，直接以闭包的方式使用
     懒加载的配 置需要在类或及结构体中处理，此外需要注意点： lazy var    后面block的立即执行()
     
     */
    
}

let myView  = MyView()
myView.tmpString
myView.tmpArr
myView.tmpFunction
/*:
 #### 文件访问权限
 > 从上到下，访问限制逐渐变小
 * private, 隐藏实现细节；修饰属性，方法和类                                > 类、同文件内的类拓展
 * fileprivate,隐藏函数内部的实现细节，修饰属性，方法和类                    > 同文件内【可以不同类】可访问
 * internal, 默认是此权限，模块内可直接访问                                > 静态库，模块内可访问
 > internal 访问级别修饰的方法或属性，类在源代码的整个模块都可以访问。
 > 如果是框架或库代码，则在整个框架内部都可以访问，框架由外部代码所引用时，则不可访问。
 > 如果是App代码，也是在整个App代码，可以在整个App内部访问ß
 * public， 开放属性，其他模块使用不可以继承                                 > 可供其他模块访问，但是不能继承
 * open, 开放属性，其他模块可以继承使用                                     > 可供其他模块访问，可继承
 */




//: ---
//: #### [Next](@next)
