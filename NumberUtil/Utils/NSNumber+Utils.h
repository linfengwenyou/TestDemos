//
//  NSNumber+Utils.h
//  DemoDecimal
//
//  Created by LIUSONG on 2019/6/4.
//  Copyright © 2019 Rayor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Utils)

/** 需要处理的方式：
 1. 四舍五入
 2. 只舍不入
 3. 只入不舍
 3. 金额格式化
 4. 加减乘除
 */

// 格式使用处理
/** 直接将多余小数点为干掉 */
@property (nonatomic, copy, readonly) NSString * (^roundDown)(NSUInteger scale);

/** 将多余小数点向上转 */
@property (nonatomic, copy, readonly) NSString * (^roundUp)(NSUInteger scale);

/** 超出小数点scale后的后一位四舍五入 */
@property (nonatomic, copy, readonly) NSString * (^roundPlain)(NSUInteger scale);

/** 银行模式,在四舍五入的基础上加一个判断：当【最后一位】是5的时候，只会舍入成偶数 */
@property (nonatomic, copy, readonly) NSString * (^roundBanker)(NSUInteger scale);

/** 返回金额千分格式,尾数四舍五入 */
@property (nonatomic, copy, readonly) NSString * (^moneyThoundFormat)(NSUInteger scale);

/** 加法 */
@property (nonatomic, strong, readonly) NSNumber * (^add)(NSNumber *value);

//@property (nonatomic, strong, readonly) NSNumber * (^reduce)(NSNumber *value);
// 做好加减乘除


@end

