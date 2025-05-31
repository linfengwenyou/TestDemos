//
//  RAYWebController.m
//  ImageBrowser
//
//  Created by fumi on 2019/5/10.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "RAYWebController.h"
#import <WebKit/WebKit.h>
#import "RAYMainViewController.h"

@interface RAYWebController ()<WKUIDelegate, WKNavigationDelegate>

/** 内容输入框 */
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic)  WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
/** 筛选项 */
@property (nonatomic, strong) UIButton *filterButton;

@end

@implementation RAYWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主页";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.filterButton];
    [self.mainView addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.webView.superview);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.webView.frame = self.mainView.bounds;
}

- (IBAction)didClickSearchAction:(id)sender {
    if (!self.textField.hasText) {
        [HudManager showHudWithText:@"请输入内容"];
        return;
    }
    NSString *url = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![url hasPrefix:@"http"]) {
        url = [@"https://" stringByAppendingString:url];
    }
    
    
    // 测试
//    url = @"https://image.baidu.com/search/acjson?tn=resultjson_com&ipn=rj&ct=201326592&is=&fp=result&queryWord=%E4%B8%96%E7%95%8C&cl=2&lm=-1&ie=utf-8&oe=utf-8&adpicid=&st=-1&z=&ic=0&hd=&latest=&copyright=&word=%E4%B8%96%E7%95%8C&s=&se=&tab=&width=&height=&face=0&istype=2&qc=&nc=1&fr=&expermode=&force=&pn=30&rn=30&gsm=300000000000000001e&1557388812213=";
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:url]];

    [self.webView loadRequest:request];
//    [self requestForWebUrl:url];
}


#pragma mark - life cycle

#pragma mark - private

#pragma mark - public

#pragma mark - network

#pragma mark - event
- (void)clickFilterAction:(UIButton *)sender {
    
    NSLog(@"%s",__FUNCTION__);
    /** 从webView中怎样获取到H5源码，很重要，尤其是涉及到有分页的情况 */
    [self.webView evaluateJavaScript:@"document.documentElement.outerHTML.toString()" completionHandler:^(NSString * html, NSError * _Nullable error) {
        if (![html isKindOfClass:[NSString class]] || html == nil) {
            return ;
        }
    
        // 配置
        RAYMainViewController *mainVC = [RAYMainViewController loadFromNib];
        mainVC.content = html;
        [self.navigationController pushViewController:mainVC animated:YES];
        NSLog(@"字符长度%ld",html.length);
        NSLog(@"---------------------");
    }];
    
}
#pragma mark - delegate

#pragma mark - setter

#pragma mark - getter
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (UIButton *)filterButton {
    if (!_filterButton) {
        _filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _filterButton.frame = CGRectMake(0, 0, 45, 45);
        [_filterButton setTitle:@"筛选图片" forState:UIControlStateNormal];
        _filterButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_filterButton setTitleColor:UIColorFromRGB(0x111111) forState:UIControlStateNormal];
        [_filterButton addTarget:self action:@selector(clickFilterAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterButton;
}

@end
