//
//  UCSBankTextField.m
//  XINCHANGBank
//
//  Created by ucs_lws on 2017/5/22.
//  Copyright © 2017年 UCSMY. All rights reserved.
//

#import "UCSBankTextField.h"
// 银行卡最低位16 最高位25

static NSString *DefaultFormatStr = @"**** **** **** **** **** **** *";
static NSUInteger NumberCount;

@implementation UCSBankTextField

+ (void)configGlobleFormatStr:(NSString *)formatStr {
    
    DefaultFormatStr = formatStr;
    NumberCount = [DefaultFormatStr stringByReplacingOccurrencesOfString:UCSTextFieldSeparateCharacter withString:@""].length;
}

+ (instancetype)bankTFWithFrame:(CGRect)frame {
    
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

- (BOOL)isValidBankNumber
{
    return self.numbers.length >= 16;
}

@end
