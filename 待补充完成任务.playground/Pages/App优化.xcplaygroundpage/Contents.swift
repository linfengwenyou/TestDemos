//: [Previous](@previous)
/*:
 参考地址：
 https://developer.apple.com/library/archive/documentation/Performance/Conceptual/EnergyGuide-iOS/MinimizeTimerUse.html#//apple_ref/doc/uid/TP40015243-CH41-SW1
 */
import Foundation

//: 超过20s无法启动就会被系统杀掉
// https://developer.apple.com/videos/play/wwdc2016/406/
/*:
1. 包体积优化【指的是下载的包，不是上传的】

1.1 冗余图片

1.2 冗余代码【类，方法】

1.3 Apple 的App Thinning

2. 启动速度优化

启动耗时点：
1.1 动态链接库
1.2 符号绑定
    减少__DATA 指针
    减少 Objectie C 元类: 类，方法，分类
    减少C++虚函数
    使用Swift 结构
    使用偏移而不是指针
    标记属性为只读
 
1.3 ObjC 类初始化
    类注册
    Non-fragile变量偏移更新
    分类注册
    方法唯一
1.4 初始化
 Explicit:【严格标识的】
 ObjC +load
    replace with +initialize
 C/C++ __attribute__((constructor))
    replace with call site initializers
* dispatch_once()
* pthread_once()
* std::once()
 
 implicit:【非严格标识的】
 重要的C++静态方法
    Rewrite in swift
 不要调用dlopen() 在初始化的时候
 初始化是不要创建线程

优化点：
1.1 减少自定义的动态库集成
1.2 精简原有的Objective-C类和代码
1.3 移除静态的初始化操作
1.4 使用更多的Swift代码

3. 方法执行时间监测
原理：hook msg_send 方法，让消息直接转发，自定义转发实现，然后在内部对消息发送进行时间监听

4. 逻辑优化
*/


/*:
 #### 冷启动过程
 Parse images
 Map images
 Rebase images
 Bind images
 Run image initializers
 Call main()
 Call UIApplicationMain()
 Call applicationWillFinishLaunching
 
 
 #### 热启动过程
 已经在内存中了
 */


/*:
 #### 监听方法调用时间， 整理成日志并记录下来
 * 监听系统启动时间 配置环境变量： DYLD_PRINT_STATISTICS  1
```
Total pre-main time: 865.16 milliseconds (100.0%)
dylib loading time: 193.51 milliseconds (22.3%)
rebase/binding time: 543.90 milliseconds (62.8%)
ObjC setup time:  94.35 milliseconds (10.9%)
initializer time:  33.18 milliseconds (3.8%)
slowest intializers :
libSystem.B.dylib :   4.49 milliseconds (0.5%)
libMainThreadChecker.dylib :  18.67 milliseconds (2.1%)

```


对比一个线上的：
```
total time: 7.4 seconds (100.0%)
total images loaded:  213
total segments mapped: 829, into 63345 pages with 5698 pages pre-fetched
total images loading time: 4.0 seconds (54.4%)
total dtrace DOF registration time: 0.16 milliseconds (0.0%)
total rebase fixups:  1,742,493
total rebase fixups time: 153.48 milliseconds (2.0%)
total binding fixups: 249,844
total binding fixups time: 919.38 milliseconds (12.3%)
total weak binding fixups time: 154.14 milliseconds (2.0%)
total bindings lazily fixed up: 0 of 0
total time in initializers and ObjC setup: 2.1 seconds (29.0%)
libSystem.B.dylib : 1.4 seconds (19.4%)
libBacktraceRecording.dylib : 7.36 milliseconds (0.0%)
libc++.1.dylib : 1.59 milliseconds (0.0%)
CoreFoundation : 5.56 milliseconds (0.0%)
CFNetwork : 0.03 milliseconds (0.0%)
vImage : 0.02 milliseconds (0.0%)
libLLVMContainer.dylib : 1.02 milliseconds (0.0%)
libGLImage.dylib : 0.13 milliseconds (0.0%)
QuartzCore : 0.03 milliseconds (0.0%)
libViewDebuggerSupport.dylib : 0.04 milliseconds (0.0%)
CoreTelephony : 0.05 milliseconds (0.0%)
libstdc++.6.dylib : 127.16 milliseconds (1.7%)
YiShou : 564.46 milliseconds (7.5%)

```

*/




/*:

苹果官方规定：主二进制text段的大小不能超过60MB,如果标准达不到，无法提交APP Store

 #### 官方的App Thinning
区分不同的图片尺寸 @2x @3x再下载是会针对不同的设备下载不同的优化版本
App Thinning 的三种方式：
1. App Slicing
	会在你向iTunes Connect上传APP后，对App做切割，创建不同的辩题，这样就可以适用到不同的设备。
2. On-Demand Resources
	主要是为游戏关卡设计的服务，根据游戏进度下载相应的资源，并且已经过关的关卡也会被删除掉，这样就可以减少初装App的包的大小
3. Bitcode
	针对特定设备进行包大小d优化，优化不明显


*/

/*:
 #### 优化包体积
1. 代码瘦身
	去除无用的方法类，通过LinkMap[一定用到的方法]做筛选，通过shell脚本进行文件方法筛选
2. 图片处理
	查询冗余图片，移除冗余图片 工具 LSUnusedResources
	图片压缩WebP 100KB以上建议使用，其他还是使用常规压缩
3. 静态库->动态库
4.

*/


//: [Next](@next)
