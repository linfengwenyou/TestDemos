//
//  UCSPhoneTextField.m
//  XINCHANGBank
//
//  Created by ucs_lws on 2017/5/15.
//  Copyright © 2017年 UCSMY. All rights reserved.
//

#import "UCSPhoneTextField.h"


static NSString *DefaultFormatStr = @"*** **** ****";
static NSUInteger NumberCount;


@implementation UCSPhoneTextField
+ (void)configGlobleFormatStr:(NSString *)formatStr {
    
    DefaultFormatStr = formatStr;
    NumberCount = [DefaultFormatStr stringByReplacingOccurrencesOfString:UCSTextFieldSeparateCharacter withString:@""].length;
}

+ (instancetype)phoneTFWithFrame:(CGRect)frame {
    
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setGlobleFormatStr:DefaultFormatStr];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setGlobleFormatStr:DefaultFormatStr];
    }
    return self;
}
// 每次初始化从这边赋值即可


@end
