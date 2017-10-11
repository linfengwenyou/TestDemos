//
//  UCSInspectTextView.m
//  CoreTextDemo
//
//  Created by ucs_lws on 2017/4/27.
//  Copyright © 2017年 ucs_lws. All rights reserved.
//

#import "UCSInspectPlaceholderTextView.h"

@interface UCSInspectPlaceholderTextView ()

/**
 占位label
 */
@property (nonatomic, strong) UILabel * placeHolderLabel;

@end

@implementation UCSInspectPlaceholderTextView

#pragma mark - setter & getter
- (NSString *)content {
    return self.text;
}

-(void)setPlaceholder:(NSString *)placeholder
{
    if (_placeholder != placeholder) {
        _placeholder = placeholder;
        [self.placeHolderLabel removeFromSuperview];
        
        self.placeHolderLabel = nil;
        [self setNeedsDisplay];
    }
}

#pragma mark - 初始化
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configAttributes];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self configAttributes];
    }
    return self;
}

#pragma mark - 配置信息
- (void)configAttributes
{
    [self setPlaceholder:@""];
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangedFinished:) name:UITextViewTextDidEndEditingNotification object:nil];
    
}

#pragma mark - 事件响应
- (void)textChanged:(NSNotification *)notification
{
    if ([[self placeholder] length] == 0) {
        return;
    }
    if ([[self text] length] == 0) {
        [[self viewWithTag:999] setAlpha:1.0];
    } else{
        [[self viewWithTag:999] setAlpha:0];
    }
}

- (void)textChangedFinished:(NSNotification*)notification
{
    //    self.text = [notification.object objectForKey:@"text"];
#if DEBUG
//    NSLog(@"%@",notification.object);
//    NSLog(@"%@",self.text);
#endif
}

#pragma mark - 界面绘制
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if ([[self placeholder] length] > 0) {
        if (_placeHolderLabel == nil) {
            _placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 8, self.bounds.size.width-6, 0)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.numberOfLines = 0;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = 999;
            [self addSubview:_placeHolderLabel];
        }
        _placeHolderLabel.text = self.placeholder;
        [_placeHolderLabel sizeToFit];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    if ([[self text] length] == 0 && [[self placeholder] length] >0) {
        [[self viewWithTag:999] setAlpha:1.0];
    }
}


@end
