//
//  AgainView.m
//  DemoDemo
//
//  Created by fumi on 2018/8/29.
//  Copyright © 2018年 fumi. All rights reserved.
//

#import "AgainView.h"
#import <Masonry.h>
@implementation AgainView

- (void)updateFrame
{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(100);
    }];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    NSLog(@"update constraints");
}

@end
