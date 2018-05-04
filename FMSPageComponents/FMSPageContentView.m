//
//  FMSPageContentView.m
//  FSScrollContentViewDemo
//
//  Created by fumi on 2018/5/4.
//  Copyright © 2018年 haha. All rights reserved.
//

#import "FMSPageContentView.h"

#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])
static NSString *collectionCellIdentifier = @"collectionViewCellIdentifier";

@interface FMSPageContentView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak) UIViewController *parentVC;//父视图
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *childsVCClassNames; // 子视图类型数组
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat startOffsetX;
@property (nonatomic, assign) BOOL isSelectBtn;//是否是滑动

/** 用来存放控制器的字典，每次新创建一个控制器，就要将其加进去*/
@property (nonatomic, strong) NSMutableDictionary *vcDict;
@end

@implementation FMSPageContentView

- (instancetype)initWithFrame:(CGRect)frame childVCClassNames:(NSArray *)childVCClassNames titles:(NSArray *)titles parentVC:(UIViewController *)parentVC delegate:(id<FMSPageContentViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.parentVC = parentVC;
        self.childsVCClassNames = childVCClassNames;
        self.delegate = delegate;
        self.titles = titles;
        if (self.titles.count != self.childsVCClassNames.count) {
            NSLog(@"初始化数据失败");
            return nil;
        }
        [self setupSubViews];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark --LazyLoad

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = self.bounds.size;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.bounces = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectionCellIdentifier];
        [self addSubview:collectionView];
        self.collectionView = collectionView;
    }
    return _collectionView;
}

#pragma mark --setup
- (void)setupSubViews
{
    _startOffsetX = 0;
    _isSelectBtn = NO;
    _contentViewCanScroll = YES;
    
    self.vcDict = [[NSMutableDictionary alloc] initWithCapacity:self.childsVCClassNames.count];
    [self.collectionView reloadData];
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childsVCClassNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellIdentifier forIndexPath:indexPath];
    if (IOS_VERSION < 8.0) {
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        NSString *className = self.childsVCClassNames[indexPath.item];
        UIViewController <ChildViewControllerDelegate>* childVC = [self.vcDict objectForKey:indexPath];
        if (!childVC) {
            childVC = [[NSClassFromString(className) alloc] initWithTitle:self.titles[indexPath.item] index:indexPath.row];
            [self.vcDict setObject:childVC forKey:indexPath];
            [self.parentVC addChildViewController:childVC];
        }
        childVC.view.frame = cell.contentView.bounds;
        [cell.contentView addSubview:childVC.view];
    }
    return cell;
}

#ifdef __IPHONE_8_0
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSString *className = self.childsVCClassNames[indexPath.item];
    UIViewController <ChildViewControllerDelegate>* childVC = [self.vcDict objectForKey:indexPath];
    if (!childVC) {
        childVC = [[NSClassFromString(className) alloc] initWithTitle:self.titles[indexPath.row] index:indexPath.item];
        [self.vcDict setObject:childVC forKey:indexPath];
        [self.parentVC addChildViewController:childVC];
    }
    
    //    UIViewController *childVc = self.childsVCs[indexPath.row];
    childVC.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:childVC.view];
}
#endif

#pragma mark UIScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isSelectBtn = NO;
    _startOffsetX = scrollView.contentOffset.x;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(fmsContentViewWillBeginDragging:)]) {
        [self.delegate fmsContentViewWillBeginDragging:self];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_isSelectBtn) {
        return;
    }
    CGFloat scrollView_W = scrollView.bounds.size.width;
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    NSInteger startIndex = floor(_startOffsetX/scrollView_W);
    NSInteger endIndex;
    CGFloat progress;
    if (currentOffsetX > _startOffsetX) {//左滑left
        progress = (currentOffsetX - _startOffsetX)/scrollView_W;
        endIndex = startIndex + 1;
        if (endIndex > self.childsVCClassNames.count - 1) {
            endIndex = self.childsVCClassNames.count - 1;
        }
    }else if (currentOffsetX == _startOffsetX){//没滑过去
        progress = 0;
        endIndex = startIndex;
    }else{//右滑right
        progress = (_startOffsetX - currentOffsetX)/scrollView_W;
        endIndex = startIndex - 1;
        endIndex = endIndex < 0?0:endIndex;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(fmsContentViewDidScroll:startIndex:endIndex:progress:)]) {
        [self.delegate fmsContentViewDidScroll:self startIndex:startIndex endIndex:endIndex progress:progress];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat scrollView_W = scrollView.bounds.size.width;
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    NSInteger startIndex = floor(_startOffsetX/scrollView_W);
    NSInteger endIndex = floor(currentOffsetX/scrollView_W);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(fmsContentViewDidEndDecelerating:startIndex:endIndex:)]) {
        [self.delegate fmsContentViewDidEndDecelerating:self startIndex:startIndex endIndex:endIndex];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(fmsContentViewDidEndDragging:)]) {
            [self.delegate fmsContentViewDidEndDragging:self];
        }
    }
}

#pragma mark setter

- (void)setContentViewCurrentIndex:(NSInteger)contentViewCurrentIndex
{
    if (contentViewCurrentIndex < 0||contentViewCurrentIndex > self.childsVCClassNames.count-1) {
        return;
    }
    _isSelectBtn = YES;
    _contentViewCurrentIndex = contentViewCurrentIndex;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:contentViewCurrentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)setContentViewCanScroll:(BOOL)contentViewCanScroll
{
    _contentViewCanScroll = contentViewCanScroll;
    _collectionView.scrollEnabled = _contentViewCanScroll;
}

/** 当内存不足时需要移除不必要的控制器 */
- (void)reduceMemory
{

    for (NSIndexPath *indexPath in self.vcDict.allKeys) {
        if (indexPath != [[self.collectionView indexPathsForVisibleItems] firstObject]) {
            UIViewController <ChildViewControllerDelegate> *vc = [self.vcDict objectForKey:indexPath];
            if ([vc respondsToSelector:@selector(clearMemory)]) {
                [vc clearMemory];
            }
        }
    }
}

@end
