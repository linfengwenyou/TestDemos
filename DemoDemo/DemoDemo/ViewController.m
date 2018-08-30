//
//  ViewController.m
//  DemoDemo
//
//  Created by fumi on 2018/8/14.
//  Copyright © 2018年 fumi. All rights reserved.
//

#import "ViewController.h"
#import "MyTempView.h"
#import <Masonry.h>
#import "AgainView.h"

@interface ViewController ()
@property (nonatomic, strong) MyTempView *tempView;
@property (nonatomic, strong) AgainView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.view addSubview:self.tempView];
    NSString *titles = @"这是一个笑话这个笑话这这是一个笑话这是一个笑话这是一个笑话这是一个笑话这是一个笑话这是一个笑话这是一个笑话这是一个笑话哈哈哈哈哈";
    self.tempView.titles = titles;
    [self.tempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(80);
        make.left.right.mas_equalTo(self.view);
    }];
    
  
    [self.imageView updateFrame];
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tempView.mas_bottom).offset(20);
        make.left.right.mas_equalTo(self.view);
    }];
    [self.view layoutIfNeeded];  // 直接调整布局
    
    
    NSLog(@"%.2f",CGRectGetMaxY(self.imageView.frame));
   
}


- (AgainView *)imageView
{
    if (!_imageView) {
        _imageView = [[AgainView alloc] init];
        _imageView.backgroundColor = [UIColor blueColor];
    }
    return _imageView;
}

- (MyTempView *)tempView
{
    if (!_tempView) {
        _tempView = [MyTempView loadFromNib];
    }
    return _tempView;
}
@end
