//
//  ViewController.m
//  EmptyDemo
//
//  Created by LIUSONG on 2017/8/12.
//  Copyright © 2017年 LIUSONG. All rights reserved.
//

#import "ViewController.h"
#import "SearchResultViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) SearchResultViewController *resultController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
     NSLog(@"%s",__func__);
    
    // 可以在此处用来退出控制器，需要注意导航栏的时机无论是展示还是隐藏
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"textLabel:%ld-%ld",indexPath.section, indexPath.row];
    return cell;
}

@end
