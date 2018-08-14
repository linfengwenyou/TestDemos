//
//  FMAutoTextRollView.m
//  YiShou
//
//  Created by fumi on 2018/8/13.
//  Copyright © 2018年 FuMi. All rights reserved.
//

#import "FMAutoTextRollView.h"
#import "FMAutoTextRollCell.h"

@interface FMAutoTextRollView()<UICollectionViewDelegate, UICollectionViewDataSource>
{
        dispatch_source_t _timer;
}
@property (nonatomic, strong) UICollectionView *mainView;
@property (nonatomic, strong) NSIndexPath * purchaserIndexPath;
@end

@implementation FMAutoTextRollView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.mainView];
        [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return self;
}

#pragma mark - event

#pragma mark - network

#pragma mark - public
- (void)setPurchaserDatas:(NSArray *)purchaserDatas
{
    _purchaserDatas = purchaserDatas;
    if (purchaserDatas.count) {
 
        if (!_timer) {
            @YRWeakObj(self);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
            dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
            dispatch_source_set_event_handler(_timer, ^{
            @YRStrongObj(self);
                [self autoScrollAction];
            });
            dispatch_resume(_timer);
            
        } else {
            self.purchaserIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [self.mainView scrollToItemAtIndexPath:self.purchaserIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        }
    }
    [self.mainView reloadData];
}

- (void)autoScrollAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.purchaserIndexPath = [NSIndexPath indexPathForRow:self.purchaserIndexPath.row inSection:1];
        [self.mainView scrollToItemAtIndexPath:self.purchaserIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        
        NSInteger row = self.purchaserIndexPath.row;
        NSInteger section = self.purchaserIndexPath.section;
        if (row + 1 == self.purchaserDatas.count) {
            row = 0;
            section ++;
        } else {
            row++;
        }
        
        self.purchaserIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
        [self.mainView scrollToItemAtIndexPath:self.purchaserIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    });
}

#pragma mark - private

#pragma mark - delegate && datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.purchaserDatas.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FMAutoTextRollCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FMAutoTextRollCell class]) forIndexPath:indexPath];
    NSDictionary *dict = self.purchaserDatas[indexPath.row];
    cell.markStr = dict[@"purchaser_mark"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
 
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH, 42);
}
#pragma mark - setter && getter

- (UICollectionView *)mainView
{
    if (!_mainView) {
        UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _mainView = [[UICollectionView alloc] initWithFrame:CGRectMake(80, 0, SCREEN_WIDTH - 80, 42) collectionViewLayout:layout];
        _mainView.delegate = self;
        _mainView.dataSource = self;
        _mainView.backgroundColor = [UIColor whiteColor];
        _mainView.userInteractionEnabled = NO;
        [_mainView registerNib:[UINib nibWithNibName:FMStringOfClass(FMAutoTextRollCell) bundle:nil] forCellWithReuseIdentifier:FMStringOfClass(FMAutoTextRollCell)];
    }
    return _mainView;
}
@end
