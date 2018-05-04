//
//  FMSSegmentTitleView.m
//  FSScrollContentViewDemo
//
//  Created by fumi on 2018/5/4.
//  Copyright © 2018年 haha. All rights reserved.
//

#import "FMSSegmentTitleView.h"

@interface FMSSegmentTitleView ()<UIScrollViewDelegate>



@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray<UIButton *> *itemBtnArr;

@property (nonatomic, strong) UIView *indicatorView;

@property (nonatomic, assign) FMSSegmentTitleViewType indicatorType;

@property (nonatomic, strong) NSArray *titlesArr;

@end

@implementation FMSSegmentTitleView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titlesArr delegate:(id<FMSSegmentTitleViewDelegate>)delegate indicatorType:(FMSSegmentTitleViewType)incatorType
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initWithProperty];
        self.delegate = delegate;
        self.indicatorType = incatorType;       // 需要放到titlesArr赋值前面，保证类型在重整布局时展示出来
        self.titlesArr = titlesArr;
    }
    return self;
}
//初始化默认属性值
- (void)initWithProperty
{
    self.itemMargin = 20;
    self.selectIndex = 0;
    self.titleNormalColor = [UIColor blackColor];
    self.titleSelectColor = [UIColor redColor];
    self.titleFont = [UIFont systemFontOfSize:15];
    self.indicatorColor = self.titleSelectColor;
    self.indicatorExtension = 5.f;
    self.titleSelectFont = self.titleFont;
    self.wrapBackNormalColor = [UIColor groupTableViewBackgroundColor];
    self.wrapBackSelectedColor = [UIColor lightGrayColor];
    
}
//重新布局frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    if (self.itemBtnArr.count == 0) {
        return;
    }
    CGFloat totalBtnWidth = 0.0;
    UIFont *titleFont = _titleFont;
    
    if (_titleFont != _titleSelectFont) {
        for (int idx = 0; idx < self.titlesArr.count; idx++) {
            UIButton *btn = self.itemBtnArr[idx];
            titleFont = btn.isSelected?_titleSelectFont:_titleFont;
            CGFloat itemBtnWidth = [FMSSegmentTitleView sizeWithString:self.titlesArr[idx] font:titleFont].width + self.itemMargin;
            totalBtnWidth += itemBtnWidth;
        }
    }
    else
    {
        for (NSString *title in self.titlesArr) {
            CGFloat itemBtnWidth = [FMSSegmentTitleView sizeWithString:title font:titleFont].width + self.itemMargin;
            totalBtnWidth += itemBtnWidth;
        }
    }
    if (self.indicatorType == FMSSegmentTitleViewTypeWrap) { // 重新布局按钮样式, 不使用下面的布局样式
        [self layoutButtons];
    } else {
        if (totalBtnWidth <= CGRectGetWidth(self.bounds)) {//不能滑动
            CGFloat itemBtnWidth = CGRectGetWidth(self.bounds)/self.itemBtnArr.count;
            CGFloat itemBtnHeight = CGRectGetHeight(self.bounds);
            [self.itemBtnArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.frame = CGRectMake(idx * itemBtnWidth, 0, itemBtnWidth, itemBtnHeight);
            }];
            self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.scrollView.bounds));
        }else{//超出屏幕 可以滑动
            CGFloat currentX = 0;
            for (int idx = 0; idx < self.titlesArr.count; idx++) {
                UIButton *btn = self.itemBtnArr[idx];
                titleFont = btn.isSelected?_titleSelectFont:_titleFont;
                CGFloat itemBtnWidth = [FMSSegmentTitleView sizeWithString:self.titlesArr[idx] font:titleFont].width + self.itemMargin;
                CGFloat itemBtnHeight = CGRectGetHeight(self.bounds);
                btn.frame = CGRectMake(currentX, 0, itemBtnWidth, itemBtnHeight);
                currentX += itemBtnWidth;
            }
            self.scrollView.contentSize = CGSizeMake(currentX, CGRectGetHeight(self.scrollView.bounds));
        }
    }
    [self moveIndicatorView:YES];
}

