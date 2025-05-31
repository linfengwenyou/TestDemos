//
//  KGCircleBubbleView.m
//  GPUImageDemo
//
//  Created by rayor on 2021/5/26.
//

#import "KGCircleBubbleView.h"

@interface KGCircleBubbleView ()
@property (nonatomic, strong) NSMutableArray *animatinoLayers;
@end

@implementation KGCircleBubbleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)startAnimationWithDuration:(float)duration isSilence:(BOOL)isSilence {
    [self removeNoneAnimationLayer];
    // 创建一个layer执行动画
    CALayer *layer = [self createAnimationLayer];
    [self.layer addSublayer:layer];
    [self.animatinoLayers addObject:layer];
    
    CAAnimationGroup *group = [self animationIsSilence:isSilence duration:duration];
    [layer addAnimation:group forKey:@"group"];
}



- (void)removeNoneAnimationLayer {
    
    for (NSInteger i = self.animatinoLayers.count - 1; i>=0; i--) {
        CALayer *layer = self.animatinoLayers[i];
        if (layer.animationKeys.count < 1) {
            [layer removeFromSuperlayer];
            [self.animatinoLayers removeObject:layer];
        }
    }
    
    NSLog(@"当前动画图层数量：%ld", self.animatinoLayers.count);
}

#pragma mark - 创建动画

- (CALayer *)createAnimationLayer {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = UIColor.clearColor.CGColor;
    layer.strokeColor = UIColor.clearColor.CGColor;
    layer.lineWidth = 1;
    
    layer.path = [self fromPath].CGPath;
    return layer;
}

- (CAAnimationGroup *)animationIsSilence:(BOOL)isSilence duration:(float)duration {
    
    // 管理放大效果，使用这种方式，不会把图层的边界同时变宽
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"path";
    anim.fromValue = (__bridge id)[self fromPath].CGPath;
    anim.toValue = (__bridge id)[self endPath].CGPath;
    
    // 填充的颜色信息
    CABasicAnimation *anim1 = [CABasicAnimation animation];
    anim1.keyPath = @"strokeColor";
    anim1.fromValue = (__bridge  id)[UIColor.whiteColor colorWithAlphaComponent:0.5].CGColor;
    anim1.toValue = (__bridge  id)UIColor.clearColor.CGColor;
    
    
    CABasicAnimation *anim3 = [CABasicAnimation animation];
    anim3.keyPath = @"fillColor";
    anim3.fromValue = (__bridge  id)[UIColor.blueColor colorWithAlphaComponent:0.3].CGColor;
    anim3.toValue = (__bridge  id)UIColor.clearColor.CGColor;
    
    
    // 线宽情况处理
    CABasicAnimation *anim2 = [CABasicAnimation animation];
    anim2.keyPath = @"lineWidth";
    anim2.fromValue = (isSilence ? @1 : @2);
    anim2.toValue = @0;
    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[anim, anim1, anim2,anim3];
    group.duration = duration;
    group.removedOnCompletion = YES;
    
    
    return group;
}


#pragma mark - path
- (UIBezierPath *)fromPath {
    CGFloat width = self.bounds.size.width, height = self.bounds.size.width;
    UIBezierPath *fromPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f,height/2.0f) radius:height/2.0f startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    return fromPath;
}

- (UIBezierPath *)endPath {
    CGFloat width = self.bounds.size.width, height = self.bounds.size.width;
    UIBezierPath *endPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, height/2.0f) radius:height/2.0f*_enlargeRate startAngle:0 endAngle:2*M_PI clockwise:YES];
    return endPath;
}

#pragma mark - setter & getter
- (NSMutableArray *)animatinoLayers {
    if (!_animatinoLayers) {
        _animatinoLayers = @[].mutableCopy;
    }
    return _animatinoLayers;
}

@end
