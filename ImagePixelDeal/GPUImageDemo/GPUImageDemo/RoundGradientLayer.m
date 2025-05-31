//
//  RoundGradientLayer.m
//  GPUImageDemo
//
//  Created by rayor on 2021/5/26.
//

#import "RoundGradientLayer.h"

@implementation RoundGradientLayer

+ (RoundGradientLayer *)createGradientLayerWithFrame:(CGRect)frame
                                           locations:(CGFloat[])locations
                                              colors:(NSArray *)colors {
    RoundGradientLayer *layer = [RoundGradientLayer layer];
    layer.frame = frame;
    UIImage *image = [layer circleImageWithRect:layer.bounds locations:locations colors:colors];   // 创建渐变的图片信息
    layer.contents = (__bridge id)image.CGImage;
    return layer;
}


- (UIImage *)circleImageWithRect:(CGRect)rect locations:(CGFloat[])locations colors:(NSArray *)colors {
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 创建路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    
    // 绘制路径
    [self drawRadialGradient:ctx
                        path:path.CGPath
                      colors:colors
                   locations:locations
     ];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}



- (void)drawRadialGradient:(CGContextRef)context path:(CGPathRef)path colors:(NSArray *)colors locations:(CGFloat[])locations
{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //    CGFloat locations[] = {0.f, 1.f};
    
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge  CFArrayRef)colors, locations);
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint center = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect));
    CGFloat radius = MAX(pathRect.size.width / 2.0f, pathRect.size.height / 2.0f) * sqrt(2);
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextEOClip(context);
    
    CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    
    CGColorSpaceRelease(colorSpace);
    
}


@end
