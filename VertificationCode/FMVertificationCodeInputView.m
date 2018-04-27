//
//  FMVertificationCodeInputView.m
//  TextDemo
//
//  Created by fumi on 2018/4/13.
//  Copyright © 2018年 fumi. All rights reserved.
//

#import "FMVertificationCodeInputView.h"
#import "FMInputLabel.h"

@interface FMVertificationCodeInputView()

/**用于获取键盘输入的内容，实际不显示*/
@property (nonatomic,strong)UITextField *textField;
/**验证码/密码输入框的背景图片*/
@property (nonatomic,strong)UIImageView *backgroundImageView;
/**实际用于显示验证码/密码的label*/
@property (nonatomic,strong)FMInputLabel *label;

@end

@implementation FMVertificationCodeInputView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    // 设置透明背景色，保证vertificationCodeInputView显示的frame为backgroundImageView的frame
    self.backgroundColor = [UIColor clearColor];
    // 设置验证码/密码的位数默认为四位
    self.numberOfVertificationCode =4;
    /* 调出键盘的textField */
    self.textField = [[UITextField alloc] initWithFrame:self.bounds];
    // 隐藏textField，通过点击IDVertificationCodeInputView使其成为第一响应者，来弹出键盘
    self.textField.hidden =YES;
    self.textField.keyboardType =UIKeyboardTypeNumberPad;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.textField];
    // 将textField放到最后边
    [self insertSubview:self.textField atIndex:0];
    /* 添加用于显示验证码/密码的label */
    self.label = [[FMInputLabel alloc] initWithFrame:self.bounds];
    self.label.numberOfVertificationCode =self.numberOfVertificationCode;
    self.label.secureTextEntry =self.secureTextEntry;
    self.label.font =self.textField.font;
    [self addSubview:self.label];
    
    // 监听键盘弹出时间
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.textField];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)setBackgroudImageName:(NSString *)backgroudImageName {
    _backgroudImageName = backgroudImageName;
    // 若用户设置了背景图片，则添加背景图片
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.backgroundImageView.image = [UIImage imageNamed:self.backgroudImageName];
    // 将背景图片插入到label的后边，避免遮挡验证码/密码的显示
    [self insertSubview:self.backgroundImageView belowSubview:self.label];
}
- (void)setNumberOfVertificationCode:(NSInteger)numberOfVertificationCode {
    _numberOfVertificationCode = numberOfVertificationCode;
    // 保持label的验证码/密码位数与IDVertificationCodeInputView一致，此时label一定已经被创建
    self.label.numberOfVertificationCode =_numberOfVertificationCode;
}
- (void)setSecureTextEntry:(bool)secureTextEntry {
    _secureTextEntry = secureTextEntry;
    self.label.secureTextEntry =_secureTextEntry;
}
-(void)becomeFirstResponder{
    [self.textField becomeFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textField becomeFirstResponder];
}

- (void)textFieldDidChange:(NSNotification *)noti
{
    if (self.textField.text.length <= self.numberOfVertificationCode) {
        self.label.text = self.textField.text;
        self.vertificationCode =self.label.text;
        if (self.label.text.length == self.numberOfVertificationCode) {
            NSLog(@"tag 已经输入完成验证码了vertificationCode= %@",_vertificationCode);
        }
    } else {
        self.textField.text = [self.textField.text substringToIndex:self.numberOfVertificationCode];
    }
}



#pragma mark - notification

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    self.label.showCursor = YES;
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    self.label.showCursor = NO;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"text field did end editing");
}

- (void)setVertificationCode:(NSString *)vertificationCode
{
    _vertificationCode = vertificationCode;
    if ([self.delegate respondsToSelector:@selector(codeInputView:authCode:)]) {
        [self.delegate codeInputView:self authCode:_vertificationCode];
    } else {
        NSLog(@"未设置回调信息");
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.label.frame = self.bounds;
    NSLog(@"调整布局");
}

@end
