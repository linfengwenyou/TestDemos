//
//  UCSSquarePasswordView.h
//  CoreTextDemo
//
//  Created by ucs_lws on 2017/4/28.
//  Copyright © 2017年 ucs_lws. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCSSquarePasswordView;

@protocol UCSSquarePasswordViewDelegate <NSObject>

/**
 *  监听输入的改变
 */
- (void)passWordDidChange:(UCSSquarePasswordView *)passWord;

/**
 *  监听输入的完成时
 */
- (void)passWordCompleteInput:(UCSSquarePasswordView *)passWord;

/**
 *  监听开始输入
 */
- (void)passWordBeginInput:(UCSSquarePasswordView *)passWord;

@end


@interface UCSSquarePasswordView : UIView<UIKeyInput>

/**
 默认位
 */
@property (assign, nonatomic) NSUInteger length;

/**
 正方形大小
 */
@property (assign, nonatomic) CGFloat squareWidth;

/**
 边框颜色
 */
@property (strong, nonatomic) UIColor *rectColor;

/**
 墨点半径
 */
@property (assign, nonatomic) CGFloat pointRadius;

/**
 墨点颜色
 */
@property (strong, nonatomic) UIColor *pointColor;

/**
 代理
 */
@property (weak, nonatomic) id<UCSSquarePasswordViewDelegate> delegate;

/**
 保存的密码
 */
@property (strong, nonatomic, readonly) NSMutableString *textStore;

/**
 使用示例：
 
 1. 遵从代理
 <UCSSquarePasswordViewDelegate>
 
 2. 创建实例
 self.passView = [[UCSSquarePasswordView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 120, self.view.bounds.size.width, 120)];
 self.passView.pointColor = [UIColor redColor];
 self.passView.delegate = self;
 [self.view addSubview:self.passView];

 3. 编写回调方法
 - (void)passWordCompleteInput:(UCSSquarePasswordView *)passWord
 {
 NSLog(@"value is : %@",passWord.textStore);
 }
 
 NOTE:
 1. 因为会设置系统默认值，所以如果边界信息显示不全 说明某些尺寸需要调整
 2. 如果需要弹出键盘需另外考虑接
 */


@end
