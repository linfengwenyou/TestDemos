//
//  UCSInspectTextField.m
//  CoreTextDemo
//
//  Created by ucs_lws on 2017/4/27.
//  Copyright © 2017年 ucs_lws. All rights reserved.
//

#import "UCSInspectTextField.h"

@implementation UCSInspectTextField

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}

- (void)setBorderLineW:(CGFloat)borderLineW
{
    _borderLineW = borderLineW;
    self.layer.borderWidth = _borderLineW;
}

#pragma mark - 调整编辑区域
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+self.insetX, bounds.origin.y, bounds.size.width-self.insetX*2, bounds.size.height);
    return inset;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+self.insetX, bounds.origin.y, bounds.size.width-self.insetX*2, bounds.size.height);
    return inset;
}

@end
