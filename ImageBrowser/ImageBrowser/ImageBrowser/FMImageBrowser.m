//
//  FMImageBrowser.m
//  FMImageBrowser
//
//  Created by yao on 2018/8/17.
//  Copyright © 2018 FuMi. All rights reserved.
//

#import "FMImageBrowser.h"
#import "FMImageBrowserCell.h"



@interface FMImageBrowser ()<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic)UIView *backgroundView;
@property (strong, nonatomic)UIImageView *imageView;
@property (strong, nonatomic)UIVisualEffectView *effectView;
@property (strong, nonatomic)UIPageControl *pageControl;

@property (assign, nonatomic) CGRect originFrame;
@property (strong, nonatomic) UIImage *originImage;
@property (weak, nonatomic)UIImageView *originImageView;
@property (nonatomic, nullable, weak) UICollectionView *originCollectionView;

@property (copy, nonatomic)NSArray *imageList;
@end

@implementation FMImageBrowser
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

#pragma mark - private
- (void)setup{
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.collectionView];
//    [self.view addSubview:self.pageControl];
    self.pageControl.center = CGPointMake(UIScreen.mainScreen.bounds.size.width/2, UIScreen.mainScreen.bounds.size.height-44);
    [self.collectionView registerClass:FMImageBrowserCell.class forCellWithReuseIdentifier:@"cell"];
    self.view.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self.view addGestureRecognizer:tap];
}
#pragma mark - public
- (void)showImageBrowserFromCollectionView:(UICollectionView *)collectionView imageList:(NSArray*)imageList index:(NSInteger)index{
    self.view.userInteractionEnabled = NO;
    self.originCollectionView = collectionView;
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    self.imageList = imageList;
    [KeyWindow.rootViewController addChildViewController:self];
    [KeyWindow.rootViewController.view addSubview:self.view];
    CGRect frame = [self.view convertRect:cell.frame fromView:cell.superview];
    self.imageView.frame = frame;
    id image = imageList[index];
    if ([image isKindOfClass:UIImage.class]) {
        self.imageView.image = image;
    } else if([image isKindOfClass:NSURL.class]) {
        [self.imageView sd_setImageWithURL:image placeholderImage:kPlaceHolder];
        
    } else if ([image isKindOfClass:NSString.class]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:kPlaceHolder];
    }
    self.pageControl.numberOfPages = self.imageList.count;
    self.pageControl.currentPage = index;
    [self.view addSubview:self.imageView];
    self.collectionView.hidden = YES;

    CGSize size = self.imageView.image.size;
    size.height = size.height/size.width*UIScreen.mainScreen.bounds.size.width;
    size.width = UIScreen.mainScreen.bounds.size.width;
    CGRect imageFrame = CGRectMake(0, 0, size.width, size.height);
    [self.collectionView reloadData];
    [UIView animateWithDuration:.5 animations:^{
        self.imageView.frame = imageFrame;
        self.imageView.center = self.view.center;
        self.effectView.alpha = 1;
    } completion:^(BOOL finished) {
        self.collectionView.hidden = NO;
        self.imageView.hidden = YES;
        if (self.imageList.count > 1) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:8*self.imageList.count+index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        self.view.userInteractionEnabled = YES;
    }];
}
- (void)showImageBrowserFrom:(UIImageView *)fromView imageList:(NSArray *)imageList index:(NSInteger)index inController:(UIViewController *)controller{
    self.view.userInteractionEnabled = NO;
    self.originImageView = fromView;
    self.originImage = fromView.image;
    self.imageList = imageList;
    self.originFrame = [self.imageView convertRect:fromView.frame fromView:fromView.superview];
    self.imageView.frame= self.originFrame;
    self.imageView.image = self.originImage;
    self.pageControl.numberOfPages = self.imageList.count;
    self.pageControl.currentPage = index;
    [self.view addSubview:self.imageView];
    self.collectionView.hidden = YES;
    fromView.image = nil;
    CGSize size = self.originImage.size;
    if (size.width > UIScreen.mainScreen.bounds.size.width) {
        size.height = size.height/size.width*UIScreen.mainScreen.bounds.size.width;
        size.width = UIScreen.mainScreen.bounds.size.width;
    }
    [controller addChildViewController:self];
    [controller.view addSubview:self.view];
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.imageView.frame = frame;
        self.imageView.center = self.view.center;
        self.effectView.alpha = 1;
    } completion:^(BOOL finished) {
        self.collectionView.hidden = NO;
        self.imageView.hidden = YES;
          [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:50*self.imageList.count+index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        self.view.userInteractionEnabled = YES;
    }];
    
}
- (void)dismiss{
    self.view.userInteractionEnabled = NO;
    FMImageBrowserCell *cell = self.collectionView.visibleCells.firstObject;
    [self.view addSubview:self.imageView];
    self.collectionView.hidden = YES;
    self.imageView.frame = [self.view convertRect:cell.imageView.frame fromView:cell.imageView.superview];
    self.imageView.image = cell.imageView.image;
    self.imageView.hidden = NO;
    if (self.originCollectionView) {
        UICollectionViewCell *cell = [self.originCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.pageControl.currentPage inSection:0]];
        self.originFrame = [self.view convertRect:cell.frame fromView:cell.superview];
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.imageView.frame = self.originFrame;
                         self.view.alpha = 0.2;
                     }
                     completion:^(BOOL finished) {
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                         self.originImageView.image = self.originImage;
                     }];
}
#pragma mark - network

