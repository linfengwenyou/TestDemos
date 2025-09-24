//
//  ViewController.m
//  AppLinkDemo
//
//  Created by Buck on 2025/7/15.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

/// <#desc#>
@property(nonatomic, strong) UITableView *tableView;

/// <#desc#>
@property(nonatomic, strong) NSArray *datas;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
  
    self.datas = @[@"https://earnest-alpaca-0704f0.netlify.app/index.html",
                   @"applink://home",
                   @"applink://product",
                   @"applink-login://register",
                   @"https://www.bybit.com/en/task-center/mobile_guide/?__rfk=9zmy98",
                   @"https://www.bitget.com/zh-CN/events/rewards-pack?clacCode=3VP7A2LY",
                   @"https://earnest-alpaca-0704f0.netlify.app/testLbank.html",
                   @"lbank://lbk.app/web?url=https://www.lbk.world/%25language_code%25/activity/qqqqqq7?origin=popular",
                   @"https://www.lbk.world/zh-TC/js-bridge",
                   @"https://www.lbank.com/zh-TC/activity/2046-weekly-new-futures?themeMode=night",
                   @"https://www.lbank.com/zh-TC/activity/AAA0912",
                   @"https://jid.lbk.world/media/customer/userAppeal/8afb79de-0ba4-4aff-8675-1a182d06d340.mp4",
                   @"https://www.lbk.world/zh-TC/support/bridge"
    ];
    
    [self.view addSubview:self.tableView];
    
}


- (void)updateViewConstraints {
    
}
#pragma mark - UITableViewDelegate & UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    cell.textLabel.text = self.datas[indexPath.row];
    
    
    UIColor *color = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
    cell.backgroundColor = color;
    return cell;
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    [UIPasteboard generalPasteboard].string = self.datas[indexPath.row];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:UIScreen.mainScreen.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        
        _tableView.estimatedRowHeight = 111; // 预估高度
        _tableView.estimatedSectionHeaderHeight = 44;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}


@end
