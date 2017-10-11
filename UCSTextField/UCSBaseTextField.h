//
//  UCSBaseTextField.h
//  XINCHANGBank
//
//  Created by ucs_lws on 2017/5/15.
//  Copyright © 2017年 UCSMY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UCSBaseTextField;

@protocol UCSBaseTextFieldDelegate <NSObject>

@optional
/**
 全局配置，只能用子类
 
 @param formatStr 类型字符串，默认为如：*** **** **** // 分割符需要与SeparateCharacter 保持一致
 */
+ (void)configGlobleFormatStr:(NSString *)formatStr;
- (void)textField:(UCSBaseTextField *)textField didchangeText:(NSString *)text;
- (void)textField:(UCSBaseTextField *)textField didFinshWithNumber:(NSString *)number;
@end

/*
 * 分割符
 */
extern NSString * const UCSTextFieldSeparateCharacter;  // 分割符


@interface UCSBaseTextField : UITextField <UCSBaseTextFieldDelegate>

@property (nonatomic,readonly ,copy) NSString *numbers;  //返回无空格的字符串
@property (nonatomic, weak) id <UCSBaseTextFieldDelegate> baseDelegate;


/**
 赋值，直接以格式后的串展示
 */
- (void)setBaseNumber:(NSString *)number;

/**
 子类必须要调用
 
 @param defaultFormatStr 设置格式
 */
- (void)setGlobleFormatStr:(NSString *)defaultFormatStr;

@end
