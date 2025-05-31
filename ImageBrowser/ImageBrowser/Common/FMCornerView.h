//
//  FMCornerView.h
//  MarketingPtoject
//
//  Created by fumi on 2019/3/2.
//  Copyright © 2019 fumi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMCornerView : UIView
/** 圆角 */
@property (nonatomic, assign) IBInspectable CGFloat radius;

/** 半圆配置 */
@property (nonatomic, assign) IBInspectable BOOL halfHeightCorner;
/** 线宽 */
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
/** 线颜色 */
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@end


@interface FMCornerButton : UIButton
/** 圆角 */
@property (nonatomic, assign) IBInspectable CGFloat radius;

/** 半圆配置 */
@property (nonatomic, assign) IBInspectable BOOL halfHeightCorner;

/** 线宽 */
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
/** 线颜色 */
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@end


@interface FMCornerImageView : UIImageView
/** 圆角 */
@property (nonatomic, assign) IBInspectable CGFloat radius;

/** 半圆配置 */
@property (nonatomic, assign) IBInspectable BOOL halfHeightCorner;

/** 线宽 */
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
/** 线颜色 */
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@end



NS_ASSUME_NONNULL_END
