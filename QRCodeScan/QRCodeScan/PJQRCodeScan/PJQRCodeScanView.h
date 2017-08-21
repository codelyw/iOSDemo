//
//  PJQRCodeScanView.h
//  QRCodeDemo
//
//  Created by Lu Yiwei on 16/9/27.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PJQRCodeScanDelegate <NSObject>

- (void)didFinshedScanningQRCode:(NSString *)result;
- (void)cancel;

@end

@interface PJQRCodeScanView : UIView

@property (nonatomic, strong) UIColor *scanningLieColor;
@property (nonatomic, strong) UIColor *cornerLineColor;
@property (nonatomic, assign) CGSize transparentAreaSize;
@property (nonatomic, weak) id<PJQRCodeScanDelegate>delegate;

+ (instancetype)scannerWithPreviewView:(UIView *)previewView;
- (void)reStartQRCodeScanView;

@end
