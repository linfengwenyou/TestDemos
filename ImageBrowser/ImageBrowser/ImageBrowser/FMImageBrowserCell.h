//
//  FMImageBrowserCell.h
//  FMImageBrowser
//
//  Created by yao on 2018/8/17.
//  Copyright © 2018 FuMi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMImageBrowserCell : UICollectionViewCell
//@property (strong, nonatomic)NSURL *imageURL;
/** UIImage、NSURL、NSString */
@property (nonatomic, strong) id image;
@property (strong, nonatomic)UIImageView *imageView;
@end

NS_ASSUME_NONNULL_END
