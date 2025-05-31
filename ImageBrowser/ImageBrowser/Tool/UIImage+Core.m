//
//  UIImage+Core.m
//  YiShou
//
//  Created by gou on 2018/4/22.
//  Copyright © 2018年 FuMi. All rights reserved.
//

#import "UIImage+Core.h"

@implementation UIImage (Core)
+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    [color setFill];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (NSData *)compressDataToMaxLength:(NSUInteger)num{
    NSData *imageData = UIImageJPEGRepresentation(self, 1);
    if (imageData.length/1024 <= num) {
        return imageData;
    }
    // 允许偏差
    CGFloat allowable = 0.9;
    NSUInteger maxLength = num * 1024;
    NSUInteger minLength = maxLength * allowable;
    CGFloat max = 1;
    CGFloat min = 0;
    CGFloat compression = 0;
    for (int i=0; i<6; i++){
        @autoreleasepool {
            compression = (max+min)/2;
            imageData = UIImageJPEGRepresentation(self, compression);
            if (imageData.length >  maxLength) {
                max = (max + min)/2;
            }else if (imageData.length < minLength){
                min = (max + min)/2;
            }else { // 当     maxLength>= length <= allowable * maxLength
                break;
            }
        }
    }
    if (imageData.length < maxLength) return imageData;
    
    UIImage *resultImage = [UIImage imageWithData:imageData];
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (imageData.length > maxLength && imageData.length != lastDataLength) {
        lastDataLength = imageData.length;
        CGFloat ratio = (CGFloat)maxLength / imageData.length;
        CGSize size = CGSizeMake((NSUInteger)(self.size.width * sqrtf(ratio)),
                                 (NSUInteger)(self.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        imageData = UIImageJPEGRepresentation(resultImage, compression);
    }
    return imageData;
}
@end
