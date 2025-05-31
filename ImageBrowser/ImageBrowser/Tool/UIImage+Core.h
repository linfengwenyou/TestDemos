//
//  UIImage+Core.h
//  YiShou
//
//  Created by dahl.chen on 2018/4/22.
//  Copyright © 2018年 FuMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Core)
+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size;
- (UIImage *)imageWithColor:(UIColor *)color;

/**
 图片转数据并压缩数据
 建议：不要在主线程上调用，压缩图片用时和内存较大
 @param num 图片压缩后数据最大 （单位：KB）
 @return NSData 图片二进制数据
 */
- (NSData *)compressDataToMaxLength:(NSUInteger)num;
@end
