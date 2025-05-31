//
//  main.m
//  DemoDecimal
//
//  Created by LIUSONG on 2019/6/4.
//  Copyright © 2019 Rayor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSNumber+Utils.h"

int main(int argc, const char * argv[]) {
	@autoreleasepool {
	    // insert code here...
	    NSLog(@"Hello, World!");
        
		NSNumber *number = @9999999999999999999.11111;
		NSLog(@"%@",number.roundDown(5));
		
		NSLog(@"%@",number.roundUp(5));
		
		NSLog(@"%@",number.roundPlain(5));
		
		NSLog(@"%@",number.roundBanker(2));
        
        
        NSLog(@"%@",number.moneyThoundFormat(3));
        
        NSLog(@"%@",number.add(@0.12345678).roundDown(5));
//		number.dropDown().floatValue;
		
	}
	return 0;
}
//17216961135462248174
