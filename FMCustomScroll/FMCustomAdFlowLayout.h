//
//  FMCustomAdFlowLayout.h
//  TestDemoForYiShou
//
//  Created by fumi on 2018/8/8.
//  Copyright © 2018年 fumi. All rights reserved.
//

#import <UIKit/UIKit.h>

// 可以配置动画类型
typedef NS_ENUM(NSUInteger, FMCustomAdAnimationType) {
    FMCustomAdAnimationTypeNone = 0,                // 无动画
    FMCustomAdAnimationTypeEnlarge = 1,             // 中间变大
    
};

@interface FMCustomAdFlowLayout : UICollectionViewFlowLayout
/** 滚动放大，默认为NO */
@property (nonatomic, assign) FMCustomAdAnimationType animationType;
/** 偏移中心的尺寸，左为负，右为正 */
@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic) NSInteger visibleCount;
@end
