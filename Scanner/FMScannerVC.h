//
//  ScannerVC.h
//  CodeScanner
//
//  Created by fumi on 2018/3/19.
//  Copyright © 2018年 wangyuxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, FMCodeScannerType) {
    FMCodeScannerTypeAll = 0,   //default, scan QRCode and barcode
    FMCodeScannerTypeQRCode,    //scan QRCode only
    FMCodeScannerTypeBarcode,   //scan barcode only
};
@interface FMScannerVC : UIViewController
@property (nonatomic, assign) FMCodeScannerType scanType;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *tipStr;

@property (nonatomic, copy) void(^scanResultBlock)(NSString *value);

@end
/*
 使用方式如下：
 FMScannerVC *scanner = [[FMScannerVC alloc] init];
 scanner.scanType = FMCodeScannerTypeBarcode;
 [self presentViewController:scanner animated:YES completion:nil];
 scanner.scanResultBlock = ^(NSString *value) {
    操作扫描到的信息
 };
 */
