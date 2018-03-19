# Utility
常用的简单控件

## 手机号，银行卡号格式化输入

## 列表刷新
### 使用方式
当前的组件是通过分类加载起作用，使用只需要操作几个配置就可以了，第2和第3项可以直接放到initUI或initViewModel中

依赖组件：MJRefresh, Masonry

组件适用场景：MVVM结构，网络层封装到viewModel中

#### 1. 导入组件
```
#import <UCSRefreshTableView.h>
```

#### 2. 配置上拉下拉事件  当前目的是为了与第三方MJRefresh进行解耦

```
  [self.tableView ucsRequestDataSourcesWithTarget:self.viewModel refreshingAction:self.viewModel.requestForInterestCouponsCommand];  // 下拉刷新或首次加载
    [self.tableView ucsLoadMoreDataSourcesWithTarget:self.viewModel refreshingAction:self.viewModel.requestMoreInterestCouponsCommand]; // 上拉加载更多

```

#### 3. 配置空视图信息

```
  [self.tableView ucsConfigNoNetTip:[[NSAttributedString alloc] initWithString:@"呀呀呀，网络错喽！" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                                                           NSForegroundColorAttributeName:[UIColor purpleColor]}] noNetImage:UCSImageWithName(@"banner_default") noDataTip:nil noDataImage:UCSImageWithName(@"setting_icon_default")];  // 图片传空代表不展示图片，文字有默认设置，要传属性字符串
```

#### 4. 在网络请求回调中处理事件

```
// UCSBindPropertyWithSeletor(self.viewModel, couponsModel, @selector(updateCouponsModel:viewModel:));  // initViewModel中绑定事件

// 注意点：当前是通过监听viewModel中的couponsModel属性来做的，而在赋值couponsModel之前，已经处理了属性loadFinished,是否已加载完成
- (void)updateCouponsModel:(UCSMyUserInterestCouponsModel *)value viewModel:(UCSMyInterestCouponsViewModel *)viewModel   // 这是绑定的事件
{
    [self.tableView ucsUpdateRefreshViewWithDataSource:viewModel.dataSource hasNetError:!value.isSuccess hasMoreData:!viewModel.loadFinished];    // viewModel.loadFinished这个属性用来判断是否已加载完成
    [self.tableView reloadData];
}
```

### 扫码

 `FMScannerVC`

#### 示例：

```
 FMScannerVC *scanner = [[FMScannerVC alloc] init];
 scanner.scanType = FMCodeScannerTypeBarcode;
 [self presentViewController:scanner animated:YES completion:nil];
 scanner.scanResultBlock = ^(NSString *value) {
    操作扫描到的信息
 };
```



### 附：

#### 示例 viewModel中逻辑

```

- (void)requestForInterestCouponsCommand:(id)target
{
    UCSApiMyUserInterestCoupons *api = [[UCSApiMyUserInterestCoupons alloc] initWithLastIndex:@"" investAmount:self.investAmount type:self.type];
    [api startWithSID:self.SID successBlock:^(__kindof UCSMyUserInterestCouponsModel *model) {
        if (model.couponList.count > 0) {
            self.dataSource = model.couponList;
            self.loadFinished = NO;
        } else{
            self.loadFinished = YES;
        }
        self.couponsModel = model;				// 最后赋值，保证dataSource loadFinished已经判定结束
    } fail:^(__kindof UCSBaseResposeModel *model, __kindof UCSBaseRequest *baseRequst) {
        self.couponsModel = model;				// 请求失败不更新dataSource信息，loadFinished信息
    }];
}

- (void)requestMoreInterestCouponsCommand:(id)target
{
    UCSApiMyUserInterestCoupons *api = [[UCSApiMyUserInterestCoupons alloc] initWithLastIndex:self.couponsModel.lastIndex investAmount:self.investAmount type:self.type];
    [api startWithSID:self.SID successBlock:^(__kindof UCSMyUserInterestCouponsModel *model) {
        
        if (model.couponList.count > 0) {
            self.dataSource = [self componentsArrWithArray:model.couponList];  // 数据去重，后台如果做了处理，这个就可以不用做了
            self.loadFinished = NO;
        } else {
            self.loadFinished = YES;
        }
        self.couponsModel = model; // 一定要放到最后赋值
    } fail:^(__kindof UCSBaseResposeModel *model, __kindof UCSBaseRequest *baseRequst) {
        // 保存之前数据
        self.couponsModel = model;
    }];
}

- (NSArray *)componentsArrWithArray:(NSArray *)couponArr
{
    NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithArray:self.dataSource];
   
    [couponArr enumerateObjectsUsingBlock:^(UCSCouponListItemModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *tem = [tmpArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"couponID = %@",obj.couponID]];
        if (tem.count == 0) {
            [tmpArr addObject:obj];
        }
    }];
    
    return [tmpArr copy];
}
```


## 便捷创建一些storyboard上可以直接看出效果的控件，

* button边角
* placeholderTextView
* 环形lable
* 手势密码
* 方框墨点密码
* 环形进度条信息


