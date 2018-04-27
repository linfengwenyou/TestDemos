//
//  FMInputLabel.h
//  TextDemo
//
//  Created by fumi on 2018/4/13.
//  Copyright © 2018年 fumi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMInputLabel : UILabel
/**验证码/密码的位数*/
@property (nonatomic,assign)NSInteger numberOfVertificationCode;
/**控制验证码/密码是否密文显示*/
@property (nonatomic,assign)bool secureTextEntry;
/** 是否显示光标 */
@property (nonatomic, assign) BOOL showCursor;
@end
