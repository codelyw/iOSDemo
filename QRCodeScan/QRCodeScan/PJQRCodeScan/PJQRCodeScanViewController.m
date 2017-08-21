//
//  PJQRCodeScanViewController.m
//  QRCodeDemo
//
//  Created by Lu Yiwei on 16/9/27.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import "PJQRCodeScanViewController.h"
#import "PJQRCodeScanView.h"
#import "UIAlertController+Window.h"

static NSString * const kProjectorConnectInfo = @"[Info]";

#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define IS_IOS_8 (SYSTEM_VERSION_GREATER_THAN(@"8.0"))

@interface PJQRCodeScanViewController ()<PJQRCodeScanDelegate>

@property (nonatomic, strong) PJQRCodeScanView *scanView;

@end

@implementation PJQRCodeScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _scanView = [PJQRCodeScanView scannerWithPreviewView:self.view];
    _scanView.delegate = self;
    
    [self.view addSubview:_scanView];
}

#pragma mark - PJQRCodeScanDelegate    
- (void)cancel {

    [self.scanView removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didFinshedScanningQRCode:(NSString *)result {
    
    NSLog(@"QRCodeMessage:%@",result);
    if ([result hasPrefix:kProjectorConnectInfo]) {

        [self cancel];
    } else {
        [self p_showAlertViewControllerWithMessage:NSLocalizedString(@"Invalid QR Code!", nil)];
    }
}

#pragma mark - AlertViewController
- (void)p_showAlertViewControllerWithMessage:(NSString *)message {
    
    if (IS_IOS_8) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:nil
                                              message:NSLocalizedString(message, nil)
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"OK", nil)
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction * _Nonnull action) {
                                           [self.scanView reStartQRCodeScanView];
                                       }];
        
        [alertController addAction:cancelAction];
        [alertController show];
    } else {
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:nil
                                                        message:NSLocalizedString(message, nil)
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self.scanView reStartQRCodeScanView];
}

#pragma mark - Screen
- (BOOL)shouldAutorotate {
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationPortrait;
}

@end
