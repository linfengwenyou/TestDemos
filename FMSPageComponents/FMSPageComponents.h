
//
//  FMSPageComponents.h
//  FSScrollContentViewDemo
//
//  Created by fumi on 2018/5/4.
//  Copyright © 2018年 haha. All rights reserved.
//

#ifndef FMSPageComponents_h
#define FMSPageComponents_h

#import "FMSPageContentView.h"
#import "FMSSegmentTitleView.h"


#endif /* FMSPageComponents_h */
/**
使用方式：
 titleView 标题串：
 NSArray *titles = @[@"全部",@"服饰穿搭",@"生活百货",@"美食吃货",@"美容护理",@"母婴儿童",@"数码家电",@"其他"];
 self.titleView = [[FMSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), 50) titles:titles delegate:self indicatorType:FMSSegmentTitleViewTypeDefault];
 self.titleView.titleSelectFont = [UIFont systemFontOfSize:18];
 self.titleView.selectIndex = 0;
 [self.view addSubview:_titleView];
 
 
 内容视图:
 NSArray *classArray = @[@"ChildViewController",@"ChildViewController",@"ChildViewController",@"ChildViewController",@"ChildViewController",@"ChildViewController",@"ChildViewController",@"ChildViewController"];
 
 self.pageContentView = [[FMSPageContentView alloc] initWithFrame:CGRectMake(0, 114, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 90) childVCClassNames:classArray titles:titles parentVC:self delegate:self];
 self.pageContentView.contentViewCurrentIndex = 0;
 //    self.pageContentView.contentViewCanScroll = NO;//设置滑动属性
 [self.view addSubview:_pageContentView];

 
 
 如果两个都有使用需要考虑路联动,使用代理
 
 - (void)fmsSegmentTitleView:(FMSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
 {
 self.pageContentView.contentViewCurrentIndex = endIndex;
 }
 
 - (void)fmsContentViewDidEndDecelerating:(FMSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
 {
 self.titleView.selectIndex = endIndex;
 }

 
 * 注意事项：
    1. 子控制器需要遵循协议 ChildViewControllerDelegate 并且实现初始化方法,当前考虑点是控制器都是一样，只是根据不同索引需要设置接口请求参数的不同数值
    2. 清理内存方法可以不实现

 */
