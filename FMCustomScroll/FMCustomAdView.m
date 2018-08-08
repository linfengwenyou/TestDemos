//
//  FMCustomAdView.m
//  TestDemoForYiShou
//
//  Created by fumi on 2018/8/8.
//  Copyright © 2018年 fumi. All rights reserved.
//

#import "FMCustomAdView.h"
#import "FMCustomAdFlowLayout.h"


/** 屏幕宽 */
#define kScreenWidth MIN([UIScreen mainScreen].bounds.size.width,[UIScreen  mainScreen].bounds.size.height)

@interface FMCustomAdView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/** 主视图 */
@property (nonatomic, strong) UICollectionView *mainView;
@property (nonatomic, strong) FMCustomAdFlowLayout * flowLayout;
@property (nonatomic, strong) UIImage *placeholderImage;

@end

@implementation FMCustomAdView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization
{
   
}

- (void)finishConfigureView
{
    [self createUI];
    [self.mainView reloadData];
}

- (void)createUI
{
    [self addSubview:self.mainView];
    
    if (self.cellRegisterAction) {
        self.cellRegisterAction(self.mainView);
    } else {
        NSLog(@"未配置注册事件，请配置。。。");
    }
    
#pragma mark - 需要配置回去
    self.mainView.frame = self.bounds;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

+ (instancetype)customScrollViewWithFrame:(CGRect)frame placeholder:(UIImage *)image
{
    FMCustomAdView *cycleRollView = [[FMCustomAdView alloc] initWithFrame:frame];
    cycleRollView.placeholderImage = image;
    return cycleRollView;
}

#pragma mark - event



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
    return 1;
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

#pragma mark - layout delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeEqualToSize(self.itemSize, CGSizeZero) ? CGSizeMake(self.bounds.size.width, self.bounds.size.height) : self.itemSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return self.itemLinePadding;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return self.itemLinePadding;
}


#pragma mark - setter

- (void)setItemSize:(CGSize)itemSize
{
    _itemSize = itemSize;
    self.flowLayout.itemSize = itemSize;
    [self.flowLayout invalidateLayout];
}

- (void)setItemLinePadding:(CGFloat)itemLinePadding
{
    _itemLinePadding = itemLinePadding;
    self.flowLayout.minimumInteritemSpacing = _itemLinePadding;
    self.flowLayout.minimumLineSpacing = _itemLinePadding;
    [self.flowLayout invalidateLayout];
}

- (void)setAnimationType:(FMCustomAdAnimationType)animationType
{
    _animationType = animationType;
    self.flowLayout.animationType = _animationType;
}

- (UICollectionView *)mainView
{
    if (!_mainView)
    {
        _mainView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _mainView.backgroundColor = [UIColor whiteColor];
        _mainView.showsHorizontalScrollIndicator = NO;
        _mainView.showsVerticalScrollIndicator = NO;
        _mainView.pagingEnabled = NO;
        
        _mainView.dataSource = self;
        _mainView.delegate = self;
        _mainView.scrollsToTop = NO;
    }
    return _mainView;
    
}

- (FMCustomAdFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[FMCustomAdFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 30, 0, 30);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

@end
