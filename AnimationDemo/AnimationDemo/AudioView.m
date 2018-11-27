//
//  AudioView.m
//  AnimationDemo
//
//  Created by fumi on 2018/11/16.
//  Copyright © 2018 fumi. All rights reserved.
//

#import "AudioView.h"

@interface AudioView()

@property (nonatomic, strong) CAKeyframeAnimation *anim;
@property (nonatomic, strong) CALayer *animationLayer;
@end

@implementation AudioView

- (instancetype)initWithFrame:(CGRect)frame audioLineCount:(NSUInteger)count color:(nonnull UIColor *)color lineOffset:(NSUInteger)offset
{
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                     name:UIApplicationDidBecomeActiveNotification object:nil]; //监听是否重新进入程序程序.
        
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
    animationLayer.bounds = CGRectMake(0, 0, 2, 4);
    animationLayer.position = CGPointMake(2, self.bounds.size.height);
    animationLayer.cornerRadius = 0.7;
    animationLayer.masksToBounds = YES;
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim.duration = 0.65;
    anim.repeatCount = HUGE;
    
    NSValue *value1 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    NSValue *value2 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 2, 1)];
    NSValue *value3 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 0.5, 1)];
    anim.values = @[value1, value2, value3];
    [animationLayer addAnimation:anim forKey:nil];
    
    self.anim = anim;
    self.animationLayer = animationLayer;
    
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

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIApplicationDidBecomeActiveNotification];
}


- (void)applicationDidBecomeActive:noti
{
    [self.animationLayer addAnimation:self.anim forKey:nil];
}

@end
