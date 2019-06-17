//: [Previous](@previous)

import Foundation

// 类 元类
/*:
 类：用来区分某一事物的抽象集合体，具有这些事物的通用属性，和可以操作的方法
 元类也是一种类
 
 
 从功能上分：
 类：掌控着抽象事物的通用属性，和可操作的方法
 元类：掌控着这些事物的操作方法，层面上不一样。
 
 
 从方法查找的链表上看，查找实例方法走的是类的方法列表，而类方法走的是元类的方法列表。
 如果合并在一起这个列表结构就会变得很大。
 
 类方法更像是 更有抽象意义的方法抽象出来供所有实现的类直接使用。
 
 
 引申问题：对象方法和类方法为什么不合并在一起呢？
 1. 方法列表中数据大，查找起来效率低
 
 
 
 类方法好处：
 1. 不依赖于对象，执行效率高？； 直接用类名调用
 2. 能用类方法尽量使用
 3. 抽象标准：当方法内部不需要使用成员变量时
 
 
 */

//    分别有什么用，实现什么功能，为什么不合并一起用，原型结构怎样

// 类：
/*:
 ```
 typedef struct objc_class *Class;
 
 /// Represents an instance of a class.
 struct objc_object {
 Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
 };
 
 
 
 struct objc_class {
 Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
 
 #if !__OBJC2__
 Class _Nullable super_class                              OBJC2_UNAVAILABLE;
 const char * _Nonnull name                               OBJC2_UNAVAILABLE;
 long version                                             OBJC2_UNAVAILABLE;
 long info                                                OBJC2_UNAVAILABLE;
 long instance_size                                       OBJC2_UNAVAILABLE;
 struct objc_ivar_list * _Nullable ivars                  OBJC2_UNAVAILABLE;
 struct objc_method_list * _Nullable * _Nullable methodLists                    OBJC2_UNAVAILABLE;
 struct objc_cache * _Nonnull cache                       OBJC2_UNAVAILABLE;
 struct objc_protocol_list * _Nullable protocols          OBJC2_UNAVAILABLE;
 #endif
 
 } OBJC2_UNAVAILABLE;
 ```
 */


//: [Next](@next)
