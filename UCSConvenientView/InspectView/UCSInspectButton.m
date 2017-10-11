//
//  UCSCustomInspectButton.m
//  CoreTextDemo
//
//  Created by ucs_lws on 2017/4/27.
//  Copyright © 2017年 ucs_lws. All rights reserved.
//

#import "UCSInspectButton.h"

@implementation UCSInspectButton

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

@end
