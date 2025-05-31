//
//  FMImageBrowser.h
//  FMImageBrowser
//
//  Created by yao on 2018/8/17.
//  Copyright © 2018 FuMi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMImageBrowser : UIViewController
/** 数组内可传 UIImage、NSURL、NSString */
- (void)showImageBrowserFrom:(UIImageView *)fromView imageList:(NSArray*)imageList index:(NSInteger)index inController:(UIViewController *)controller;
- (void)showImageBrowserFromCollectionView:(UICollectionView *)collectionView imageList:(NSArray*)imageList index:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
