//
//  UCSBankTextField.h
//  XINCHANGBank
//
//  Created by ucs_lws on 2017/5/22.
//  Copyright © 2017年 UCSMY. All rights reserved.
//

#import "UCSBaseTextField.h"

@interface UCSBankTextField : UCSBaseTextField
+ (instancetype)bankTFWithFrame:(CGRect)frame;
- (BOOL)isValidBankNumber;
@end
