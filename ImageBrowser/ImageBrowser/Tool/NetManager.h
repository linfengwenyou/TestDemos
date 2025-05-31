//
//  NetManager.h
//  ImageBrowser
//
//  Created by fumi on 2019/5/9.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^APINetworkDataBlock)(NSData *datas, NSError *error);
NS_ASSUME_NONNULL_BEGIN

@interface NetManager : AFHTTPSessionManager

+ (void)loadDataFromUrl:(NSString *)url complete:(APINetworkDataBlock)complete;

@end

NS_ASSUME_NONNULL_END
