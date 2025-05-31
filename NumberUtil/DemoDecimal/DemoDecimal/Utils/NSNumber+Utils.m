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

@end
