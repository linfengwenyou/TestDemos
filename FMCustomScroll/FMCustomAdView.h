//
//  FMCustomAdView.h
//  TestDemoForYiShou
//
//  Created by fumi on 2018/8/8.
//  Copyright © 2018年 fumi. All rights reserved.
//
// 自动滚动视图全展示，可以自定义展示用的cell,要求可以左右滚动，同时可以放大展示
#import <UIKit/UIKit.h>
#import "FMCustomAdFlowLayout.h"

/** 点击 */
typedef void(^FMCustomScollViewClickItemAction)(NSInteger currentIndex);
/** 注册cell */
typedef void(^FMCellRegisterAction)(UICollectionView *collectionView);
/** 配置cell */
typedef UICollectionViewCell *(^FMCellConfigureAction)(UICollectionView *collectionView, NSIndexPath *indexPath);

@interface FMCustomAdView : UIView

#pragma mark - initlizer
/** cell注册 */
@property (nonatomic, copy) FMCellRegisterAction cellRegisterAction;
/** cell 配置 */
@property (nonatomic, copy) FMCellConfigureAction cellConfigure;

/** cell 尺寸 多个item间距*/
@property (nonatomic, assign) CGSize itemSize;  // 默认为容器尺寸
@property (nonatomic, assign) CGFloat itemLinePadding;
// 动画，停止点，默认为0中心， 左为负，右为正
@property (nonatomic, assign) CGFloat offsetCenterX;
/** 总数量 */
@property (nonatomic, assign) NSUInteger totalCount;
/** 动画展示样式  */
@property (nonatomic, assign) FMCustomAdAnimationType animationType;

@property (nonatomic, copy) FMCustomScollViewClickItemAction itemSelectedAction;


+ (instancetype)customScrollViewWithFrame:(CGRect)frame placeholder:(UIImage *)image;

/** 此方法必须调用，否则不会展示任何事件 配置结束，开始展示view */
- (void)finishConfigureView;

@end
