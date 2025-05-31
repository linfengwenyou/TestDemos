//
//  RAYMainViewController.m
//  demo
//
//  Created by fumi on 2019/4/12.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "RAYMainViewController.h"
#import "RAYMainImageCell.h"
#import "FMImageBrowser.h"
@interface RAYMainViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
/** 内容输入框 */
@property (weak, nonatomic) IBOutlet UITextField *textField;
/** 布局信息 */
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/** 数据源 */
@property (nonatomic, strong) NSArray *dataSources;
@end

@implementation RAYMainViewController
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选结果";
    [self configureCell];
    
}

#pragma mark - private

#pragma mark - public

#pragma mark - network


- (void)requestForWebUrl:(NSString *)url {
    
    // 获取网络请求
//    [NetManager loadDataFromUrl:url complete:^(NSData *datas, NSError *error) {
//        NSLog(@"%s",__FUNCTION__);
//
//        NSString *content = [[NSString alloc]  initWithData:datas encoding:NSUTF8StringEncoding];
////        NSLog(@"%@",content);
//        // 获取所有图片信息
//        self.dataSources = [RexFilterTool imageUrlsFromContent:content];
//        [self.collectionView reloadData];
//    }];
//
    
}

#pragma mark - event

- (IBAction)didClickSearchAction:(id)sender {
    NSLog(@"%s",__FUNCTION__);
//    if (!self.textField.hasText) {
//        [HudManager showHudWithText:@"请输入内容"];
//        return;
//    }
//    NSString *url = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if (![url hasPrefix:@"http"]) {
//        url = [@"https://" stringByAppendingString:url];
//    }
//
//
//    // 测试
//    url = @"https://image.baidu.com/search/acjson?tn=resultjson_com&ipn=rj&ct=201326592&is=&fp=result&queryWord=%E4%B8%96%E7%95%8C&cl=2&lm=-1&ie=utf-8&oe=utf-8&adpicid=&st=-1&z=&ic=0&hd=&latest=&copyright=&word=%E4%B8%96%E7%95%8C&s=&se=&tab=&width=&height=&face=0&istype=2&qc=&nc=1&fr=&expermode=&force=&pn=30&rn=30&gsm=300000000000000001e&1557388812213=";
//    [self requestForWebUrl:url];
}

#pragma mark - delegate

- (void)configureCell {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:RAYStringOfClass(RAYMainImageCell) bundle:nil] forCellWithReuseIdentifier:RAYStringOfClass(RAYMainImageCell)];
    
    CGFloat width = (UIScreen.mainScreen.bounds.size.width - 40 )/ 3;
    self.layout.itemSize =  CGSizeMake(width, width);
    self.layout.minimumLineSpacing = 10;
    self.layout.minimumInteritemSpacing = 10;
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RAYMainImageCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:RAYStringOfClass(RAYMainImageCell) forIndexPath:indexPath];
    cell.imageUrl = self.dataSources[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[FMImageBrowser new] showImageBrowserFromCollectionView:collectionView imageList:self.dataSources index:indexPath.row];
}

#pragma mark - setter
- (void)setContent:(NSString *)content {
    _content = content;
    self.dataSources = [RexFilterTool imageUrlsFromContent:content];
    [self.collectionView reloadData];
}

#pragma mark - getter


@end
