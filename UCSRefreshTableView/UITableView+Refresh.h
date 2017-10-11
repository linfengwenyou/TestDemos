//
//  UITableView+Refresh.h
//  EmptyTableDemo
//
//  Created by lawson on 2017/8/15.
//  Copyright © 2017年 ucs_coco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCSRefreshTableViewEmptyView.h"

// 暂时用不到
//typedef NS_ENUM(NSUInteger, UCSRefreshActionType) {
//    UCSRefreshActionType_headerRefresh = 0,     // 下拉刷新
//    UCSRefreshActionType_footerRefresh,         // 上拉加载
//};

@interface UITableView (Refresh)

/**
 如果要求界面进入就要刷新调用，一般要放到viewDidAppear，可以避免MJRefresh频繁刷新造成线程崩溃问题。
 注意要配置下面的请求方法后再调哦
 */
- (void)ucsBeginRefresh;

/**
 下拉刷新

 @param target 对象，一般为viewModel
 @param action 操作事件，为viewModel中的网络请求方法
 */
- (void)ucsRequestDataSourcesWithTarget:(id)target refreshingAction:(SEL)action;


/**
 上拉加载更多

 @param target 对象，一般为viewModel
 @param action 操作事件，为viewModel中加载更多的请求方法
 */
- (void)ucsLoadMoreDataSourcesWithTarget:(id)target refreshingAction:(SEL)action;

/**
 此处要求viewModel的写法要保持一致，此方法的调用需要放到网络请求的回调中，一般使用viewModel直接监听请求结果，对其进行处理即可

 @param dataSource 数据源信息，只用来判断当前数据数量
 @param hasNetError 是否网络请求失败，此处失败及当作网络异常， 当前址考虑一种情况就是网络异常
 @param hasMoreData 是否有更多数据，决定是否展示上拉效果
 */
- (void)ucsUpdateRefreshViewWithDataSource:(NSArray *)dataSource hasNetError:(BOOL)hasNetError hasMoreData:(BOOL)hasMoreData;

/**
 配置无数据或是网络失败情况处理

 @param noNetTip 无网络提示语， 默认为：@“oops 网络中断了!”
 @param noNetImage 无网路展示图片
 @param noDataTip 无数据提示语 默认为：@"暂无内容"
 @param noDataImage 无数据展示图片
 */
- (void)ucsConfigNoNetTip:(NSAttributedString *)noNetTip noNetImage:(UIImage *)noNetImage noDataTip:(NSAttributedString *)noDataTip noDataImage:(UIImage *)noDataImage;

@end
