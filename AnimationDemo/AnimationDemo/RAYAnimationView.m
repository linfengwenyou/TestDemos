//
//  RAYAnimationView.m
//  AnimationDemo
//
//  Created by fumi on 2018/11/17.
//  Copyright © 2018 fumi. All rights reserved.
//

#import "RAYAnimationView.h"

@implementation RAYAnimationView

- (void)testRollingAnimation
{
    // 圆圈旋转动画 可以用作加载的loading框
    CAShapeLayer *animationLayer = [[CAShapeLayer alloc] init];
    animationLayer.backgroundColor = [UIColor redColor].CGColor;
    animationLayer.bounds = CGRectMake(0, 0, 15, 15);
    animationLayer.position = CGPointMake(100, 50);
    animationLayer.cornerRadius = 7.5;
    animationLayer.transform = CATransform3DMakeScale(0, 0, 1);
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.duration = 1;
    anim.repeatCount = HUGE;
    anim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1)];
    [animationLayer addAnimation:anim forKey:nil];
    
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer new];
    replicatorLayer.frame = CGRectMake(0, 0, 200, 200);
    [replicatorLayer addSublayer:animationLayer];
    replicatorLayer.repeatCount = HUGE;
    replicatorLayer.instanceCount = 20;
    replicatorLayer.instanceDelay = anim.duration / replicatorLayer.instanceCount;
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(M_PI/9, 0, 0, 1);
    replicatorLayer.instanceAlphaOffset = -0.05;
    // 将动画添加到指定容器即可
    
    [self.layer addSublayer:replicatorLayer];
}

- (void)testCircleAnimation
{
    // 同心圆放大效果
    CAShapeLayer *shapL = [CAShapeLayer layer];
    shapL.backgroundColor = [UIColor redColor].CGColor;
    shapL.bounds = CGRectMake(0, 0, 20, 20);
    shapL.position = CGPointMake(100, 100);
    shapL.cornerRadius = 10;
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(10, 10, 1)];
    anim.duration = 2;
    
    CABasicAnimation *anim1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anim1.fromValue = @1;
    anim1.toValue = @0;
    anim1.duration = 2;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[anim, anim1];
    group.duration = 2;
    group.repeatCount = HUGE;
    [shapL addAnimation:group forKey:nil];
    
    CAReplicatorLayer *replayer = [CAReplicatorLayer layer];
    [replayer addSublayer:shapL];
    replayer.instanceCount = 3;
    replayer.instanceDelay = 0.5;
    [self.layer addSublayer:replayer];
}


@end
