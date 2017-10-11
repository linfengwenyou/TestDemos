//
//  UCSInspectTextField.h
//  CoreTextDemo
//
//  Created by ucs_lws on 2017/4/27.
//  Copyright © 2017年 ucs_lws. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UCSInspectTextField : UITextField
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
 光标起始区域
 */
@property (nonatomic, assign) IBInspectable CGFloat insetX;

/**
 
 使用方式：
 
 使用storyborad进行处理：
 将UITextField的控件设置类名为当前类名,然后直接在属性中设置即时看到效果
 
 
 note:需要设置uitextField的宽度约束
 */
@end
