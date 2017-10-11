//
//  JMPasswordPointLayer.h
//  JuumanUIKITDemo
//
//  Created by juuman on 14-9-22.
//  Copyright (c) 2014年 juuman. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UCSBottomType) {
    UCSBottomDefaultType=0,//默认 绘制
    UCSBottomImageType=1,// 图片 绘制
};
@interface JMPasswordPointLayer : CALayer

@property (nonatomic) BOOL highlighted;
@property (nonatomic, strong) UIImage *selectedImg; // 选中样式
@end
