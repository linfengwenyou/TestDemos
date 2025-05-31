//
//  NSNumber+Utils.m
//  DemoDecimal
//
//  Created by LIUSONG on 2019/6/4.
//  Copyright © 2019 Rayor. All rights reserved.
//

#import "NSNumber+Utils.h"

@implementation NSNumber (Utils)

- (NSString *(^)(NSUInteger))roundDown {
	return ^(NSUInteger scale){
		return [self testdemo:scale roundModel:NSRoundDown];
	};
}


- (NSString *(^)(NSUInteger))roundUp {
	return ^(NSUInteger scale){
		return [self testdemo:scale roundModel:NSRoundUp];
	};
}

- (NSString *(^)(NSUInteger))roundPlain {
	return ^(NSUInteger scale) {
		return [self testdemo:scale roundModel:NSRoundPlain];
	};
}

- (NSString *(^)(NSUInteger))roundBanker {
	return ^(NSUInteger scale) {
		return [self testdemo:scale roundModel:NSRoundBankers];
	};
}

- (NSString *)testdemo:(NSUInteger)scale roundModel:(NSRoundingMode)mode {
	
	NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:mode scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
	
	NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:self.stringValue];
	number = [number decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
	return number.stringValue;
}


- (NSString *(^)(NSUInteger))moneyThoundFormat{
    return ^(NSUInteger scale) {
        return [self moneyFormatWithScale:scale];
    };
}


- (NSNumber *(^)(NSNumber *))add {
    return ^(NSNumber *value) {
        NSDecimalNumber *number1 = [NSDecimalNumber decimalNumberWithString:self.stringValue];
        NSDecimalNumber *number2 = [NSDecimalNumber decimalNumberWithString:value.stringValue];
        return [number1 decimalNumberByAdding:number2];
    };
}



/** 格式化 */
- (NSString *)moneyFormatWithScale:(NSUInteger)scale {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSString *formatString = @",###";
    if (scale > 0) {
        formatString = [formatString stringByAppendingString:@"."];
        int i = 0;
        while (scale > i) {
            formatString = [formatString stringByAppendingString:@"0"];
            i++;
        }
    }
    formatString = [formatString stringByAppendingString:@";"];
    [numberFormatter setPositiveFormat:formatString];
    return [numberFormatter stringFromNumber:self];
}


@end
