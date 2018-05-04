//
//  FMSSegmentTitleView.h
//  FSScrollContentViewDemo
//
//  Created by fumi on 2018/5/4.
//  Copyright © 2018年 haha. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FMSSegmentTitleView;

/** 标题头样式类型 */
typedef NS_ENUM(NSUInteger, FMSSegmentTitleViewType) {
    FMSSegmentTitleViewTypeDefault = 0,                 // 默认与按钮长度相同
    FMSSegmentTitleViewTypeEqualTitle,                  // 与文字长度相同
    FMSSegmentTitleViewTypeCustom,                      // 自定义文字边缘延伸宽度
    FMSSegmentTitleViewTypeWrap,                        // 包裹按钮文字
    FMSSegmentTitleViewTypeNone,                        // 完全使用默认样式  选中变大
};

@protocol FMSSegmentTitleViewDelegate <NSObject>

@optional

/**
 切换标题
 
 @param titleView FMSSegmentTitleView
 @param startIndex 切换前标题索引
 @param endIndex 切换后标题索引
 */
- (void)fmsSegmentTitleView:(FMSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex;

/**
 将要开始滑动
 
 @param titleView FMSSegmentTitleView
 */
- (void)fmsSegmentTitleViewWillBeginDragging:(FMSSegmentTitleView *)titleView;

/**
 将要停止滑动
 
 @param titleView FMSSegmentTitleView
 */
- (void)fmsSegmentTitleViewWillEndDragging:(FMSSegmentTitleView *)titleView;

@end

@interface FMSSegmentTitleView : UIView

@property (nonatomic, weak) id<FMSSegmentTitleViewDelegate>delegate;

/**
 标题文字间距，默认20
 */
@property (nonatomic, assign) CGFloat itemMargin;

/**
 当前选中标题索引，默认0
 */
@property (nonatomic, assign) NSInteger selectIndex;

/**
 标题字体大小，默认15
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 标题选中字体大小，默认15
 */
@property (nonatomic, strong) UIFont *titleSelectFont;

/**
 标题正常颜色，默认black
 */
@property (nonatomic, strong) UIColor *titleNormalColor;

/**
 标题选中颜色，默认red
 */
@property (nonatomic, strong) UIColor *titleSelectColor;

/**
 指示器颜色，默认与titleSelectColor一样,在FSIndicatorTypeNone下无效
 */
@property (nonatomic, strong) UIColor *indicatorColor;

/**
 在FSIndicatorTypeCustom时可自定义此属性，为指示器一端延伸长度，默认5
 */
@property (nonatomic, assign) CGFloat indicatorExtension;

/** FMSSegmentTitleViewTypeWrap 类型下背景颜色 */
@property (nonatomic, strong) UIColor *wrapBackNormalColor;
/** 选中时的背景颜色 */
@property (nonatomic, strong) UIColor *wrapBackSelectedColor;

/**
 对象方法创建FMSSegmentTitleView
 
 @param frame frame
 @param titlesArr 标题数组
 @param delegate delegate
 @param incatorType 指示器类型
 @return FMSSegmentTitleView
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titlesArr delegate:(id<FMSSegmentTitleViewDelegate>)delegate indicatorType:(FMSSegmentTitleViewType)incatorType;

@end
