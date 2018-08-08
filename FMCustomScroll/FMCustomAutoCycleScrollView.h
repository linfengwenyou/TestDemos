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

/** 配置imageUrl之前必须配置cell */
@property (nonatomic, copy) NSArray *imageURLs;
@property (nonatomic, copy) NSArray *imageNames;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, copy) FMCustomScollViewClickItemAction itemSelectedAction;

/** 停止计时器 */
+ (instancetype)customScrollViewWithFrame:(CGRect)frame placeholder:(UIImage *)image disableTimer:(BOOL)disableTimer;
+ (instancetype)customScrollViewWithFrame:(CGRect)frame placeholder:(UIImage *)image;

/** 配置结束，开始初始化并展示view */
- (void)finishConfigureView;
@end
