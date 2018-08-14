//
//  FMAutoTextRollCell.m
//  YiShou
//
//  Created by fumi on 2018/8/13.
//  Copyright © 2018年 FuMi. All rights reserved.
//

#import "FMAutoTextRollCell.h"

@interface FMAutoTextRollCell()
@property (nonatomic, weak) IBOutlet UIImageView * avatar;
@property (nonatomic, weak) IBOutlet UILabel * name;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarWH;
@end

@implementation FMAutoTextRollCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatarWH.constant = 0;
}


- (void)setMarkStr:(NSString *)markStr
{
    _markStr = markStr;
    self.name.text = _markStr;
}

- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    self.avatarWH.constant = 25;
//    self.avatar.image = IMAGENAME(@"usr_head");
    [self.avatar fm_setImageWithURL:[NSURL URLWithString:_imageUrl]];
}

- (void)setAlianType:(FMAutoTextRollCellAlianType)alianType
{
    _alianType = alianType;
    switch (_alianType) {
        case FMAutoTextRollCellAlianTypeLeft:
        {
            self.avatarLeading.priority = UILayoutPriorityRequired;
            self.nameTrailing.priority = UILayoutPriorityDefaultLow;
        }
            break;
        case FMAutoTextRollCellAlianTypeRight:
        {
            self.avatarLeading.priority = UILayoutPriorityDefaultLow;
            self.nameTrailing.priority = UILayoutPriorityRequired;
        }
            break;
    }
}

@end
