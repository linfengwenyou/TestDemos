//
//  FMAutoTextRollCell.h
//  YiShou
//
//  Created by fumi on 2018/8/13.
//  Copyright © 2018年 FuMi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FMAutoTextRollCellAlianType) {
    FMAutoTextRollCellAlianTypeLeft = 1,            // 左对齐,默认对齐方式
    FMAutoTextRollCellAlianTypeRight = 2,           // 右对齐
};

@interface FMAutoTextRollCell : UICollectionViewCell
/** 对齐方式 */
@property (nonatomic, assign) FMAutoTextRollCellAlianType alianType;
// 头像什么的
@property (nonatomic, copy) NSString *imageUrl;
// 文字描述信息
@property (nonatomic, copy) NSString *markStr;

@end
