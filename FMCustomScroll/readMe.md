#### CustomAutoCycleScrollView 

> 自动滚动，可以根据需要配置不同的cell

```
[self.activityView addSubview:self.autoScrollActivityView];
self.autoScrollActivityView.totalCount = 2;		// 几个元素
self.autoScrollActivityView.timeInterval = 3;   // 3s 自动滚动 
[self.autoScrollActivityView finishConfigureView]; // 配置完成后开始设置自动滚动
```





```
- (FMCustomAutoCycleScrollView *)autoScrollActivityView
{
    if (!_autoScrollActivityView) {
        _autoScrollActivityView = [FMCustomAutoCycleScrollView customScrollViewWithFrame:self.activityView.bounds placeholder:nil];
        _autoScrollActivityView.backgroundColor = [UIColor clearColor];
        
        @YRWeakObj(self);
        // cell 注册
        _autoScrollActivityView.cellRegisterAction = ^(UICollectionView *collectionView) {
            [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FMUserHeaderActivityCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([FMUserHeaderActivityCell class])];
        };
        
        // 配置cell
        _autoScrollActivityView.cellConfigure = ^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath *indexPath) {
            @YRStrongObj(self);
            FMUserHeaderActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FMUserHeaderActivityCell class]) forIndexPath:indexPath];
#warning lius 此处需要配置cell展示样式信息
            if (indexPath.row == 0) {
                cell.activityInfo = [self.info objectForKey:@"service_progress"];
            } else {
                cell.activityInfo = nil;
            }
            return cell;
        };
        
        // 配置点击事件
        _autoScrollActivityView.itemSelectedAction = ^(NSInteger currentIndex) {
            @YRStrongObj(self);
            [self didClickActivityAreaWithIndex:currentIndex];
        };
        // pagecontrol颜色
        _autoScrollActivityView.pageControlNormalColor = [UIColor lightGrayColor];
        _autoScrollActivityView.pageControlCurrentSelectColor = UIColorFromRGB(ThemeColor);
    }
    return _autoScrollActivityView;
}
```



#### CustomAdView

> 可以展示多个cell，无轮播，可以调整展示效果动画，如，中间大，两边小，支持不同cell设置；使用方式与上类似