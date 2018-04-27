//
//  LayerTool.h
//  iOS7Demo
//
//  Created by fumi on 2018/4/27.
//  Copyright © 2018年 fumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LayerTool : NSObject
+ (CAGradientLayer *)gradientLayerWithFromColor:(UIColor *)from to:(UIColor *)to;

/** 对一个按钮添加渐变色和阴影 */
+ (CALayer *)configureGradientAndShadowWithButton:(UIButton *)button;


/** 使用示例：
 
 CALayer *layer = [LayerTool configureGradientAndShadowWithButton:self.testButton];
 [self.testButton.layer insertSublayer:layer atIndex:0];    // 如果不使用这种方式，那么就要通过tintColor来设置文本颜色了

 */

@end
