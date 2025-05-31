//
//  SearchResultViewController.m
//  EmptyDemo
//
//  Created by LIUSONG on 2017/8/20.
//  Copyright © 2017年 LIUSONG. All rights reserved.
//

#import "SearchResultViewController.h"

@interface SearchResultViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.searchController.searchBar.hidden = NO;
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    self.searchController.searchBar.hidden = YES;
//}

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

#pragma mark - tableView delegate & dataSource

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
    cell.textLabel.text = [NSString stringWithFormat:@"result:textLabel:%ld-%ld",indexPath.section, indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.searchController.searchBar.hidden = YES;
    
    UIViewController *tmpVc = [[UIViewController alloc] init];
    tmpVc.view.backgroundColor = [UIColor blueColor];
    [self.navigationController pushViewController:tmpVc animated:YES];
}

@end
