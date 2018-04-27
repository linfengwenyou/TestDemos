//
//  LayerTool.m
//  iOS7Demo
//
//  Created by fumi on 2018/4/27.
//  Copyright © 2018年 fumi. All rights reserved.
//

#import "LayerTool.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation LayerTool
+ (CAGradientLayer *)gradientLayerWithFromColor:(UIColor *)from to:(UIColor *)to
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)from.CGColor, (__bridge id)to.CGColor];
    gradientLayer.locations = @[@0,@1.0];
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    return gradientLayer;
}

+ (CALayer *)configureGradientAndShadowWithButton:(UIButton *)button
{
    //    button.layer.masksToBounds = YES;            // 不可以使用这个，否则会出现子图层全部被切，阴影效果就无法展现了
    button.layer.masksToBounds = NO;
    [button clipsToBounds];
    /**
     渐变阴影配置：
     1. 先配置阴影，并且需要切出阴影需要的圆角
     2. 配置渐变
     3. 先添加阴影图层，再添加渐变图层
     */
    
    CGFloat cornerRadius = button.frame.size.height / 2.0f;
    
    // 配置阴影
    CALayer *sublayer =[CALayer layer];
    sublayer.backgroundColor =[UIColor blackColor].CGColor;         // 背景设置是为了能够看到阴影效果
    sublayer.shadowOffset = CGSizeMake(0, 5);           // 阴影有多大的尺寸
    sublayer.shadowRadius = 5;                          // 阴影的模糊程度
    sublayer.shadowColor = UIColorFromRGB(0xff3382).CGColor;
    sublayer.shadowOpacity = 0.3;               // 阴影透明度 1 最深， 0 最浅
    sublayer.frame = button.bounds;
    sublayer.cornerRadius = cornerRadius;

    
    CALayer *gridentLayer = [self gradientLayerWithFromColor:UIColorFromRGB(0xff3382) to:UIColorFromRGB(0xff5cc4)];
    gridentLayer.frame = button.bounds;
    gridentLayer.cornerRadius = cornerRadius;
    
    
    [sublayer addSublayer:gridentLayer];

    // 这三个抗锯齿没有什么效果
//    sublayer.allowsEdgeAntialiasing = true;
//    gridentLayer.allowsEdgeAntialiasing = true;
//    button.layer.allowsEdgeAntialiasing = true;

    return sublayer;
}
@end
