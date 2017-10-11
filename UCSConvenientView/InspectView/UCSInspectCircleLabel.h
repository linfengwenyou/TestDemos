//
//  UCSCircleLabel.h
//  CoreTextDemo
//
//  Created by ucs_lws on 2017/4/27.
//  Copyright © 2017年 ucs_lws. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UCSInspectCircleLabel : UIView

/**
 环形path线条宽度
 */
@property (nonatomic, assign) IBInspectable CGFloat circleLineWidth;


/**
 环形path线条颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *circleLineColor;

/**
 展示内容
 */
@property (nonatomic, copy) IBInspectable NSString *title;

/**
 文字字体大小
 */
@property (nonatomic, assign) IBInspectable CGFloat fontSize;

/**
 
 使用方式：
 
 使用storyborad进行处理：
 将UIView的控件设置类名为当前类名,然后直接在属性中设置即时看到效果
 
 */
@end
