//
//  UCSInspectTextView.h
//  CoreTextDemo
//
//  Created by ucs_lws on 2017/4/27.
//  Copyright © 2017年 ucs_lws. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface UCSInspectPlaceholderTextView : UITextView

/**
 占位符
 */
@property (nonatomic, copy) IBInspectable  NSString * placeholder;

/**
 占位符颜色
 */
@property (nonatomic, strong) IBInspectable UIColor * placeholderColor;

/**
 获取文本内容
 */
@property (nonatomic, copy, readonly) NSString* content;

/**
 内容更改通知

 @param notification 通知
 */
- (void)textChanged:(NSNotification * )notification;

/**
 
 使用方式：
 
 使用storyborad进行处理：
 将UITextView的控件设置类名为当前类名,然后直接在属性中设置即时看到效果
 
 
 
 若操作时打印：Daemon configuration query reply: XPC_TYPE_DICTIONARY
 修改editSchem 设置OS_ACTIVITY_MODE disable  
 具体原因未知
 */
@end