#pragma mark - event
- (void)imageMove:(UIPanGestureRecognizer *)gesture{
    CGPoint offset = [gesture translationInView:self.view];
    CGFloat y = fabs(offset.y);
    NSLog(@"--y:%f",y);
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        {
            CGPoint center = gesture.view.center;
            center.y = UIScreen.mainScreen.bounds.size.height/2 + offset.y;
            gesture.view.center = center;
            self.backgroundView.alpha = 1 - y/400;
            gesture.view.alpha = 1- y/400;
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            self.view.userInteractionEnabled = NO;
            if (y > 250) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint center = gesture.view.center;
                    center.y = UIScreen.mainScreen.bounds.size.height/2 + offset.y/y*400;
                    gesture.view.center = center;
                    self.backgroundView.alpha = 0;
                    gesture.view.alpha = 0;
                } completion:^(BOOL finished) {
                    [self.view removeFromSuperview];
                    [self removeFromParentViewController];
                    self.originImageView.image = self.originImage;
                }];
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    gesture.view.center = self.view.center;
                    self.backgroundView.alpha = 1;
                    gesture.view.alpha = 1;
                    self.view.userInteractionEnabled = YES;
                }];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark - delegate
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.imageList.count <= 1) {
        return self.imageList.count;
    }
    return 10086;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FMImageBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (cell.imageView.gestureRecognizers.count == 0){
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(imageMove:)];
        [cell.imageView addGestureRecognizer:pan];
        pan.delegate = self;
        cell.imageView.userInteractionEnabled = YES;
    }
    cell.image = self.imageList[indexPath.row%self.imageList.count];
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.pageControl.currentPage = index%self.imageList.count;
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint offset = [pan translationInView:self.collectionView];
    return fabs(offset.x) == 0;
}
#pragma mark - setter

#pragma mark - getter
- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]initWithFrame:UIScreen.mainScreen.bounds];
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:effect];
        effectView.frame = _backgroundView.frame;
        [_backgroundView addSubview:effectView];
    }
    return _backgroundView;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = UIScreen.mainScreen.bounds.size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:UIScreen.mainScreen.bounds collectionViewLayout:layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    return _imageView;
}
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        [_pageControl sizeToFit];
        
    }
    return _pageControl;
}
@end
