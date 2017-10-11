//
//  JMPasswordView.h
//  JuumanUIKITDemo
//
//  Created by juuman on 14-9-22.
//  Copyright (c) 2014年 juuman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMPasswordLineLayer.h"

#define jmPointRadius 30.0//圆半径
#define jmPointBorderWidth 1.0//圆边框宽
#define jmSmallPointRadius 6.0//小圆半径
#define jmPointLeftMargin 20.0//起始margin
#define jmPointTopMargin 20.0//起始margin
#define jmPointBetweenMargin 40.0//间隔*2
#define jmPathWidth 8.0//线宽
#define jmPasswordMinLength 4//最短密码

#define jmMiddlePointRadius  15.0  //中圆半径

#define kPassViewWidth (jmPointRadius*2*3 +jmPointBetweenMargin*2 + jmPointLeftMargin*2)


//#define jmPasswordPointColor [UIColor colorWithRed:50.0/255.0 green:200.0/255.0 blue:50.0/255.0 alpha:0.4]//圆颜色
#define jmPasswordPointColor [UIColor whiteColor]
#define jmPasswordPointBorderColor [UIColor grayColor]//圆框颜色
//#define jmPasswordSmallPointColor [UIColor colorWithRed:50.0/255.0 green:145/255.0 blue:60.0/255.0 alpha:1]//小圆颜色
#define jmPasswordSmallPointColor [UIColor whiteColor]
//#define jmPasswordPointHighlightColor [UIColor orangeColor]//圆高亮色
#define jmPasswordPointHighlightColor [UIColor whiteColor]
#define jmPasswordPointBorderHighlightColor [UIColor redColor]//圆框高亮色
//#define jmPasswordSmallPointHighlightColor [UIColor colorWithRed:1 green:0.0 blue:0.0 alpha:1]//小圆高亮色
#define jmPasswordSmallPointHighlightColor  [UIColor redColor]
#define jmPasswordLineColor [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.4]//线颜色

//密码状态
typedef enum ePasswordSate {
    ePasswordUnset,//未设置
    ePasswordRepeat,//重复输入
    ePasswordRepeatError,//重复输入出错
    ePasswordExist,//密码存在
    ePasswordError,//密码输入错误
    ePasswordSuccess//密码输入正确
}ePasswordSate;

@class JMPasswordView;
@protocol JMPasswordViewDelegate <NSObject>
#pragma mark - 输入完回掉
- (void)JMPasswordView:(JMPasswordView *)UCS1igSvlkOjYzumDggAWhBq withPassword:(NSString*)password;
#pragma mark-- 输入不符合格式的

@end

/*
 1. 宽度一般设置为300
 2. 如果需要自己设置选中样式，自己设置一下代码：
 self.contents=(id)[UIImage imageNamed:@"gesturePassword@2x.png"].CGImage;
 */
@interface JMPasswordView : UIView{
}
@property (nonatomic,weak) id<JMPasswordViewDelegate> delegate;
@property (nonatomic,strong) NSMutableArray* pointArr;
@property (nonatomic,strong) JMPasswordLineLayer *pathLayer;

@property (nonatomic,strong)NSMutableArray *pointIDArr;//当前已输的密码
@property (nonatomic)CGPoint nowTouchPoint;//当前位置

// fatal 选中点的图片,必须要设置，不然无法绘制图形
@property (nonatomic, strong) UIImage *selectedPointImage;



/**
 使用示例：
 
 1. 遵从代理
 <JMPasswordViewDelegate>
 
 
 2. 创建实例
 self.gestureView = [[JMPasswordView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - kPassViewWidth)/2.0f, 80, kPassViewWidth, 300)];
 self.gestureView.backgroundColor = [UIColor clearColor];
 self.gestureView.selectedPointImage = [UIImage imageNamed:@"gesturePassword"];    // 必须使用，否则无法正确绘制手势密码
 self.gestureView.delegate = self;
 [self.view addSubview:self.gestureView];


 
 3. 回调
 - (void)JMPasswordView:(JMPasswordView *)UCS1igSvlkOjYzumDggAWhBq withPassword:(NSString *)password
 {
 NSLog(@"password: %@",password);
 }
 
 
 
 NOTE:
 
 1. 如果需要在输入密码后进行加密处理，需要调整：
 - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
 {
 ...
 
 //    password = [DES3Util encryptUseDES:password key:REGEX_PASSWORD]; // 设置加密   调整加密方式
 
 ...
 }
 
 2. 如果需要调整选中的点的颜色
 直接设置替换source中的图片即可
 */


@end
