//
//  EngagePushManager.m
//  AppLinkDemo
//
//  Created by Buck on 2025/9/26.
//

#import "EngagePushManager.h"

@implementation EngagePushManager

+ (instancetype)shareManager {

    static dispatch_once_t onceToken;
    static EngagePushManager *shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [EngagePushManager new];
    });

    return shareInstance;
}


- (void)updateValue {
    !self.refreshAction ?: self.refreshAction();
}
@end
