//
//  AudioView.h
//  AnimationDemo
//
//  Created by fumi on 2018/11/16.
//  Copyright © 2018 fumi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioView : UIView
/**
 模拟音频波动效果

 @param frame 容器尺寸
 @param count 数量 数量 少于3个展示3个
 @param color 颜色 ， 默认红色,
 @param offset 偏移间隔 两个Line 之间的距离，默认为1
 @return 返回一个动态效果视图
 */
- (instancetype)initWithFrame:(CGRect)frame audioLineCount:(NSUInteger)count color:(UIColor *)color lineOffset:(NSUInteger)offset;
@end

NS_ASSUME_NONNULL_END
