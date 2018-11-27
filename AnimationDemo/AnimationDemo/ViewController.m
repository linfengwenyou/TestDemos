//
//  ViewController.m
//  AnimationDemo
//
//  Created by fumi on 2018/11/1.
//  Copyright © 2018 fumi. All rights reserved.
//

#import "ViewController.h"
#import "AudioView.h"
#import "DemoCell.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *animationView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setUpUI];
    [self testAudioView];
    [self.tableview registerNib:[UINib nibWithNibName:@"DemoCell" bundle:nil] forCellReuseIdentifier:@"DemoCell"];
    
}

- (void)setUpUI
{
    
    UIView *animationView = [[UIView alloc] init];
    animationView.bounds = CGRectMake(0, 0, 200, 200);
    animationView.center = self.view.center;
    animationView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
//    [self.view addSubview:animationView];
    self.animationView = animationView;

}

- (void)testAudioView
{
    AudioView *audioView = [[AudioView alloc] initWithFrame:CGRectMake(20, 50, 20, 15) audioLineCount:0 color:[UIColor blueColor] lineOffset:1];
    audioView.backgroundColor = [UIColor yellowColor];
    [self.animationView addSubview:audioView];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DemoCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did selected index: %@",indexPath);
}



@end
