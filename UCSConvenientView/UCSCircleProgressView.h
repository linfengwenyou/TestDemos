//
//  UCSCircleProgressView.h
//  CoreTextDemo
//
//  Created by ucs_lws on 2017/4/27.
//  Copyright © 2017年 ucs_lws. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCSCircleProgressView : UIView

#pragma mark - 环
/**
 进度条颜色 默认蓝色
 */
@property (nonatomic, strong) UIColor *progressColor;

/**
 进度条背景色 默认灰色
 */
@property (nonatomic, strong) UIColor *progressBackgroundColor;


/**
 进度条宽度 默认3
 */
@property (nonatomic, assign) CGFloat progressWidth;


/**
 进度条进度 0-1
 */
@property (nonatomic, assign) float percent;

#pragma mark - 提示信息  环内文字

/**
 字体颜色 默认黑色
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 字体大小 默认15
 */
@property (nonatomic, assign) CGFloat textFontSize;

/**
 设置格式,默认为@"%.2f%%"  考虑初始化，自定义格式与默认需要放到percent设置之前
 */
@property (nonatomic, copy) NSString *(^formatter)(CGFloat percent);

/**
 进度为1时 提示信息的字符样式  默认为完成
 */
@property (nonatomic, copy) NSString *completeText;

/**
 进度为1时字体样式
 */
@property (nonatomic, strong) UIColor *completeTextColor;



/**
 使用示例：
 
 UCSCircleProgressView *cirView = [[UCSCircleProgressView alloc] initWithFrame:CGRectMake(20, 40, 150, 150)];
 cirView.progressWidth = 5;                           // 进度条宽度
 cirView.textColor = [UIColor blueColor];             // 普通字体颜色
 cirView.completeTextColor = [UIColor yellowColor];   // 设置完成后字体颜色
 cirView.textFontSize = 20;                           // 中间字体尺寸
 cirView.progressColor = [UIColor redColor];          // 中间进度条样式
 cirView.formatter = ^NSString *(CGFloat percent) {   // 设置中间字体提示格式
 return [NSString stringWithFormat:@"已投:%.0f%%",percent*100];
 };
 cirView.percent = 0.06;                              // 初始化进度
 [self.view addSubview:cirView];
 self.circleView = cirView;
 
 // 修改进度信息
  self.circleView.percent = self.circleView.percent+0.1;  // 改成适当方式
 

 */
@end
