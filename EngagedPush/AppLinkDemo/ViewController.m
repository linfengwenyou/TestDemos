//
//  ViewController.m
//  AppLinkDemo
//
//  Created by Buck on 2025/7/15.
//

#import "ViewController.h"
#import "EngagePushManager.h"

@interface KeyValueObject : NSObject
// key
@property (nonatomic, copy) NSString *key;
// value
@property (nonatomic, copy) NSString *value;

@end

@implementation KeyValueObject

+ (instancetype)objectWithKey:(NSString *)key value:(NSString *)value {
    KeyValueObject *obj = [KeyValueObject new];
    obj.key = key;
    obj.value = value;
    return obj;
}

@end

@interface ViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


/// datas
@property(nonatomic, strong) NSArray *datas;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    EngagePushManager *manager = EngagePushManager.shareManager;
    manager.refreshAction = ^{
        [self updateData];
    };

    self.view.backgroundColor = UIColor.systemBackgroundColor;

    self.textView.text = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotifiction:) name:@"kEngagedPushNotification" object:nil];


    [self configTableview];
}

/// 接收到消息
- (void)didReceiveNotifiction:(NSNotification *)notification {
    self.textView.text = nil;


    NSLog(@"%@", notification.object);
    self.textView.text = notification.object;
}

#pragma mark - tableview
- (void)configTableview {

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier: NSStringFromClass(UITableViewCell.class)];

    [self updateData];

}

- (void)updateData {
    EngagePushManager *manager = EngagePushManager.shareManager;

    if(manager.appKey.length < 1) return;

    self.datas = @[
        [KeyValueObject objectWithKey:@"appKey" value:manager.appKey],
        [KeyValueObject objectWithKey:@"registrationId" value:manager.registrationID],
        [KeyValueObject objectWithKey:@"deviceToken" value:manager.deviceToken],
    ];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];

    UIColor *color = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:0.4];
    cell.backgroundColor = color;

    KeyValueObject *obj = self.datas[indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",
                           obj.key,
                           obj.value];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:UITableViewRowAnimationNone];

    KeyValueObject *obj = self.datas[indexPath.row];
    NSString *content = [NSString stringWithFormat:@"%@: %@",
     obj.key,
     obj.value];

    UIPasteboard.generalPasteboard.string = content;

    [self showEasyALertWithString:@"已复制"];
}


- (void)showEasyALertWithString:(NSString *)content {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:content
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];

    // 自动消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}
@end
