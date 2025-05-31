//
//  AppDelegate.m
//  demo
//
//  Created by xiaosi on 2018/7/24.
//  Copyright © 2018年 xiaosi. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWebVC.h"
#import "AFNetworking.h"
//#import "RAYMainViewController.h"
#import "RAYWebController.h"
#import "FMNavigationController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupRootVC];
    
    //设置我们的
//    [self setupMyView];
    
    return YES;
}

- (void)setupRootVC{
    
    self.window = [[UIWindow alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.frame = [UIScreen mainScreen].bounds;
    [self.window makeKeyAndVisible];
    
    //你的马甲包
    // 里面内容用来展示
    
    RAYWebController *webVC = [RAYWebController loadFromNib];
    FMNavigationController *navi = [[FMNavigationController alloc] initWithRootViewController:webVC];
    
    self.window.rootViewController = navi;
//    RAYMainViewController *mainVC = [RAYMainViewController loadFromNib];
//    self.window.rootViewController = mainVC;
//    return;
    
}

//我们的页面
- (void)setupMyView{
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //定时跳转比如9月1号后才执行
    //这里切换
    MainWebVC *webVC = [MainWebVC shareController];
    self.window.rootViewController = webVC;
    //或者
    //[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:webVC animated:NO completion:nil];
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            NSLog(@"无网络");
        }
        else{
            //有网络发起请求
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            //记得把这个链接替换
            [manager POST:@"http://szhb56.cn/Test1.txt" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (!webVC.isSuccess) {
                    [webVC loadWithUrl:responseObject[@"webUrl"]];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];
            NSLog(@"有网络");
        }
    }];
    [manager startMonitoring];
}

@end
