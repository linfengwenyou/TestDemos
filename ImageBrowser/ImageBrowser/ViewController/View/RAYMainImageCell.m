
//
//  RAYMainImageCell.m
//  ImageBrowser
//
//  Created by fumi on 2019/5/9.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "RAYMainImageCell.h"

@interface RAYMainImageCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation RAYMainImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:kPlaceHolder];
}

@end
