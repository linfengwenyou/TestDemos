//
//  UCSBaseTextField.m
//  XINCHANGBank
//
//  Created by ucs_lws on 2017/5/15.
//  Copyright © 2017年 UCSMY. All rights reserved.
//

#import "UCSBaseTextField.h"


NSString * const UCSTextFieldSeparateCharacter = @" ";

@interface UCSBaseTextField () <UITextFieldDelegate>

@property (nonatomic, copy) NSString *defaultFormatStr;
@property (nonatomic, copy) NSArray *formatStrs;
@property (nonatomic, assign) NSUInteger numberCount;

@end


@implementation UCSBaseTextField

+ (void)configGlobleFormatStr:(NSString *)formatStr {
    //    NSDictionary *info = @{@"methodName":[NSString stringWithFormat:@"%s",__FUNCTION__]};
    //    NSException *excep = [NSException exceptionWithName:@"请在子类中重写此方法" reason:@"基类不提供此方法调用" userInfo:info];
    //    [NSException raise:excep format:nil];
    UCSLog(@"%s--请不要直接在基类中调用此方法,你需要在子类中重写此方法",__FUNCTION__);
}

#pragma mark - 取值赋值

- (NSString *)numbers {
    
    return [self removeSpaceCharacter:self.text];
}

- (void)setGlobleFormatStr:(NSString *)defaultFormatStr {
    
    self.defaultFormatStr = defaultFormatStr;
    self.numberCount = [self removeSpaceCharacter:_defaultFormatStr].length;
    [self p_configGlobleMes];
}

#pragma mark - 配置信息

// 配置监听
- (void)p_configGlobleMes {
    
    NSArray *tmpArr = [self.defaultFormatStr componentsSeparatedByString:UCSTextFieldSeparateCharacter];
    self.formatStrs = [tmpArr copy];
    
    self.delegate = self;
    self.keyboardType = UIKeyboardTypePhonePad;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - content adjust

- (void)p_adjustContent {
    
    NSString *tmpStr = self.text;
    
    // 将类型转换为
    __block int countNum = 0;
    [self.formatStrs enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
        if (tmpStr.length == countNum + str.length + idx * 1 && tmpStr.length < self.defaultFormatStr.length) {
            self.text = [tmpStr stringByAppendingString:UCSTextFieldSeparateCharacter];
            countNum += 1;
        }
        countNum += str.length; // 每次加1
    }];
}

// 当使用黏贴时
- (void)p_appendString:(NSString *)string range:(NSRange)range {
    
    
    NSString *storateStr = self.text;
    
    /* 目标： 查找出要填充区域的剩余字符数量
     1. 先判断textField 选中的区域是否有空字符串，有几个
     */
    NSString *selectedStr = [self.text substringWithRange:range];
    NSUInteger removeCount = [self removeSpaceCharacter:selectedStr].length; // 要移除的数量
    
    // 2. 计算出还可以加多少字符
    NSUInteger lastCount = self.numberCount - [self removeSpaceCharacter:self.text].length + removeCount;
    if (lastCount <= 0) return;
    
    // 3. 要粘贴字符串中非空格字符
    NSString *strNoSpace = [self removeSpaceCharacter:string];
    
    // 4. 设置需要的字符信息
    if (strNoSpace.length > lastCount) {
        strNoSpace = [strNoSpace substringToIndex:lastCount];
    }
    
    NSString *newString = [storateStr stringByReplacingCharactersInRange:range withString:strNoSpace];
    
    // 移除空字符
    NSString *newStrNoSpace = [self removeSpaceCharacter:newString];
    
    self.text = nil;
    
    for (int i = 0; i < newStrNoSpace.length; i++) {
        NSString *tmpStr = newStrNoSpace;
        NSString *charStr = [tmpStr substringWithRange:NSMakeRange(i, 1)];
        [self p_adjustContent];
        if (self.text.length < self.numberCount + self.formatStrs.count - 1) {
            self.text = [self.text stringByAppendingString:charStr];
        }
    }
}

// 黏贴事件
- (void)paste:(id)sender {
    [super paste:sender];
    NSNotification *noti = [NSNotification notificationWithName:@"pastNotification" object:self];
    [self textFieldDidChange:noti];
}

// 回退删除事件

- (void)deleteBackward {
    [super deleteBackward];
    
//    NSString *tmpStr = self.text;
//    if (tmpStr.length > 0) self.text = [tmpStr substringToIndex:tmpStr.length -1];
    
    if (self.text.length > 0) {
        // 截取最后一个字符
        NSString *lastCharacter = [self.text substringWithRange:NSMakeRange(self.text.length - 1, 1)];
        if ([lastCharacter isEqualToString:UCSTextFieldSeparateCharacter]) {
            self.text = [self.text substringToIndex:self.text.length - 1];
        }
    }
}


#pragma mark - 代理通知

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@""]) return YES; // 退格操作
    
    if (![textField isKindOfClass:[self class]]) {
        return YES;
    }
    
    NSUInteger currentLength = [self removeSpaceCharacter:textField.text].length;
    if ((currentLength - range.length >=self.numberCount) && string.length > 0) {
//        [self resignFirstResponder];
        [self finishInputAction];
        return NO;
    } else {
        [self textchange];
    }
    
    NSString *strNoSpace = [self removeSpaceCharacter:string];  // copy past 使用 eg:132 6533 -> 1326533
    BOOL isDigital = [self isDigital:strNoSpace];
    if (isDigital) {
        if (string.length > 1) { // 不是通过键盘一个一输入，而是多个一起输入
            [self p_appendString:string range:range];
            return NO;      // 需要自己去进行拼接
        } else {
            [self p_adjustContent];
        }
    }
    return isDigital;
}


- (void)textFieldDidChange:(NSNotification *)noti {
    
    UITextField *txf = noti.object;
    
    if (![txf isKindOfClass:[self class]]) {
        return;
    }
    
    NSString *numbers = [self removeSpaceCharacter:txf.text];
    
    if (numbers.length == self.numberCount) {
        // 如果数据长度够了
//        [self resignFirstResponder];
        [self finishInputAction];
    } else {
        [self textchange];
    }
}


- (void)finishInputAction
{
    if ([self.baseDelegate respondsToSelector:@selector(textField:didFinshWithNumber:)]) {
        [self.baseDelegate textField:self didFinshWithNumber:self.numbers];
    }
    [self resignFirstResponder];
}

- (void)textchange
{
    if ([self.baseDelegate respondsToSelector:@selector(textField:didchangeText:)]) {
        [self.baseDelegate textField:self didchangeText:self.numbers];
    }
}


- (void)setBaseNumber:(NSString *)number
{
    if (!number) {
        return;
    }
    self.text = @"";
    for (int i = 0; i < number.length; i ++) {
        self.text = [self.text stringByAppendingString:[number substringWithRange:NSMakeRange(i, 1)]];
        [self p_adjustContent];
    }
}

#pragma mark - other

- (BOOL)isDigital:(NSString *)str {
    
    NSString *digital = @"\\d+";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",digital];
    return [pre evaluateWithObject:str];
}

- (NSString *)removeSpaceCharacter:(NSString *)originalString {
    
    return [originalString stringByReplacingOccurrencesOfString:UCSTextFieldSeparateCharacter withString:@""];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}


@end
