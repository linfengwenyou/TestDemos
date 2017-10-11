//
//  UCSCircleProgressView.m
//  CoreTextDemo
//
//  Created by ucs_lws on 2017/4/27.
//  Copyright © 2017年 ucs_lws. All rights reserved.
//

#import "UCSCircleProgressView.h"

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

@interface UCSCircleProgressView()

//记录进度的Label
@property (nonatomic, strong) CATextLayer *centerLayer;

// 环背景
@property (nonatomic, strong) CALayer *backLayer;

// 环遮罩
@property (nonatomic, strong) CAShapeLayer *circleMaskLayer;

// 文字的背景色 默认clearColor
@property (nonatomic, strong) UIColor *labelbackgroundColor;

@end

@implementation UCSCircleProgressView

#pragma mark - setter & getter
- (CATextLayer *)centerLayer
{
    if (!_centerLayer) {
        _centerLayer = [[CATextLayer alloc] init];
        // 只展示一行
        CGRect bounds = CGRectMake(0, 0, WIDTH, HEIGHT/2);
        _centerLayer.frame = CGRectOffset(bounds, 0, HEIGHT/2);
        _centerLayer.anchorPoint = CGPointMake(0.5, 0.5);
        _centerLayer.alignmentMode = kCAAlignmentCenter;
        _centerLayer.contentsScale = [UIScreen mainScreen].scale;
    }
    return _centerLayer;
}

- (CALayer *)backLayer
{
    if (!_backLayer) {
        _backLayer = [[CALayer alloc] init];
        _backLayer.frame = self.bounds;
    }
    return _backLayer;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self updateAttributes];
}

- (void)setTextFontSize:(CGFloat)textFontSize
{
    _textFontSize = textFontSize;
    [self updateAttributes];
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    [self updateAttributes];
}

- (void)setProgressWidth:(CGFloat)progressWidth
{
    _progressWidth = progressWidth;
    [self updateAttributes];
}

- (CAShapeLayer *)circleMaskLayer
{
    if (!_circleMaskLayer) {
        _circleMaskLayer = [CAShapeLayer layer];
        _circleMaskLayer.frame = self.bounds;
        _circleMaskLayer.fillColor = [UIColor clearColor].CGColor;
        _circleMaskLayer.strokeColor = [UIColor blackColor].CGColor;
        _circleMaskLayer.strokeEnd = 0;
        _circleMaskLayer.opacity = 0.8;  // 不透明度【浑浊度】，越大，看的越清楚，越小越模糊，与透明度正好反过来
        _circleMaskLayer.lineCap = kCALineCapRound;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f) radius:(MIN(self.bounds.size.width, self.bounds.size.height) - 10)/2.0f startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        _circleMaskLayer.path = path.CGPath;
    }

    return _circleMaskLayer;
}

- (void)updateAttributes
{
    self.centerLayer.foregroundColor = _textColor.CGColor;
    self.centerLayer.fontSize = _textFontSize;
    self.backLayer.backgroundColor = _progressColor.CGColor;
    self.circleMaskLayer.lineWidth = _progressWidth;
    
    CGSize size = [@"demo" boundingRectWithSize:CGSizeMake(WIDTH, HEIGHT/2) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_textFontSize]} context:nil].size;
    
    CGRect bounds = CGRectMake(0, 0, WIDTH, size.height);
    self.centerLayer.frame = CGRectOffset(bounds, 0, HEIGHT/2.0f - size.height/2.0f);
    
}

#pragma mark - 初始化
- (instancetype)init
{
    if(self = [super init]) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        [self initData];
    }
    return self;
}

/**
 初始化数据
 */
- (void)initData
{
    self.backgroundColor = [UIColor whiteColor];

    self.progressWidth = 3.0;
    self.progressColor = [UIColor blueColor];
    self.progressBackgroundColor = [UIColor grayColor];

    self.labelbackgroundColor = [UIColor clearColor];
    self.textColor = [UIColor blackColor];
    self.completeTextColor = [UIColor lightGrayColor];
    self.textFontSize = 15.0f;

    
    self.formatter = ^NSString *(CGFloat percent) {
        NSString *str = [NSString stringWithFormat:@"%.1f%%",percent * 100];
        return str;
    };
    self.percent = 0.0;
    self.completeText = @"完成";
  
    // 添加环图层
    [self.layer addSublayer:self.backLayer];
    [self.backLayer setMask:self.circleMaskLayer];
    
    // 文字图层
    [self.layer addSublayer:self.centerLayer];
}

- (void)setPercent:(float)percent
{
    if (percent < 0) {
        return;
    }
    _percent = (percent > 1) ? 1 : percent;
    
    NSString *contentStr = [NSString stringWithFormat:@"%.1f%%",_percent * 100];
    if (self.formatter) {
        contentStr = self.formatter(_percent);
    }
    
    if (_percent == 1) {
        self.centerLayer.foregroundColor = self.completeTextColor.CGColor;
        self.centerLayer.string = self.completeText;
    } else {
        self.centerLayer.foregroundColor = self.textColor.CGColor;
        self.centerLayer.string = contentStr;
    }
    self.circleMaskLayer.strokeEnd = _percent;
}


@end
