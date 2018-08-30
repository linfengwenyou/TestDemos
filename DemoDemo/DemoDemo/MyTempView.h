//
//  MyTempView.h
//  DemoDemo
//
//  Created by fumi on 2018/8/27.
//  Copyright © 2018年 fumi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTempView : UIView

+ (instancetype)loadFromNib;

@property (nonatomic, copy) NSString *titles;
@end
