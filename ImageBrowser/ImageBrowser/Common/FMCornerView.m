//
//  FMCornerView.m
//  MarketingPtoject
//
//  Created by fumi on 2019/3/2.
//  Copyright © 2019 fumi. All rights reserved.
//

#import "FMCornerView.h"

IB_DESIGNABLE
@implementation FMCornerView

- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    self.layer.cornerRadius = radius;
    self.clipsToBounds = YES;
}

- (void)setHalfHeightCorner:(BOOL)halfHeightCorner {
    _halfHeightCorner = halfHeightCorner;
    if (_halfHeightCorner) {
        self.radius = self.bounds.size.height / 2.0f;
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

@end


@implementation FMCornerButton

- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    self.layer.cornerRadius = radius;
    self.clipsToBounds = YES;
}

- (void)setHalfHeightCorner:(BOOL)halfHeightCorner {
    _halfHeightCorner = halfHeightCorner;
    if (_halfHeightCorner) {
        self.radius = self.bounds.size.height / 2.0f;
    }
}


- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}
@end


@implementation FMCornerImageView


- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    self.layer.cornerRadius = radius;
    self.clipsToBounds = YES;
}

- (void)setHalfHeightCorner:(BOOL)halfHeightCorner {
    _halfHeightCorner = halfHeightCorner;
    if (_halfHeightCorner) {
        self.radius = self.bounds.size.height / 2.0f;
    }
}


- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

@end
