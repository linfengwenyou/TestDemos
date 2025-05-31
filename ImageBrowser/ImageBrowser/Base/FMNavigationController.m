//
//  FMNavigationController.m
//  YiShou
//
//  Created by Kerry on 16/8/29.
//  Copyright © 2016年 FuMi. All rights reserved.
//

#import "FMNavigationController.h"

#import <objc/runtime.h>

NSString *const DefaultBackImageName = @"common_back_icon";

#pragma mark - UIViewController (FMNavigationExtension)

@implementation UIViewController (FMNavigationExtension)

- (void)setFm_fullScreenPopGestureEnabled:(BOOL)fm_fullScreenPopGestureEnabled
{
    objc_setAssociatedObject(self, @selector(fm_fullScreenPopGestureEnabled), @(fm_fullScreenPopGestureEnabled), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)fm_fullScreenPopGestureEnabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setFm_navigationController:(FMNavigationController *)fm_navigationController
{
    objc_setAssociatedObject(self, @selector(fm_navigationController), fm_navigationController, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setFm_interactivePopDisabled:(BOOL)fm_interactivePopDisabled
{
    objc_setAssociatedObject(self, @selector(fm_interactivePopDisabled), @(fm_interactivePopDisabled), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)fm_interactivePopDisabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (FMNavigationController *)fm_navigationController
{
    return objc_getAssociatedObject(self, _cmd);
}

@end


#pragma mark - FMWrapNavigationController

@implementation FMWrapNavigationController
- (id)navigationlock
{
    return self.topViewController;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    return [self.navigationController popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    return [self.navigationController popToRootViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    FMNavigationController *fm_navigationController = viewController.fm_navigationController;
    NSInteger index = [fm_navigationController.fm_viewControllers indexOfObject:viewController];
    return [self.navigationController popToViewController:fm_navigationController.viewControllers[index] animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.fm_navigationController = (FMNavigationController *)self.navigationController;
    viewController.fm_fullScreenPopGestureEnabled = viewController.fm_navigationController.fullScreenPopGestureEnabled;
    viewController.fm_interactivePopDisabled = viewController.fm_navigationController.interactivePopDisabled;
	
//    BOOL aa = viewController.fm_navigationController.fullScreenPopGestureEnabled;;
//    BOOL bb = viewController.fm_navigationController.interactivePopDisabled;
	
    UIImage *backButtonImage = viewController.fm_navigationController.backButtonImage;
    
    if (!backButtonImage) {
        backButtonImage = [UIImage imageNamed:DefaultBackImageName];
    }
    
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[backButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(didTapBackButton)];
    [viewController.navigationItem.titleView sizeToFit];
//	viewController.navigationItem.leftBarButtonItem.width = 40;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[FMWrapViewController wrapViewControllerWithViewController:viewController] animated:animated];
}

- (void)didTapBackButton {
    if (self.presentingViewController && self.navigationController.childViewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion: nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    [self.navigationController dismissViewControllerAnimated:flag completion:completion];
    self.viewControllers.firstObject.fm_navigationController=nil;
}

@end

#pragma mark - FMWrapViewController

static NSValue *fm_tabBarRectValue;

@implementation FMWrapViewController

+ (FMWrapViewController *)wrapViewControllerWithViewController:(UIViewController *)viewController {
    
    FMWrapNavigationController *wrapNavController = [[FMWrapNavigationController alloc] init];
    wrapNavController.viewControllers = @[viewController];
    
    FMWrapViewController *wrapViewController = [[FMWrapViewController alloc] init];
    wrapViewController.view.backgroundColor = [UIColor whiteColor];
    [wrapViewController.view addSubview:wrapNavController.view]; 
    [wrapViewController addChildViewController:wrapNavController];
    
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:17.0],
                                  NSForegroundColorAttributeName:UIColorFromRGB(0x333333),};
    wrapNavController.navigationBar.titleTextAttributes = attributes;
    [wrapNavController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    wrapNavController.navigationBar.shadowImage = [UIImage imageWithColor:UIColorFromRGB(0xeeeeee) size:CGSizeMake(1, 1)];
    
    
    return wrapViewController;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
//    if (self.tabBarController && !fm_tabBarRectValue) {
//        fm_tabBarRectValue = [NSValue valueWithCGRect:self.tabBarController.tabBar.frame];
//    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    if (self.tabBarController && [self rootViewController].hidesBottomBarWhenPushed) {
//        self.tabBarController.tabBar.frame = CGRectZero;
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.translucent = YES;
//    if (self.tabBarController && !self.tabBarController.tabBar.hidden && fm_tabBarRectValue) {
//        self.tabBarController.tabBar.frame = fm_tabBarRectValue.CGRectValue;
//    }
}

- (BOOL)fm_fullScreenPopGestureEnabled {
    return [self rootViewController].fm_fullScreenPopGestureEnabled;
}

- (BOOL)fm_interactivePopDisabled
{
    return [self rootViewController].fm_interactivePopDisabled;
}

- (BOOL)hidesBottomBarWhenPushed {
    return [self rootViewController].hidesBottomBarWhenPushed;
}

- (UITabBarItem *)tabBarItem {
    return [self rootViewController].tabBarItem;
}

- (NSString *)title {
    return [self rootViewController].title;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return [self rootViewController];
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return [self rootViewController];
}

- (UIViewController *)rootViewController {
    FMWrapNavigationController *wrapNavController = self.childViewControllers.firstObject;
    return wrapNavController.viewControllers.firstObject;
}

@end

#pragma mark FMNavigationController
@interface FMNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *popPanGesture;

@property (nonatomic, strong) id popGestureDelegate;


@end

@implementation FMNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super init]) {
        rootViewController.fm_navigationController = self;
        self.viewControllers = @[[FMWrapViewController wrapViewControllerWithViewController:rootViewController]];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.viewControllers.firstObject.fm_navigationController = self;
        self.viewControllers = @[[FMWrapViewController wrapViewControllerWithViewController:self.viewControllers.firstObject]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBarHidden:YES];
    self.delegate = self;
    self.popGestureDelegate = self.interactivePopGestureRecognizer.delegate;
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    self.popPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.popGestureDelegate action:action];
    self.popPanGesture.maximumNumberOfTouches = 1;
	self.popPanGesture.delegate = self;
}


#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    BOOL isRootVC = viewController == navigationController.viewControllers.firstObject;
    
    if (viewController.fm_interactivePopDisabled)
    {
        [self.view removeGestureRecognizer:self.popPanGesture];
        self.interactivePopGestureRecognizer.delegate = self;
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    else
    {
        if (viewController.fm_fullScreenPopGestureEnabled)
        {
            if (isRootVC) {
                [self.view removeGestureRecognizer:self.popPanGesture];
            } else {
                [self.view addGestureRecognizer:self.popPanGesture];
            }
            self.interactivePopGestureRecognizer.delegate = self.popGestureDelegate;
            self.interactivePopGestureRecognizer.enabled = NO;
        }
        else
        {
            [self.view removeGestureRecognizer:self.popPanGesture];
            self.interactivePopGestureRecognizer.delegate = self;
            self.interactivePopGestureRecognizer.enabled = !isRootVC;
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
//    CGPoint point = [self.popPanGesture translationInView:self.view];
//    if (point.x <= 0) { //当滑动是向右滑的时候，不可滑动
//        return NO;
//    }
    return YES;
}

/** return YES 修复有水平方向滚动的ScrollView时边缘返回手势失效的问题 */
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

#pragma mark - Getter

- (NSArray *)fm_viewControllers {
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (FMWrapViewController *wrapViewController in self.viewControllers) {
        [viewControllers addObject:wrapViewController.rootViewController];
    }
    return viewControllers.copy;
}

- (UIViewController *)previousViewController
{
    return [self.viewControllers[self.viewControllers.count - 2] rootViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
