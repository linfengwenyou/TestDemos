//
//  FMSPageContentView.h
//  FSScrollContentViewDemo
//
//  Created by fumi on 2018/5/4.
//  Copyright © 2018年 haha. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 子控制器需要遵从此协议，确保初始化方法，和清理内存操作正常执行 */
@protocol ChildViewControllerDelegate <NSObject>
@required
/** 实现时需要将子控制器用此方法初始化 */
- (instancetype)initWithTitle:(NSString *)title index:(NSInteger)index;
/** 清理内存，可以清理数据源信息，记得重新展示时需要进行再次的网络请求 */
@optional
- (void)clearMemory;
@end

@class FMSPageContentView;

@protocol FMSPageContentViewDelegate <NSObject>

@optional

/**
 FMSPageContentView开始滑动
 
 @param contentView FMSPageContentView
 */
- (void)fmsContentViewWillBeginDragging:(FMSPageContentView *)contentView;

/**
 FMSPageContentView滑动调用
 
 @param contentView FMSPageContentView
 @param startIndex 开始滑动页面索引
 @param endIndex 结束滑动页面索引
 @param progress 滑动进度
 */
- (void)fmsContentViewDidScroll:(FMSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress;

/**
 FMSPageContentView结束滑动
 
 @param contentView FMSPageContentView
 @param startIndex 开始滑动索引
 @param endIndex 结束滑动索引
 */
- (void)fmsContentViewDidEndDecelerating:(FMSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex;

/**
 scrollViewDidEndDragging
 
 @param contentView FMSPageContentView
 */
- (void)fmsContentViewDidEndDragging:(FMSPageContentView *)contentView;

@end

@interface FMSPageContentView : UIView

/**
 对象方法创建FMSPageContentView
 
 @param frame frame
 @param childVCClassNames 子VC类型数组
 @param parentVC 父视图VC
 @param delegate delegate
 @return FMSPageContentView
 */
- (instancetype)initWithFrame:(CGRect)frame childVCClassNames:(NSArray *)childVCClassNames titles:(NSArray *)titles parentVC:(UIViewController *)parentVC delegate:(id<FMSPageContentViewDelegate>)delegate;

@property (nonatomic, weak) id<FMSPageContentViewDelegate>delegate;

/**
 设置contentView当前展示的页面索引，默认为0
 */
@property (nonatomic, assign) NSInteger contentViewCurrentIndex;

/**
 设置contentView能否左右滑动，默认YES
 */
@property (nonatomic, assign) BOOL contentViewCanScroll;

/** 当收到内存警告时，清理内存信息 */
- (void)reduceMemory;

@end
