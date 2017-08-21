//
//  PJQRCodeScanView.m
//  QRCodeDemo
//
//  Created by Lu Yiwei on 16/9/27.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import "PJQRCodeScanView.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"
#import "ViewUtils.h"

const NSTimeInterval kScanTime = 3.0;     // 扫描线从上到下扫描所历时间（s）

const CGFloat kScanViewDefaultSize = 200.f;
const CGFloat kCornerLineMargin = 0.7;
const CGFloat kCornerLineLength = 15.0;

const CGFloat kInfoLabelHeight = 20.f;
const CGFloat kButtonWidth = 80.f;
const CGFloat kButtonHeight = 30.f;
const CGFloat kCancelButtonLeftMargin = 10.f;
const CGFloat kScanLineHeight = 1.f;

#define IS_IPhone   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

@interface PJQRCodeScanView() <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) NSTimer *scanLineTimer;
@property (nonatomic, strong) UIView *scanLine;
@property (nonatomic, strong) UILabel *noticeInfoLable;
@property (nonatomic, strong) UIButton *lightButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, assign) CGRect screenRect;
@property (nonatomic, assign) CGRect scanRect;
@property (nonatomic, assign, getter = isOn) BOOL torchOn;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureDeviceInput * input;
@property (nonatomic, strong) AVCaptureMetadataOutput * output;
@property (nonatomic, strong) AVCaptureDevice * device;

@end

@implementation PJQRCodeScanView

+ (instancetype)scannerWithPreviewView:(UIView *)previewView {
    
    CGRect frameRect = previewView.bounds;
    if (previewView.height < previewView.width) {
        frameRect.size = CGSizeMake(previewView.height, previewView.width);
    }
    
    PJQRCodeScanView *scanView = [[PJQRCodeScanView alloc] initWithFrame:frameRect];
    [scanView initAVCaptureWithView:previewView];
    
    return scanView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _transparentAreaSize = CGSizeMake(kScanViewDefaultSize, kScanViewDefaultSize);
        _cornerLineColor = [UIColor greenColor];
        _scanningLieColor = [UIColor greenColor];
        _screenRect = frame;
    }
    
    return self;
}

#pragma mark - Public Method
- (void)reStartQRCodeScanView {
    
    [self.scanLineTimer setFireDate:[NSDate date]];
    [self.session startRunning];
}

#pragma mark - setter and getter
- (void)setTransparentAreaSize:(CGSize)transparentAreaSize {
    
    _transparentAreaSize = transparentAreaSize;
    [self p_refresh];
}

- (void)setScanningLieColor:(UIColor *)scanningLieColor {
    
    _scanningLieColor = scanningLieColor;
    [self p_refresh];
}

- (void)setCornerLineColor:(UIColor *)cornerLineColor {
    
    _cornerLineColor = cornerLineColor;
    [self p_refresh];
}

- (void)p_refresh {
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

#pragma mark - init AVCapture
- (void)initAVCaptureWithView:(UIView *)parentView {
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    _session = [[AVCaptureSession alloc] init];
    _session.sessionPreset = (_screenRect.size.height < 500) ? AVCaptureSessionPreset640x480 : AVCaptureSessionPresetHigh;
    
    if ([_session canAddInput:_input]) {
        [_session addInput:_input];
    }
    if ([_session canAddOutput:_output]) {
        [_session addOutput:_output];
    }
    
    _output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,
                                    AVMetadataObjectTypeEAN8Code,
                                    AVMetadataObjectTypeCode128Code,
                                    AVMetadataObjectTypeQRCode];

    CGSize screenSize = _screenRect.size;
    CGRect screenDrawRect = CGRectMake(0, 0, screenSize.width, screenSize.height);
    
    _scanRect = CGRectMake((screenDrawRect.size.width - _transparentAreaSize.width) / 2,
                           (screenDrawRect.size.height - _transparentAreaSize.height) / 2,
                           _transparentAreaSize.width,
                           _transparentAreaSize.height);
    
    _output.rectOfInterest = CGRectMake(_scanRect.origin.y / screenSize.height,
                                        _scanRect.origin.x / screenSize.width,
                                        _scanRect.size.height / screenSize.height,
                                        _scanRect.size.width / screenSize.width);
    
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_previewLayer setFrame:_screenRect];
    [parentView.layer insertSublayer:_previewLayer atIndex:0];
    
    [_session startRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection {
    
    if (metadataObjects.count > 0) {
        [self.scanLineTimer setFireDate:[NSDate distantFuture]];
        [self.session stopRunning];
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        if ([self.delegate respondsToSelector:@selector(didFinshedScanningQRCode:)]) {
            [self.delegate didFinshedScanningQRCode:[obj stringValue]];
        }
    }
}

#pragma mark - draw UI
- (void)drawRect:(CGRect)rect {

    [self p_updateLayout];
}

- (void)p_updateLayout{

    [self p_drawScanView];
    
    [self p_addScanLine];
    [self p_addNoticeInfoLable];
    if (IS_IPhone) {
        [self p_addLightButton];
    }
    [self p_addCancelButton];
    
    if (!_scanLineTimer) {
        self.scanLineTimer = [NSTimer
                              scheduledTimerWithTimeInterval:kScanTime
                              target:self
                              selector:@selector(p_moveUpAndDownLine)
                              userInfo:nil
                              repeats:YES];
        [_scanLineTimer fire];
    }
}

- (void)p_addNoticeInfoLable {
    
    _noticeInfoLable = [[UILabel alloc] initWithFrame:CGRectZero];
    
    [_noticeInfoLable setText:NSLocalizedString(@"将二维码/条码放入框内，即可自动扫描", @"")];
    [_noticeInfoLable setFont:[UIFont systemFontOfSize:15]];
    [_noticeInfoLable setTextColor:[UIColor whiteColor]];
    [_noticeInfoLable setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_noticeInfoLable];
    
    [_noticeInfoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.topMargin.mas_equalTo(_scanRect.origin.y + _scanRect.size.height + kInfoLabelHeight);
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(kInfoLabelHeight);
    }];
}

