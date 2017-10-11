//
//  JMPasswordPointLayer.m
//  JuumanUIKITDemo
//
//  Created by juuman on 14-9-22.
//  Copyright (c) 2014年 juuman. All rights reserved.
//

#import "JMPasswordPointLayer.h"
#import "JMPasswordView.h"

@implementation JMPasswordPointLayer
@synthesize highlighted;

- (void)drawInContext:(CGContextRef)ctx
{
    CGRect pointFrame = self.bounds;
    //外空心圆
    UIBezierPath *pointPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(jmPointBorderWidth, jmPointBorderWidth, pointFrame.size.width-2*jmPointBorderWidth, pointFrame.size.height-2*jmPointBorderWidth)
                                                         cornerRadius:pointFrame.size.height / 2.0];
    //内实心圆
    UIBezierPath *smallPointPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(pointFrame.size.width/2.0-jmSmallPointRadius, pointFrame.size.width/2.0-jmSmallPointRadius, 2*jmSmallPointRadius, 2*jmSmallPointRadius)
                                                              cornerRadius:jmSmallPointRadius];
    
    //内空心圆
//    UIBezierPath *middlePointPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(pointFrame.size.width/2.0-jmMiddlePointRadius, pointFrame.size.width/2.0-jmMiddlePointRadius, 2*jmMiddlePointRadius, 2*jmMiddlePointRadius)
//                                                              cornerRadius:jmMiddlePointRadius];
//
//    
//    //左1/4园  右1/4园
//    CGPoint middlePoint =  CGPointMake(pointFrame.size.width/2.0-(pointFrame.size.width/2.0-jmMiddlePointRadius)*0.5, pointFrame.size.width/2.0-(pointFrame.size.width/2.0-jmMiddlePointRadius)*0.5);
//    UIBezierPath *leftPointPath=[UIBezierPath bezierPathWithArcCenter:middlePoint radius:pointFrame.size.width/2.0-jmMiddlePointRadius startAngle:M_PI_2*2.5 endAngle:M_PI_2*5 clockwise:YES];
    
    if (self.highlighted)
    {
//        CGContextSetFillColorWithColor(ctx, jmPasswordPointHighlightColor.CGColor);
//        CGContextSetStrokeColorWithColor(ctx, jmPasswordPointBorderHighlightColor.CGColor);
//        CGContextSetLineWidth(ctx, jmPointBorderWidth);
//        CGContextAddPath(ctx, pointPath.CGPath);
//        CGContextDrawPath(ctx, kCGPathFillStroke);
//        
//        CGContextSetFillColorWithColor(ctx, jmPasswordPointBorderHighlightColor.CGColor);
//        CGContextAddPath(ctx, smallPointPath.CGPath);
//        CGContextSetLineWidth(ctx, jmPointBorderWidth);
//        CGContextDrawPath(ctx, kCGPathFill);
//        
//        CGContextSetFillColorWithColor(ctx, jmPasswordPointHighlightColor.CGColor);
//        CGContextSetStrokeColorWithColor(ctx, jmPasswordPointBorderHighlightColor.CGColor);
//        CGContextSetLineWidth(ctx, jmPointBorderWidth);
//        CGContextAddPath(ctx, middlePointPath.CGPath);
//        CGContextDrawPath(ctx, kCGPathFillStroke);
//        
//        //左
//        CGContextSetFillColorWithColor(ctx, jmPasswordPointHighlightColor.CGColor);
//        CGContextSetStrokeColorWithColor(ctx, jmPasswordPointBorderHighlightColor.CGColor);
//        CGContextSetLineWidth(ctx, jmPointBorderWidth);
//        CGContextAddPath(ctx, leftPointPath.CGPath);
//        CGContextDrawPath(ctx, kCGPathFillStroke);
        
        self.contents = (id)self.selectedImg.CGImage;
//         self.contents=(id)[UIImage imageNamed:@"gesturePassword@2x.png"].CGImage;

    }
    else{
        CGContextSetFillColorWithColor(ctx, jmPasswordPointColor.CGColor);
        CGContextSetStrokeColorWithColor(ctx, jmPasswordPointBorderColor.CGColor);
        CGContextSetLineWidth(ctx, jmPointBorderWidth);
        CGContextAddPath(ctx, pointPath.CGPath);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        
        CGContextSetFillColorWithColor(ctx, jmPasswordSmallPointColor.CGColor);
        CGContextAddPath(ctx, smallPointPath.CGPath);
        CGContextDrawPath(ctx, kCGPathFill);
    }
    
}

@end
