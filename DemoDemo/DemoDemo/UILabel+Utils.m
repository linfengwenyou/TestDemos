//
//  UILabel+Utils.m
//  DemoDemo
//
//  Created by fumi on 2018/8/30.
//  Copyright © 2018年 fumi. All rights reserved.
//

#import "UILabel+Utils.h"

@implementation UILabel (Utils)
- (NSInteger)lineNum
{
    CGSize size = [self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)];
    NSInteger lineNum = size.height / self.font.lineHeight;
    return lineNum;
}
@end