- (void)p_addLightButton {
    
    _lightButton = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [_lightButton setTitle:NSLocalizedString(@"打开照明", @"") forState:UIControlStateNormal];
    [_lightButton addTarget:self action:@selector(torchSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [_lightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_lightButton setTitleColor:[UIColor colorWithRed:0.0 / 255.0 green:222.0 / 255.0 blue:255.0 / 255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [self addSubview:_lightButton];
    
    _torchOn = NO;
    
    [_lightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_noticeInfoLable.mas_bottom).offset(kInfoLabelHeight);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(kButtonWidth);
        make.height.mas_equalTo(kButtonHeight);
    }];
}

- (void)p_addCancelButton {
    
    _cancelButton = [[UIButton alloc]initWithFrame:CGRectZero];
    
    [_cancelButton setTitle:NSLocalizedString(@"Cancel", @"") forState:UIControlStateNormal];
    [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [_cancelButton addTarget:self action:@selector(cancelButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor colorWithRed:0.0 / 255.0 green:222.0 / 255.0 blue:255.0 / 255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [self addSubview:_cancelButton];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).mas_offset(kCancelButtonLeftMargin);
        make.bottom.equalTo(self.mas_bottom).offset(-kButtonHeight);
        make.width.mas_equalTo(kButtonWidth);
        make.height.mas_equalTo(kButtonHeight);
    }];
}

- (void)p_addScanLine {
    
    CGRect lineRect = _scanRect;
    lineRect.size.height = kScanLineHeight;
    
    self.scanLine = [[UIView alloc] initWithFrame:lineRect];
    self.scanLine.backgroundColor = _scanningLieColor;
    [self addSubview:self.scanLine];
}

- (void)p_drawScanView {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 40 / 255.0, 40 / 255.0, 40 / 255.0, 0.5);
    
    // draw the transparent layer.
    CGContextFillRect(context, CGRectMake(0, 0, _screenRect.size.width, _screenRect.size.height));

    // clear the center rect  of the layer.
    CGContextClearRect(context, _scanRect);
    
    // add white rect.
    CGContextStrokeRect(context, _scanRect);
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
    CGContextSetLineWidth(context, 0.8);
    CGContextAddRect(context, _scanRect);
    CGContextStrokePath(context);
    
    // draw four corners.
    CGContextSetLineWidth(context, 2);
    
    // set stroke color.
    CGContextSetStrokeColorWithColor(context, [_cornerLineColor CGColor]);
    
    // left top corner.
    CGPoint poinsTopLeftA[] = {
        CGPointMake(_scanRect.origin.x + kCornerLineMargin,
                    _scanRect.origin.y),
        
        CGPointMake(_scanRect.origin.x + kCornerLineMargin ,
                    _scanRect.origin.y + kCornerLineLength)
    };
    
    CGPoint poinsTopLeftB[] = {
        CGPointMake(_scanRect.origin.x, _scanRect.origin.y + kCornerLineMargin),
        CGPointMake(_scanRect.origin.x + kCornerLineLength, _scanRect.origin.y + kCornerLineMargin)
    };
    
    [self p_addLine:poinsTopLeftA pointB:poinsTopLeftB context:context];
    
    // left bottom corner.
    CGPoint poinsBottomLeftA[] = {
        CGPointMake(_scanRect.origin.x + kCornerLineMargin,
                    _scanRect.origin.y + _scanRect.size.height - kCornerLineLength),
        
        CGPointMake(_scanRect.origin.x + kCornerLineMargin,
                    _scanRect.origin.y + _scanRect.size.height)
    };
    
    CGPoint poinsBottomLeftB[] = {
        CGPointMake(_scanRect.origin.x,
                    _scanRect.origin.y + _scanRect.size.height - kCornerLineMargin),
        
        CGPointMake(_scanRect.origin.x + kCornerLineMargin + kCornerLineLength,
                    _scanRect.origin.y + _scanRect.size.height - kCornerLineMargin)
    };
    
    [self p_addLine:poinsBottomLeftA pointB:poinsBottomLeftB context:context];
    
    // right top corner.
    CGPoint poinsTopRightA[] = {
        CGPointMake(_scanRect.origin.x + _scanRect.size.width - kCornerLineLength,
                    _scanRect.origin.y + kCornerLineMargin),
        
        CGPointMake(_scanRect.origin.x + _scanRect.size.width,
                    _scanRect.origin.y + kCornerLineMargin)
    };
    
    CGPoint poinsTopRightB[] = {
        CGPointMake(_scanRect.origin.x + _scanRect.size.width - kCornerLineMargin,
                    _scanRect.origin.y),
        
        CGPointMake(_scanRect.origin.x + _scanRect.size.width - kCornerLineMargin,
                    _scanRect.origin.y + kCornerLineLength + kCornerLineMargin)
    };
    
    [self p_addLine:poinsTopRightA pointB:poinsTopRightB context:context];
    
    // right bottom corner.
    CGPoint poinsBottomRightA[] = {
        CGPointMake(_scanRect.origin.x + _scanRect.size.width - kCornerLineMargin,
                    _scanRect.origin.y + _scanRect.size.height + -kCornerLineLength),
        
        CGPointMake(_scanRect.origin.x - kCornerLineMargin + _scanRect.size.width,
                    _scanRect.origin.y + _scanRect.size.height)
    };
    
    CGPoint poinsBottomRightB[] = {
        CGPointMake(_scanRect.origin.x + _scanRect.size.width - kCornerLineLength,
                    _scanRect.origin.y + _scanRect.size.height - kCornerLineMargin),
        
        CGPointMake(_scanRect.origin.x + _scanRect.size.width,
                    _scanRect.origin.y + _scanRect.size.height - kCornerLineMargin)
    };
    
    [self p_addLine:poinsBottomRightA pointB:poinsBottomRightB context:context];
    
    CGContextStrokePath(context);
}

- (void)p_addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB context:(CGContextRef)context {
    
    CGContextAddLines(context, pointA, 2);
    CGContextAddLines(context, pointB, 2);
}

#pragma mark - Timer
- (void)p_moveUpAndDownLine {
    
    self.scanLine.y = _scanRect.origin.y;
    
    [UIView animateWithDuration:kScanTime animations:^{
        self.scanLine.y += _scanRect.size.height;
    }];
}

#pragma mark - Action
- (void)torchSwitch:(id)sender {
    
    if (![self isOn]) {
        [_lightButton setTitle:NSLocalizedString(@"关闭照明", @"") forState:UIControlStateNormal];
        _torchOn = YES;
    } else {
        [_lightButton setTitle:NSLocalizedString(@"打开照明", @"") forState:UIControlStateNormal];
        _torchOn = NO;
    }
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    if (device.hasTorch) {
        if (![device lockForConfiguration:&error]) {
            if (error) {
                NSLog(@"lock torch configuration error:%@", error.localizedDescription);
            }
            return;
        }
        device.torchMode = (device.torchMode == AVCaptureTorchModeOff) ? AVCaptureTorchModeOn : AVCaptureTorchModeOff;
        [device unlockForConfiguration];
    }
}

- (void)cancelButtonDidClicked {
    
    if (_scanLineTimer) {
        [_scanLineTimer invalidate];
        _scanLineTimer = nil;
    }
    
    if ([self.delegate respondsToSelector:@selector(cancel)]) {
        [self.delegate cancel];
    }
}

- (void)dealloc {
    
    NSLog(@"__ %s __", __PRETTY_FUNCTION__);
}

@end
