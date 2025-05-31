//
//  RoundGradientLayer.h
//  GPUImageDemo
//
//  Created by rayor on 2021/5/26.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RoundGradientLayer : CALayer

+ (RoundGradientLayer *)createGradientLayerWithFrame:(CGRect)frame
                                           locations:(CGFloat[])locations
                                              colors:(NSArray *)colors;


/*使用方式：
 CGFloat locations[] = {0.f, 0.5f,1.0f};
 
 // 绘制路径
 colors:@[(__bridge id)[UIColor.redColor colorWithAlphaComponent:0].CGColor,
 (__bridge id)[UIColor.redColor colorWithAlphaComponent:0].CGColor,
 (__bridge id)UIColor.redColor.CGColor
 ]
 */
@end

NS_ASSUME_NONNULL_END
