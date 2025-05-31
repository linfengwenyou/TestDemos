## UISearchController的基本使用

#### 注意几个环节

##### 1. 什么时候有导航栏，什么时候没有

搜索页，结果页，结果页跳转到的信息页

##### 2. 初始化配置，eg

```
  self.resultController = [[SearchResultViewController alloc] initWithNibName:NSStringFromClass([SearchResultViewController class]) bundle:nil];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.resultController];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:navigationController];
    
    self.searchController.searchResultsUpdater = self.resultController;
    self.searchController.delegate = self.resultController;
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    
    self.searchController.searchBar.delegate = self;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 44;

```



##### 3. 何时退出搜索控制器

```

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
     NSLog(@"%s",__func__);
    
    // 可以在此处用来退出控制器，需要注意导航栏的时机无论是展示还是隐藏
    
}
```



##### 4. result控制器操作，代理事件

```

- (void)willPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"%s",__func__);
    self.searchController = searchController;
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
     NSLog(@"%s",__func__);
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
     NSLog(@"%s",__func__);
}
- (void)didDismissSearchController:(UISearchController *)searchController
{
     NSLog(@"%s",__func__);
}

- (void)presentSearchController:(UISearchController *)searchController
{
     NSLog(@"%s",__func__);
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
     NSLog(@"%s",__func__);
}

```

##### 其他注意事项看代码





------

#### 其他

git 代码提交 '.' 不可以代表所有的提交，需要使用'*' ， 这就与svn命令提交比较相似了，这一点稍微注意下。