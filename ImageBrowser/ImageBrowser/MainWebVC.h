//
//  MainWebVC.h
//  ddquickbao
//
//  Created by app on 16/7/13.
//  Copyright © 2016年 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainWebVC : UIViewController
+ (instancetype)shareController;
/**  链接地址 */
@property (nonatomic, assign) NSInteger *urlString;
@property (nonatomic, assign) BOOL isSuccess;
- (void)loadWithUrl:(NSString *)url;
@end
