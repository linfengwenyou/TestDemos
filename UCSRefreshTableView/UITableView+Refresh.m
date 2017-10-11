//
//  UITableView+Refresh.m
//  EmptyTableDemo
//
//  Created by lawson on 2017/8/15.
//  Copyright © 2017年 ucs_coco. All rights reserved.
//

#import "UITableView+Refresh.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>
#import <objc/runtime.h>

static const char * UCS_REFRESH_EMPTY_VIEW = "UCS_Refresh_Empty_View";

@interface UITableView()
@property (nonatomic, strong) UCSRefreshTableViewEmptyView *emptyView;
@end

@implementation UITableView (Refresh)

#pragma mark - 空视图配置

// empty setter & getter
- (UCSRefreshTableViewEmptyView *)emptyView
{
    UCSRefreshTableViewEmptyView *tmpView = objc_getAssociatedObject(self, &UCS_REFRESH_EMPTY_VIEW);
    if (!tmpView) {
        // 配置空视图信息
        tmpView = [[UCSRefreshTableViewEmptyView alloc] initWithFrame:self.bounds];
        self.emptyView = tmpView;
        
    }
    
    return tmpView;
}

- (void)setEmptyView:(UCSRefreshTableViewEmptyView *)emptyView
{
    objc_setAssociatedObject(self, &UCS_REFRESH_EMPTY_VIEW, emptyView, OBJC_ASSOCIATION_RETAIN);
}

- (void)ucsConfigNoNetTip:(NSAttributedString *)noNetTip noNetImage:(UIImage *)noNetImage noDataTip:(NSAttributedString *)noDataTip noDataImage:(UIImage *)noDataImage
{
    self.emptyView.noNetTitle = noNetTip;
    self.emptyView.noNetImage = noNetImage;
    self.emptyView.noDataTitle = noDataTip;
    self.emptyView.noDataImage = noDataImage;
}

#pragma mark - 网络请求配置

- (void)ucsRequestDataSourcesWithTarget:(id)target refreshingAction:(SEL)action
{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
}

- (void)ucsLoadMoreDataSourcesWithTarget:(id)target refreshingAction:(SEL)action
{
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
}

- (void)ucsBeginRefresh
{
    [self.mj_header beginRefreshing];
    self.mj_footer.hidden = YES; // 初始刷新，保证只有下拉操作的loading信息，没有上拉的箭头信息
}

- (void)endRefresh
{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

- (void)ucsUpdateRefreshViewWithDataSource:(NSArray *)dataSource hasNetError:(BOOL)hasNetError hasMoreData:(BOOL)hasMoreData
{
    [self endRefresh];
    
    // footer是否展示加载更多按钮
    if (dataSource.count > 0 && hasMoreData) {
        self.mj_footer.hidden = NO;
    } else {
        self.mj_footer.hidden = YES;
    }
    
    // 空视图是否展示
    if (dataSource.count > 0) {
        [self.emptyView removeFromSuperview];
    } else {
        [self addSubview:self.emptyView];
        self.emptyView.frame = self.bounds; // 必须要设置，否则便会出现尺寸未更新问题
        self.emptyView.type = hasNetError ? UCSTableViewEmptyType_NoNet : UCSTableViewEmptyType_NoData;
    }
    
}


@end
