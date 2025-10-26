//
//  EngagePushManager.h
//  AppLinkDemo
//
//  Created by Buck on 2025/9/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EngagePushManager : NSObject
// appKey
@property (nonatomic, copy) NSString *appKey;
// registrationID
@property (nonatomic, copy) NSString *registrationID;
// deviceToken
@property (nonatomic, copy) NSString *deviceToken;

+ (instancetype)shareManager;

// 刷新
@property(nonatomic, copy) void(^refreshAction)(void);

- (void)updateValue;
@end

NS_ASSUME_NONNULL_END