- (void)layoutButtons
{
    UIFont *titleFont = _titleFont;
    CGFloat currentX = 20;
    for (int idx = 0; idx < self.titlesArr.count; idx++) {
        UIButton *btn = self.itemBtnArr[idx];
        titleFont = btn.isSelected?_titleSelectFont:_titleFont;
        CGSize itemSize = [FMSSegmentTitleView sizeWithString:self.titlesArr[idx] font:titleFont];
        CGFloat itemBtnWidth = itemSize.width + self.itemMargin;
        CGFloat itemBtnHeight = itemSize.height + 10;
        CGFloat y = (CGRectGetHeight(self.bounds) - itemBtnHeight) / 2.0f;
        btn.frame = CGRectMake(currentX, y, itemBtnWidth, itemBtnHeight);
        currentX += (itemBtnWidth + 20);
    }
    self.scrollView.contentSize = CGSizeMake(currentX, CGRectGetHeight(self.scrollView.bounds));
}

- (void)moveIndicatorView:(BOOL)animated
{
    UIFont *titleFont = _titleFont;
    UIButton *selectBtn = self.itemBtnArr[self.selectIndex];
    titleFont = selectBtn.isSelected?_titleSelectFont:_titleFont;
    CGFloat indicatorWidth = [FMSSegmentTitleView sizeWithString:self.titlesArr[self.selectIndex] font:titleFont].width;
    [UIView animateWithDuration:(animated?0.05:0) animations:^{
        switch (_indicatorType) {
            case FMSSegmentTitleViewTypeDefault:
                self.indicatorView.frame = CGRectMake(selectBtn.frame.origin.x , CGRectGetHeight(self.scrollView.bounds) - 2, CGRectGetWidth(selectBtn.bounds), 2);
                break;
            case FMSSegmentTitleViewTypeEqualTitle:
                self.indicatorView.center = CGPointMake(selectBtn.center.x, CGRectGetHeight(self.scrollView.bounds) - 1);
                self.indicatorView.bounds = CGRectMake(0, 0, indicatorWidth, 2);
                break;
            case FMSSegmentTitleViewTypeCustom:
                self.indicatorView.center = CGPointMake(selectBtn.center.x, CGRectGetHeight(self.scrollView.bounds) - 1);
                self.indicatorView.bounds = CGRectMake(0, 0, indicatorWidth + _indicatorExtension*2, 2);
                break;
            case FMSSegmentTitleViewTypeNone:
                self.indicatorView.frame = CGRectZero;
                break;
            case FMSSegmentTitleViewTypeWrap:
                self.indicatorView.frame = CGRectZero;
                break;
            default:
                break;
        }
    } completion:^(BOOL finished) {
        [self scrollSelectBtnCenter:animated];
    }];
}

- (void)scrollSelectBtnCenter:(BOOL)animated
{
    UIButton *selectBtn = self.itemBtnArr[self.selectIndex];
    CGRect centerRect = CGRectMake(selectBtn.center.x - CGRectGetWidth(self.scrollView.bounds)/2, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    [self.scrollView scrollRectToVisible:centerRect animated:animated];
}

#pragma mark --LazyLoad

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (NSMutableArray<UIButton *>*)itemBtnArr
{
    if (!_itemBtnArr) {
        _itemBtnArr = [[NSMutableArray alloc]init];
    }
    return _itemBtnArr;
}

- (UIView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc]init];
        [self.scrollView addSubview:_indicatorView];
    }
    return _indicatorView;
}

#pragma mark --Setter

