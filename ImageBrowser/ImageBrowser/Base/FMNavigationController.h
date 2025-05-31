//
//  FMNavigationController.h
//  YiShou
//
//  Created by Kerry on 16/8/29.
//  Copyright © 2016年 FuMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMWrapViewController : UIViewController

@property (nonatomic, strong, readonly) UIViewController *rootViewController;

+ (FMWrapViewController *)wrapViewControllerWithViewController:(UIViewController *)viewController;

@end

@interface FMWrapNavigationController : UINavigationController

@end



@interface FMNavigationController : UINavigationController

@property (nonatomic, strong) UIImage *backButtonImage;
/** 是否开启全屏滑动返回功能（开启之后，则禁用系统边缘滑动返回） */
@property (nonatomic, assign) BOOL fullScreenPopGestureEnabled;
/** 是否取消滑动返回功能（取消之后，全屏滑动返回、系统边缘滑动返回 都将禁用） */
@property (nonatomic, assign) BOOL interactivePopDisabled;

@property (nonatomic, copy, readonly) NSArray *fm_viewControllers;

//获取倒数第二控制器
- (UIViewController *)previousViewController;
@end


@interface UIViewController (FMNavigationExtension)

@property (nonatomic, assign) BOOL fm_fullScreenPopGestureEnabled;

@property (nonatomic, assign) BOOL fm_interactivePopDisabled;

@property (nonatomic, weak) FMNavigationController *fm_navigationController;

@end
