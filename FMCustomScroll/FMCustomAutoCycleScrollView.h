//
//  FMCustomAutoCycleScroll.h
//  TestDemoForYiShou
//
//  Created by fumi on 2018/8/8.
//  Copyright © 2018年 fumi. All rights reserved.
//
// 自动滚动视图全展示，可以自定义展示用的cell
#import <UIKit/UIKit.h>

/** 点击 */
typedef void(^FMCustomScollViewClickItemAction)(NSInteger currentIndex);
/** 注册cell */
typedef void(^FMCellRegisterAction)(UICollectionView *collectionView);
/** 配置cell */
typedef UICollectionViewCell *(^FMCellConfigureAction)(UICollectionView *collectionView, NSIndexPath *indexPath);

@interface FMCustomAutoCycleScrollView : UIView

#pragma mark - initlizer
/** cell注册 */
@property (nonatomic, copy) FMCellRegisterAction cellRegisterAction;
/** cell 配置 */
@property (nonatomic, copy) FMCellConfigureAction cellConfigure;

/** pagecontrol 颜色 */
@property (nonatomic, strong) UIColor *pageControlNormalColor;
@property (nonatomic, strong) UIColor *pageControlCurrentSelectColor;

// 配置imageUrl之前必须配置cell 
/** 总数量 */
@property (nonatomic, assign) NSUInteger totalCount;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, copy) FMCustomScollViewClickItemAction itemSelectedAction;

/** 停止计时器 */
+ (instancetype)customScrollViewWithFrame:(CGRect)frame placeholder:(UIImage *)image disableTimer:(BOOL)disableTimer;
+ (instancetype)customScrollViewWithFrame:(CGRect)frame placeholder:(UIImage *)image;

/** 此方法必须调用，否则不会展示任何事件 配置结束，开始展示view */
- (void)finishConfigureView;
@end
