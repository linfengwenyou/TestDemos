//
//  UCSCircleLabel.m
//  CoreTextDemo
//
//  Created by ucs_lws on 2017/4/27.
//  Copyright © 2017年 ucs_lws. All rights reserved.
//

#import "UCSInspectCircleLabel.h"
#import <CoreText/CoreText.h>

@implementation UCSInspectCircleLabel

#pragma mark - setter & getter
- (void)setCircleLineWidth:(CGFloat)circleLineWidth
{
    _circleLineWidth = circleLineWidth;
    [self setNeedsDisplay];
}

- (void) setTitle:(NSString *)title
{
    _title = title;
    [self setNeedsDisplay];
}

#pragma mark - 绘图
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    /*
    // 这种方式容易控制超出区域不进行展示, 不容易处理居中对齐问题
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    
    // 裁剪
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, NULL, self.bounds);
    CGContextClip(ctx);
    
    CGRect newBounds = CGRectMake(_circleLineWidth, _circleLineWidth, self.bounds.size.width-2*_circleLineWidth, self.bounds.size.height-2*_circleLineWidth);

    // 绘制边框
    CGContextAddEllipseInRect(ctx, newBounds);
    [[UIColor lightGrayColor] setStroke];
    CGContextSetLineWidth(ctx, _circleLineWidth);
    CGContextStrokePath(ctx);
    
       CGMutablePathRef textPath = CGPathCreateMutable();
    CGPathAddEllipseInRect(textPath, NULL, newBounds);
    
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentCenter;
    style.lineSpacing = 1.0f;

    
    NSDictionary *attr = @{
                           NSParagraphStyleAttributeName:style,
                           NSForegroundColorAttributeName:[UIColor darkGrayColor]
                           };
    
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:_title attributes:attr];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attrString length]), textPath, NULL);
    CTFrameDraw(frame, ctx);
    
    [[UIColor lightGrayColor] setStroke];
    CGContextSetLineWidth(ctx, _circleLineWidth);
    CGContextStrokePath(ctx);

    CFRelease(frame);
    CFRelease(path);
    CFRelease(textPath);
    CFRelease(framesetter);
    
    */
    // 使用下面方式，需要考虑字体造成的影响，而且可能会出现多行时导致展示变形
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextAddEllipseInRect(ctx, rect);
    
//    CGContextAddArc(ctx, self.center.x, self.center.y, MIN(self.frame.size.width, self.frame.size.height)/2.0f, 0, 2 * M_PI, 1);
    CGPathAddEllipseInRect(path, NULL, CGRectMake(0, 0, rect.size.width, rect.size.height));
    CGContextClip(ctx);
    CGPathRelease(path);
    
    
    CGContextAddEllipseInRect(ctx, CGRectMake(self.circleLineWidth+rect.origin.x, self.circleLineWidth+rect.origin.y, rect.size.width-2*self.circleLineWidth, rect.size.height - 2*self.circleLineWidth));
    self.circleLineColor = self.circleLineColor ? self.circleLineColor : [UIColor lightGrayColor];
    [self.circleLineColor setStroke];
    CGContextSetLineWidth(ctx, self.circleLineWidth);
    CGContextStrokePath(ctx);
    
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentCenter;
    style.lineSpacing = 1.0f;
    
    self.fontSize = self.fontSize < 12.0f ? 12.0f : self.fontSize;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:self.fontSize],NSForegroundColorAttributeName:[UIColor darkGrayColor],NSParagraphStyleAttributeName:style};
    
    CGRect titleRect = [self.title boundingRectWithSize:CGSizeMake(rect.size.width - 5 - self.circleLineWidth*2, rect.size.height - 5-self.circleLineWidth*2) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    CGSize strSize = titleRect.size;
    CGFloat marginTop = (rect.size.height - strSize.height)/2;
    
    [self.title drawInRect:CGRectMake(rect.origin.x+self.circleLineWidth, marginTop + rect.origin.y, rect.size.width, strSize.height) withAttributes:attributes];
    
}



@end
