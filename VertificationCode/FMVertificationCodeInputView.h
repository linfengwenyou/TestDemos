//
//  FMVertificationCodeInputView.h
//  TextDemo
//
//  Created by fumi on 2018/4/13.
//  Copyright © 2018年 fumi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FMVertificationCodeInputView;
@protocol FMVertificationCodeInputViewDelegate<NSObject>
/** 授权码信息调整 */
- (void)codeInputView:(FMVertificationCodeInputView *)codeView authCode:(NSString *)authCode;
@end

@interface FMVertificationCodeInputView : UIView

/**背景图片*/
@property (nonatomic,copy)NSString *backgroudImageName;
/**验证码/密码的位数*/
@property (nonatomic,assign)NSInteger numberOfVertificationCode;
/**控制验证码/密码是否密文显示*/
@property (nonatomic,assign)bool secureTextEntry;
/**验证码/密码内容，可以通过该属性拿到验证码/密码输入框中验证码/密码的内容*/
@property (nonatomic,copy)NSString *vertificationCode;
/** 代理配置 */
@property (nonatomic, weak) id <FMVertificationCodeInputViewDelegate> delegate;

-(void)becomeFirstResponder;

@end
