//
//  UCSRefreshTableViewEmptyView.h
//  EmptyTableDemo
//
//  Created by lawson on 2017/8/15.
//  Copyright © 2017年 ucs_coco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UCSTableViewEmptyType) {
    UCSTableViewEmptyType_NoData = 0,    // 无数据
    UCSTableViewEmptyType_NoNet,         // 无网络
};

@interface UCSRefreshTableViewEmptyView : UIView

/**
 需要等配置完成才可配置Type，否则使用默认图片和提示语
 */
@property (nonatomic, assign) UCSTableViewEmptyType type;

/**
 无网络提示图片
 */
@property (nonatomic, strong) UIImage *noNetImage;

/**
 无网络提示语
 */
@property (nonatomic, copy) NSAttributedString *noNetTitle;

/**
 无数据提示图片
 */
@property (nonatomic, strong) UIImage *noDataImage;

/**
 无数据提示语
 */
@property (nonatomic, copy) NSAttributedString *noDataTitle;

//- (void)updateSubViewsConstraint;
@end
