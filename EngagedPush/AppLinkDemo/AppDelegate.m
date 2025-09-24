//
//  AppDelegate.m
//  AppLinkDemo
//
//  Created by Buck on 2025/7/15.
//
// 引入 MTPush 功能所需头文件
#import "MTPushService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>


#import "AppDelegate.h"


static NSString *appKey = @"257e40e1e9539ec553d94fd4";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;


@interface AppDelegate ()<MTPushRegisterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 加载 Storyboard 中的初始视图控制器
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *rootVC = [storyboard instantiateInitialViewController];
    self.window.rootViewController = rootVC;
    
    [self.window makeKeyAndVisible];
    
    [self configPushOptions:launchOptions];
    
    
    
    return YES;
}

- (void)configPushOptions:(NSDictionary *)launchOptions {
    //Required
    
    MTPushRegisterEntity * entity = [[MTPushRegisterEntity alloc] init];
    entity.types = MTPushAuthorizationOptionAlert|MTPushAuthorizationOptionSound|MTPushAuthorizationOptionProvidesAppNotificationSettings;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [MTPushService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    // Optional
    // 获取 IDFA
    // 如需使用 IDFA 功能请添加此代码并在初始化方法的 advertisingIdentifier 参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    [MTPushService setupWithOption:launchOptions
                            appKey:appKey
                           channel:channel
                  apsForProduction:isProduction
             advertisingIdentifier:advertisingId];
}

#pragma mark - push
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [MTPushService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
    
}


#pragma mark- MTPushRegisterDelegate

// iOS 12 Support
- (void)mtpNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification {
    
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {// 从通知界面直接进入应用
        NSLog(@"notification content: ", notification.request.content);
    } else {// 从通知设置界面进入应用
        NSLog(@"notification content: ", notification.request.content);
    }
}

// iOS 10 Support
- (void)mtpNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [MTPushService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)mtpNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [MTPushService handleRemoteNotification:userInfo];
    }
    
    NSLog(@"接收到推送内容:%@",response.notification.request.content.description);
    
    
    completionHandler();    // 系统要求执行这个方法
}
    
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [MTPushService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}



//#pragma mark - UISceneSession lifecycle
//
//
//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}

#pragma mark - 处理urlScheme
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"打开了URL: %@", url.absoluteString);
    // 根据 url.scheme 和 url.host 做不同处理
    if ([url.scheme isEqualToString:@"applink"]) {
        // 主 scheme 处理
    } else if ([url.scheme isEqualToString:@"applink-login"]) {
        // 登录回调处理
    }
    return YES;
}


#pragma mark - 处理通用Applink逻辑
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *url = userActivity.webpageURL;
        if (url) {
            NSLog(@"[Universal Link] 打开链接：%@", url.absoluteString);
            [self handleUniversalLinkWithURL:url];
            return YES;
        }
    }
    
    return NO;
}


- (void)handleUniversalLinkWithURL:(NSURL *)url {
    NSString *path = url.path;
    
    if ([path hasPrefix:@"/product/"]) {
        NSString *productId = [path lastPathComponent];
        NSLog(@"打开商品页，ID：%@", productId);
        
        // 根据实际项目跳转控制器，例如使用通知或路由组件
        NSDictionary *userInfo = @{@"productId": productId};
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenProductPage"
//                                                            object:nil
//                                                          userInfo:userInfo];
        
    } else if ([path isEqualToString:@"/promo"]) {
        NSLog(@"打开促销页");
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenPromoPage"
//                                                            object:nil];
    } else {
        NSLog(@"打开首页");
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenHomePage"
//                                                            object:nil];
    }
}
// 验证方案
//https://earnest-alpaca-0704f0.netlify.app/index.html
@end
