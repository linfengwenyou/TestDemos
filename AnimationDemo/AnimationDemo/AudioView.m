//
//  AudioView.m
//  AnimationDemo
//
//  Created by fumi on 2018/11/16.
//  Copyright © 2018 fumi. All rights reserved.
//

#import "AudioView.h"

@interface AudioView()
@end

@implementation AudioView

- (instancetype)initWithFrame:(CGRect)frame audioLineCount:(NSUInteger)count color:(nonnull UIColor *)color lineOffset:(NSUInteger)offset
{
    if (self = [super initWithFrame:frame]) {
        [self setupAudioLineWithCont:count > 3?count:3 color:color?:[UIColor redColor] lineOffset:offset>1?offset:1];
    }
    return self;
}

- (void)setupAudioLineWithCont:(NSUInteger) count color:(UIColor *)color lineOffset:(NSUInteger)lineOffset
{
    // 圆圈旋转动画 可以用作加载的loading框
    CAShapeLayer *animationLayer = [[CAShapeLayer alloc] init];
    animationLayer.backgroundColor = color.CGColor;
    animationLayer.anchorPoint = CGPointMake(0, 1);
    animationLayer.bounds = CGRectMake(0, 0, 3, 4);
    animationLayer.position = CGPointMake(0, self.bounds.size.height);
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim.duration = 0.5;
    anim.repeatCount = HUGE;
    
    NSValue *value1 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    NSValue *value2 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 3, 1)];
    NSValue *value3 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 0.5, 1)];
    anim.values = @[value1, value2, value3];
    [animationLayer addAnimation:anim forKey:nil];
    
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer new];
    replicatorLayer.frame = self.bounds;
    [replicatorLayer addSublayer:animationLayer];
    replicatorLayer.repeatCount = HUGE;
    replicatorLayer.instanceCount = count;
    replicatorLayer.instanceDelay = anim.duration / replicatorLayer.instanceCount;
    lineOffset = animationLayer.bounds.size.width + lineOffset;
    replicatorLayer.instanceTransform = CATransform3DMakeTranslation(lineOffset, 0, 0);
    [self.layer addSublayer:replicatorLayer];
}

@end
