//
//  UCSRefreshTableViewEmptyView.m
//  EmptyTableDemo
//
//  Created by lawson on 2017/8/15.
//  Copyright © 2017年 ucs_coco. All rights reserved.
//

#import "UCSRefreshTableViewEmptyView.h"
#import <Masonry/Masonry.h>

@interface UCSRefreshTableViewEmptyView ()

@property (strong, nonatomic) UIImageView *contentImagView;
@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation UCSRefreshTableViewEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}


- (void)initUI
{
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    self.contentImagView = imageView;
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.textColor = [UIColor colorWithRed:102/255.0f green:102/255.0 blue:102/255.0 alpha:1];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tipLabel];
    self.contentLabel = tipLabel;

    
    [self.contentImagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentImagView.superview.mas_centerX);
        make.centerY.mas_equalTo(self.contentImagView.superview).multipliedBy(0.9);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentImagView.mas_bottom).offset(20);
        make.left.right.mas_equalTo(self.contentLabel.superview);
    }];
}


- (void)setType:(UCSTableViewEmptyType )type
{
    _type = type;
    switch (_type) {
        case UCSTableViewEmptyType_NoData:
        {
            self.contentImagView.image = self.noDataImage;
            if (self.noDataTitle) {
                self.contentLabel.attributedText = self.noDataTitle;
            } else {
                self.contentLabel.text = @"暂无内容";
            }
        }
            break;
        case UCSTableViewEmptyType_NoNet:
        {
            self.contentImagView.image = self.noNetImage;
            if (self.noNetTitle) {
                self.contentLabel.attributedText = self.noNetTitle;
            } else {
                self.contentLabel.text = @"网络中断";
            }
            
        }
            break;
    }
}

@end
