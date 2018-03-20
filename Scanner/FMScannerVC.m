//
//  ScannerVC.m
//  CodeScanner
//
//  Created by fumi on 2018/3/19.
//  Copyright © 2018年 wangyuxiang. All rights reserved.
//

#import "FMScannerVC.h"
#import <AVFoundation/AVFoundation.h>
#import "ScannerView.h"

#define kScanViewWH 0.7 * [UIScreen mainScreen].bounds.size.width
#define kScanViewY 0.2 * [UIScreen mainScreen].bounds.size.height
@interface FMScannerVC ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, assign) BOOL isReading;

@property (nonatomic, assign) UIStatusBarStyle originStatusBarStyle;

@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation FMScannerVC


- (id)init {
    self = [super init];
    if (self) {
        self.scanType = FMCodeScannerTypeAll;
    }
    return self;
}

- (void)dealloc {
    _session = nil;
    NSLog(@"Scanner对象被销毁成功");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadCustomView];
    
    NSString *codeStr = @"";
    switch (_scanType) {
        case FMCodeScannerTypeAll: codeStr = @"二维码/条码"; break;
        case FMCodeScannerTypeQRCode: codeStr = @"二维码"; break;
        case FMCodeScannerTypeBarcode: codeStr = @"条码"; break;
        default: break;
    }
    
    //title
    if (self.titleStr && self.titleStr.length > 0) {
        self.titleLabel.text = self.titleStr;
    } else {
        self.titleLabel.text = codeStr;
    }
    
    //tip
    if (self.tipStr && self.tipStr.length > 0) {
        self.tipLabel.text = self.tipStr;
    } else {
        self.tipLabel.text= [NSString stringWithFormat:@"将%@放入框内，即可自动扫描", codeStr];
    }
    
    
    //判断权限
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (granted) {
                [self loadScanView];
                [self startRunning];
            } else {
                NSString *title = @"请在iPhone的”设置-app-相机“选项中，允许App访问你的相机";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
            }
            
        });
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.originStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil]; //监听是否重新进入程序程序.
    
    [self startRunning];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self moveUpAndDownLine];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:self.originStatusBarStyle animated:YES];
    [self stopRunning];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [self moveUpAndDownLine];
}

- (void)loadScanView {
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    self.session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [self.session addInput:input];
    [self.session addOutput:output];
    //设置扫码支持的编码格式
    switch (self.scanType) {
        case FMCodeScannerTypeAll:
            output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,
                                         AVMetadataObjectTypeEAN13Code,
                                         AVMetadataObjectTypeEAN8Code,
                                         AVMetadataObjectTypeUPCECode,
                                         AVMetadataObjectTypeCode39Code,
                                         AVMetadataObjectTypeCode39Mod43Code,
                                         AVMetadataObjectTypeCode93Code,
                                         AVMetadataObjectTypeCode128Code,
                                         AVMetadataObjectTypePDF417Code];
            break;
            
        case FMCodeScannerTypeQRCode:
            output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode];
            break;
            
        case FMCodeScannerTypeBarcode:
            output.metadataObjectTypes=@[AVMetadataObjectTypeEAN13Code,
                                         AVMetadataObjectTypeEAN8Code,
                                         AVMetadataObjectTypeUPCECode,
                                         AVMetadataObjectTypeCode39Code,
                                         AVMetadataObjectTypeCode39Mod43Code,
                                         AVMetadataObjectTypeCode93Code,
                                         AVMetadataObjectTypeCode128Code,
                                         AVMetadataObjectTypePDF417Code];
            break;
            
        default:
            break;
    }
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
}

- (void)loadCustomView {
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithFrame:self.view.bounds];
    blurView.effect = blur;
    [self.view addSubview:blurView];
    
    CGRect mainBounds = [[UIScreen mainScreen] bounds];
    CGFloat x = (mainBounds.size.width - kScanViewWH)/2.0f;
    
    //中间扫描区域
    ScannerView *scanCropView=[[ScannerView alloc] initWithFrame:CGRectMake(x,kScanViewY, kScanViewWH, kScanViewWH)];
    scanCropView.backgroundColor =[ UIColor clearColor];
    scanCropView.layer.borderColor = [UIColor whiteColor].CGColor;
    scanCropView.layer.borderWidth = 0.5f;
    
    // 从半透明背景中制造透明区域
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.view.frame];
    [path appendPath:[UIBezierPath bezierPathWithRect:scanCropView.frame].bezierPathByReversingPath];
    
    CAShapeLayer *shapLayer = [CAShapeLayer layer];
    shapLayer.path = path.CGPath;
    blurView.layer.mask = shapLayer;
    [self.view addSubview:scanCropView];
    
    //用于说明的label
    self.tipLabel= [[UILabel alloc] init];
    self.tipLabel.backgroundColor = [UIColor clearColor];
    self.tipLabel.frame=CGRectMake(x, CGRectGetMaxY(scanCropView.frame)+15, kScanViewWH, 40);
    self.tipLabel.numberOfLines=0;
    self.tipLabel.textColor=[UIColor whiteColor];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.tipLabel];
    
    //画中间的基准线
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake (x, kScanViewY, kScanViewWH, 5)];
    self.lineImageView.image = [UIImage imageNamed:@"scanner_line"];
    [self.view addSubview:self.lineImageView];
    
    //标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, kScanViewWH, 44)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    
    //返回
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"scanner_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(pressBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)startRunning {
    if (self.session) {
        _isReading = YES;
        [self.session startRunning];
    }
}

- (void)stopRunning {
    [self.session stopRunning];
}

- (void)pressBackButton {
    UINavigationController *nvc = self.navigationController;
    if (nvc) {
        if (nvc.viewControllers.count == 1) {
            [nvc dismissViewControllerAnimated:YES completion:nil];
        } else {
            [nvc popViewControllerAnimated:NO];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


//二维码的横线移动
- (void)moveUpAndDownLine {
    
    CGRect frame = self.lineImageView.frame;
    
    frame.origin.y = kScanViewY + kScanViewWH;
    
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.duration = 1.5f;
    anim.keyPath = @"position";
    anim.repeatCount = MAXFLOAT;
    anim.fromValue = [NSValue valueWithCGPoint:self.lineImageView.center];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.lineImageView.center.x, frame.origin.y)];
    [self.lineImageView.layer addAnimation:anim forKey:@""];
    
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (!_isReading) {
        return;
    }
    if (metadataObjects.count > 0) {
        _isReading = NO;
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0];
        NSString *result = metadataObject.stringValue;
        
        if (self.scanResultBlock) {
            self.scanResultBlock(result?:@"");
        }
        
        [self pressBackButton];
    }
}


@end
