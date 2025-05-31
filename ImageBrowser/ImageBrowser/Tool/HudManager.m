//
//  HudManager.m
//  ImageBrowser
//
//  Created by fumi on 2019/5/9.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "HudManager.h"
#import <UIKit/UIKit.h>

@interface HudManager()

@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation HudManager

+ (instancetype)shareInstance {
    static HudManager * instance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[HudManager alloc] init];
    });
    return instance;
}


+ (void)showHudWithText:(NSString *)tips {
    [[HudManager shareInstance] showHudWithText:tips];
}


#pragma mark private


- (void)showHudWithText:(NSString *)tips {
    [self hideHud];
    self.hud = [MBProgressHUD showHUDAddedTo:UIApplication.sharedApplication.keyWindow animated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.margin = 18;
    self.hud.removeFromSuperViewOnHide = YES;
    self.hud.contentColor = [UIColor whiteColor];
    
    self.hud.label.font = [UIFont systemFontOfSize:14.0];
    self.hud.label.numberOfLines = 0;
    self.hud.label.textColor = [UIColor darkTextColor];
    self.hud.label.text = tips;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideHud];
    });
}

- (void)hideHud {
    [MBProgressHUD hideHUDForView:UIApplication.sharedApplication.keyWindow animated:YES];
}



@end
