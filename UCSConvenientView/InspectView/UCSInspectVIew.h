//
//  UCSCustomInspectVIew.h
//  CoreTextDemo
//
//  Created by ucs_lws on 2017/4/27.
//  Copyright © 2017年 ucs_lws. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UCSInspectVIew : UIView


/**
 圆角半径
 */
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

/**
 边界线宽
 */
@property (nonatomic, assign) IBInspectable CGFloat borderLineW;

/**
 边界颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *borderColor;


/**
 
 使用方式：
 
 使用storyborad进行处理：
 将UIView的控件设置类名为当前类名,然后直接在属性中设置即时看到效果
 
 */

@end
