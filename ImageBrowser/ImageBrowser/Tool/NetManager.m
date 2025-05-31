//
//  NetManager.m
//  ImageBrowser
//
//  Created by fumi on 2019/5/9.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "NetManager.h"

@interface NetManager()

@end


@implementation NetManager


+ (instancetype)sharedNetwork
{
    
    static NetManager *_sharedApi = nil;
    static dispatch_once_t _onceToken;
    dispatch_once(&_onceToken, ^{
        _sharedApi = [[self alloc] init];
        _sharedApi.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sharedApi.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sharedApi.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:
                                                              @"application/json",
                                                              @"text/html",
                                                              @"image/jpeg",
                                                              @"image/png",
                                                              @"application/octet-stream",
                                                              @"text/json",
                                                              nil];
        _sharedApi.requestSerializer.timeoutInterval = 15;
        //        HTTPS证书
        _sharedApi.securityPolicy = [_sharedApi securityPolicy];
    });
    return _sharedApi;
}


+ (void)loadDataFromUrl:(NSString *)url complete:(APINetworkDataBlock)complete {
    
    NSURLSessionDataTask *dataTask = [[self sharedNetwork] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (complete) {
            complete(responseObject, nil);
        } else {
            NSLog(@"未设置回调事件");
        }
        
//        NSString *content = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%s",__FUNCTION__);
        // 获取显示信息
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (complete) {
            complete(nil,error);
        } else {
            NSLog(@"未设置回调事件");
        }
        // 显示错误信息
        NSLog(@"%@",error);
    }];
    
    
    [dataTask resume];
}

@end
