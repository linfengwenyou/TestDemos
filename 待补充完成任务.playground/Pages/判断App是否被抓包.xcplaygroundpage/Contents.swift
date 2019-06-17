//: [Previous](@previous)

import Foundation

//: # iOS防止被抓包
//: ## 通过判断网络状态【不推荐】
//: ### 是否连接有代理
/*:
 ```
+ (BOOL)getProxyStatus {
    NSDictionary *proxySettings =  (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"https://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSDictionary *settings = [proxies objectAtIndex:0];
    
    NSLog(@"host=%@", [settings objectForKey:(NSString *)kCFProxyHostNameKey]);
    NSLog(@"port=%@", [settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
    NSLog(@"type=%@", [settings objectForKey:(NSString *)kCFProxyTypeKey]);
    
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
        //没有设置代理
        return NO;
    }else{
        //设置代理了
        return YES;
    }
}
 ```
 */

//: > 但是通过此方法却一并将VPN 与 网络抓包统一处理了，所以还需要做进一步判断

//: ### 判断是否连接VPN
/*:
 ```
    + (BOOL)getVPNStatus {
        BOOL vpnFlag = NO;
        NSDictionary *dict = CFBridgingRelease(CFNetworkCopySystemProxySettings());
        NSArray *keys = [dict[@"__SCOPED__"] allKeys];
        NSLog(@"%@",dict);
        for (NSString *key in keys) {
            if ([key rangeOfString:@"tap"].location != NSNotFound ||
                [key rangeOfString:@"tun"].location != NSNotFound ||
                [key rangeOfString:@"ipsec"].location != NSNotFound ||
                [key rangeOfString:@"ppp"].location != NSNotFound){
                vpnFlag = YES;
                break;
            }
        }
        return vpnFlag;
}
 ```
 */
 
//: ## 通过证书绑定SSL Pinning【推荐】
/*:
 1. 获取证书
 > .pem格式转换
 openssl ....
 > .crt格式转换
 openssl
 > 自己生成
 openssl
 
 
 2. 将证书添加入项目中
 
 3. 配置网络请求设置
 AFSecurityPolicy : None, PublicKey【对比公钥，最快】, Certificate【对比整个证书，最安全】
 
 ```
 
 AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey withPinnedCertificates:[AFSecurityPolicy certificatesInBundle:[NSBundle mainBundle]]];
 _sharedApi.securityPolicy = policy;
 ```
 
 */


//: [Next](@next)
