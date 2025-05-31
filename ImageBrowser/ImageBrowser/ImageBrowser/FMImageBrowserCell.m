//
//  FMImageBrowserCell.m
//  FMImageBrowser
//
//  Created by yao on 2018/8/17.
//  Copyright © 2018 FuMi. All rights reserved.
//

#import "FMImageBrowserCell.h"
#import <UIImageView+WebCache.h>

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface FMImageBrowserCell()<UIScrollViewDelegate>
@property (strong, nonatomic)UIScrollView *scrollView;
@end
@implementation FMImageBrowserCell
#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
        
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
}

#pragma mark - private

#pragma mark - public

#pragma mark - network

#pragma mark - event

#pragma mark - delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}
#pragma mark - setter
//- (void)setImageURL:(NSURL *)imageURL{
//    _imageURL = imageURL;
//    __weak typeof(self) weakSelf = self;
//    self.scrollView.zoomScale = 1;
//    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    [self.imageView yy_setImageWithURL:imageURL placeholder:[UIImage imageNamed:@"common_placeholder"] options:(YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation) completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//        __strong typeof(weakSelf) self = weakSelf;
//        if (error) {
//            return;
//        }
//        self.imageView.contentMode = UIViewContentModeScaleToFill;
//        CGFloat w = UIScreen.mainScreen.bounds.size.width;
//        CGSize size = image.size;
//        size.height = size.height/size.width*w;
//        size.width = w;
//        if (isnan(size.height)|| isnan(size.width)) {
//            size = CGSizeZero;
//        }
//        self.imageView.image = image;
//        CGRect frame = self.imageView.frame;
//        frame.size = size;
//        self.imageView.frame = frame;
//        if (size.height > SCREEN_HEIGHT) {
//            self.imageView.origin = CGPointZero;
//        }else{
//            self.imageView.center = self.scrollView.center;
//        }
//        
//    }];
//}

- (void)setImage:(id)image
{
    _image = image;
    if ([image isKindOfClass:NSURL.class] || [image isKindOfClass:NSString.class]) {
        NSURL *temp = nil;
        if ([image isKindOfClass:NSURL.class]) {
            temp = image;
        }else if ([image isKindOfClass:NSString.class])
        {
            temp = [NSURL URLWithString:image];
        }
        __weak typeof(self) weakSelf = self;
        self.scrollView.zoomScale = 1;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.imageView sd_setImageWithURL:temp completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            __strong typeof(weakSelf) self = weakSelf;
            if (error) {
                return;
            }
            self.imageView.contentMode = UIViewContentModeScaleToFill;
            CGFloat w = UIScreen.mainScreen.bounds.size.width;
            CGSize size = image.size;
            size.height = size.height/size.width*w;
            size.width = w;
            if (isnan(size.height)|| isnan(size.width)) {
                size = CGSizeZero;
            }
            self.imageView.image = image;
            CGRect frame = self.imageView.frame;
            frame.size = size;
            self.imageView.frame = frame;
            if (size.height > SCREEN_HEIGHT) {
                self.imageView.origin = CGPointZero;
            }else{
                self.imageView.center = self.scrollView.center;
            }
            
        }];
    }else if ([image isKindOfClass:UIImage.class])
    {
        UIImage *realImage = (UIImage *)image;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        CGFloat w = UIScreen.mainScreen.bounds.size.width;
        CGSize size = realImage.size;
        size.height = size.height/size.width*w;
        size.width = w;
        if (isnan(size.height)|| isnan(size.width)) {
            size = CGSizeZero;
        }
        self.imageView.image = realImage;
        CGRect frame = self.imageView.frame;
        frame.size = size;
        self.imageView.frame = frame;
        if (size.height > SCREEN_HEIGHT) {
            self.imageView.origin = CGPointZero;
        }else{
            self.imageView.center = self.scrollView.center;
        }
    }
}

#pragma mark - getter
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 3;
        _scrollView.bouncesZoom = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:UIScreen.mainScreen.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}
@end
