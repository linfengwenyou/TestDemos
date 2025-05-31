//
//  KGCircleBubbleView.h
//  GPUImageDemo
//
//  Created by rayor on 2021/5/26.
//

#import <UIKit/UIKit.h>

@interface KGCircleBubbleView : UIView

@property (nonatomic, assign) CGFloat enlargeRate;

/*开始执行动画, 是否为静默的动画*/
- (void)startAnimationWithDuration:(float)duration isSilence:(BOOL)isSilence;


@end