- (void)setTitlesArr:(NSArray *)titlesArr
{
    _titlesArr = titlesArr;
    [self.itemBtnArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.itemBtnArr = nil;
    for (NSString *title in titlesArr) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = self.itemBtnArr.count + 666;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:_titleNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
        btn.titleLabel.font = _titleFont;
        [self.scrollView addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (self.itemBtnArr.count == self.selectIndex) {
            btn.selected = YES;
        }
        [self.itemBtnArr addObject:btn];
        
        if (self.indicatorType == FMSSegmentTitleViewTypeWrap) {
            [btn setBackgroundColor:self.wrapBackNormalColor];
            if (btn.isSelected) {
                [btn setBackgroundColor:self.wrapBackSelectedColor];
            }
            btn.layer.cornerRadius = 7;
            [btn.layer masksToBounds];
        }
        
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setItemMargin:(CGFloat)itemMargin
{
    _itemMargin = itemMargin;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    if (_selectIndex == selectIndex||selectIndex < 0||selectIndex > self.itemBtnArr.count - 1) {
        return;
    }
    
    UIButton *lastBtn = [self.scrollView viewWithTag:_selectIndex + 666];
    lastBtn.selected = NO;
    
    _selectIndex = selectIndex;
    
    UIButton *currentBtn = [self.scrollView viewWithTag:_selectIndex + 666];
    currentBtn.selected = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        lastBtn.titleLabel.font = _titleFont;
        currentBtn.titleLabel.font = _titleSelectFont;
    }];
    
    
    if (self.indicatorType == FMSSegmentTitleViewTypeWrap) {
        [lastBtn setBackgroundColor:self.wrapBackNormalColor];
        [currentBtn setBackgroundColor:self.wrapBackSelectedColor];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    for (UIButton *btn in self.itemBtnArr) {
        btn.titleLabel.font = titleFont;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setTitleSelectFont:(UIFont *)titleSelectFont
{
    if (_titleFont == titleSelectFont) {
        _titleSelectFont = _titleFont;
        return;
    }
    _titleSelectFont = titleSelectFont;
    for (UIButton *btn in self.itemBtnArr) {
        btn.titleLabel.font = btn.isSelected?titleSelectFont:_titleFont;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor
{
    _titleNormalColor = titleNormalColor;
    for (UIButton *btn in self.itemBtnArr) {
        [btn setTitleColor:titleNormalColor forState:UIControlStateNormal];
    }
}

- (void)setTitleSelectColor:(UIColor *)titleSelectColor
{
    _titleSelectColor = titleSelectColor;
    for (UIButton *btn in self.itemBtnArr) {
        [btn setTitleColor:titleSelectColor forState:UIControlStateSelected];
    }
}

- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
    self.indicatorView.backgroundColor = indicatorColor;
}

- (void)setIndicatorExtension:(CGFloat)indicatorExtension
{
    _indicatorExtension = indicatorExtension;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


- (void)setWrapBackNormalColor:(UIColor *)wrapBackNormalColor
{
    _wrapBackNormalColor = wrapBackNormalColor;
    // 刷新所有按钮
    for (UIButton *btn in self.itemBtnArr) {
        if (!btn.isSelected) {
            [btn setBackgroundColor:_wrapBackNormalColor];
        }
    }
}

- (void)setWrapBackSelectedColor:(UIColor *)wrapBackSelectedColor
{
    _wrapBackSelectedColor = wrapBackSelectedColor;
    // 刷新所有按钮
    for (UIButton *btn in self.itemBtnArr) {
        if (btn.isSelected) {
            [btn setBackgroundColor:_wrapBackSelectedColor];
        }
    }
}

#pragma mark --Btn

- (void)btnClick:(UIButton *)btn
{
    NSInteger index = btn.tag - 666;
    if (index == self.selectIndex) {
        return;
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(fmsSegmentTitleView:startIndex:endIndex:)]) {
        [self.delegate fmsSegmentTitleView:self startIndex:self.selectIndex endIndex:index];
    }
    self.selectIndex = index;
}

#pragma mark UIScrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(fmsSegmentTitleViewWillBeginDragging:)]) {
        [self.delegate fmsSegmentTitleViewWillBeginDragging:self];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(fmsSegmentTitleViewWillEndDragging:)]) {
        [self.delegate fmsSegmentTitleViewWillEndDragging:self];
    }
}


#pragma mark Private
/**
 计算字符串长度
 
 @param string string
 @param font font
 @return 字符串长度
 */
+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/**
 随机色
 
 @return 调试用
 */
+ (UIColor*) randomColor{
    NSInteger r = arc4random() % 255;
    NSInteger g = arc4random() % 255;
    NSInteger b = arc4random() % 255;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}


@end
