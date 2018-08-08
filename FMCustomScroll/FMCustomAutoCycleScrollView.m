//
//  FMCustomAutoCycleScroll.m
//  TestDemoForYiShou
//
//  Created by fumi on 2018/8/8.
//  Copyright © 2018年 fumi. All rights reserved.
//

#import "FMCustomAutoCycleScrollView.h"
/** 屏幕宽 */
#define kScreenWidth MIN([UIScreen mainScreen].bounds.size.width,[UIScreen  mainScreen].bounds.size.height)

@interface FMCyclePageControl : UIPageControl

@end

@implementation FMCyclePageControl

- (void)setCurrentPage:(NSInteger)page {
    
    [super setCurrentPage:page];
    
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++)
    {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        if (subviewIndex == page)
        {
            subview.alpha = 1;
        }
        else
        {
            subview.alpha = 0.5;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //计算圆点间距
    CGFloat marginX = 5 + 5;
    //计算整个pageControll的宽度
    CGFloat newW = self.subviews.count * marginX+3;
    //设置新frame
    self.bounds = CGRectMake(0, 0, newW, self.frame.size.height);
    
    //设置居中
    CGPoint center = self.center;
    center.x = self.superview.bounds.size.width/2.0f;
    self.center = center;
    
    //遍历subview,设置圆点frame
    for (int i=0; i<[self.subviews count]; i++)
    {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage) {
            [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, 13, 5)];
            dot.alpha = 1;
        } else if(i >self.currentPage) {
            [dot setFrame:CGRectMake((i+0.5) * marginX+3, dot.frame.origin.y, 5, 5)];
            dot.alpha = 0.5;
        } else {
            [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, 5, 5)];
            dot.alpha = 0.5;
        }
        dot.layer.masksToBounds = YES;
        dot.layer.cornerRadius = 2.5;
    }
}

@end



#pragma mark - CustomScrollView

@interface FMCustomAutoCycleScrollView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/** 主视图 */
@property (nonatomic, strong) UICollectionView *mainView;

@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic, strong) FMCyclePageControl *pageControl;
@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL disableTimer;


@end

@implementation FMCustomAutoCycleScrollView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.flowLayout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    self.mainView.frame = self.bounds;
}

- (void)initialization
{
    _timeInterval = 3;
}

- (void)finishConfigureView
{
    [self createUI];
    [self reloadDatas];
}

- (void)createUI
{
    [self addSubview:self.mainView];
    if (self.cellRegisterAction) {
        self.cellRegisterAction(self.mainView);
    } else {
        NSLog(@"未配置注册事件，请配置。。。");
    }
    
    [self addSubview:self.pageControl];
    
    self.mainView.frame = self.bounds;
    self.pageControl.center = CGPointMake(self.mainView.center.x, self.frame.size.height - 6);
    self.pageControl.bounds = CGRectMake(0, 0, self.bounds.size.width, 12);

}

+ (instancetype)customScrollViewWithFrame:(CGRect)frame placeholder:(UIImage *)image
{
    return [self customScrollViewWithFrame:frame placeholder:image disableTimer:NO];
}

+ (instancetype)customScrollViewWithFrame:(CGRect)frame placeholder:(UIImage *)image disableTimer:(BOOL)disableTimer
{
    FMCustomAutoCycleScrollView *cycleRollView = [[FMCustomAutoCycleScrollView alloc] initWithFrame:frame];
    cycleRollView.disableTimer = disableTimer;
    cycleRollView.placeholderImage = image;
    return cycleRollView;
}

#pragma mark - event

- (void)reloadDatas
{
    [self.mainView reloadData];
    if (self.totalCount > 1)
    {
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:50];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mainView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        });
        if (!self.disableTimer)
        {
            [self setupTimer];
        }
    }
}

- (void)setupTimer
{
    [self invalidateTimer];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)automaticScroll
{
    // 1.显示当前的位置信息
    
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForRow:self.pageControl.currentPage inSection:50];
    [self.mainView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    // 2.计算出下一个需要展示的位置
    NSUInteger nextItem = currentIndexPathReset.item + 1;
    NSUInteger nextSection = currentIndexPathReset.section;
    NSInteger totalCount = self.totalCount ;
    if (nextItem == totalCount) {
        nextItem = 0;
        nextSection ++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:nextItem inSection:nextSection];
    // 3.通过动画滚动到下一个位置
    
    [self.mainView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)updataUI
{
    [self.mainView.collectionViewLayout invalidateLayout];
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.mainView reloadData];
}

#pragma mark - delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.totalCount == 1) {
        return 1;
    }
    return 100;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.totalCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellConfigure) {
        return self.cellConfigure(collectionView, indexPath);
    } else {
        NSLog(@"未配置cell展示信息，请配置后再操作");
        return [UICollectionViewCell new];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.itemSelectedAction) {
        if (1 == self.totalCount) {
            self.itemSelectedAction(0);
        }  else {
            self.itemSelectedAction(indexPath.row);
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (int)((scrollView.contentOffset.x + 21) / (self.mainView.bounds.size.width)) % self.totalCount;
    self.pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!self.disableTimer) {
        [self invalidateTimer];
    }
    [self layoutIfNeeded];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!self.disableTimer) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

#pragma mark - setter

- (void)setTotalCount:(NSUInteger)totalCount
{
    _totalCount  = totalCount;
    self.pageControl.numberOfPages = self.totalCount;
    self.pageControl.currentPage = 0;
}

- (void)setPageControlNormalColor:(UIColor *)pageControlNormalColor
{
    _pageControlNormalColor = pageControlNormalColor;
    self.pageControl.pageIndicatorTintColor = _pageControlNormalColor;
}

- (void)setPageControlCurrentSelectColor:(UIColor *)pageControlCurrentSelectColor
{
    _pageControlCurrentSelectColor = pageControlCurrentSelectColor;
    self.pageControl.currentPageIndicatorTintColor = _pageControlCurrentSelectColor;
}

- (FMCyclePageControl *)pageControl
{
    if (!_pageControl)
    {
        _pageControl = [[FMCyclePageControl alloc] initWithFrame:CGRectZero];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.hidesForSinglePage = YES;
    }
    return _pageControl;
}

- (UICollectionView *)mainView
{
    if (!_mainView)
    {
        _mainView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _mainView.backgroundColor = [UIColor whiteColor];
        _mainView.showsHorizontalScrollIndicator = NO;
        _mainView.showsVerticalScrollIndicator = NO;
        _mainView.pagingEnabled = YES;
        
        _mainView.dataSource = self;
        _mainView.delegate = self;
        _mainView.scrollsToTop = NO;
        _mainView.decelerationRate = 10;
    }
    return _mainView;
    
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.sectionInset = UIEdgeInsetsZero;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}


@end
