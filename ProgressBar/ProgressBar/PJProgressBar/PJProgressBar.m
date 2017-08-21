//
//  PJProgressBar.m
//  ProgressBar
//
//  Created by Smile on 16/11/19.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import "PJProgressBar.h"
#import "ViewUtils.h"

@interface PJProgressBar ()

@property (nonatomic, strong) CALayer *maskLayer;

@end

@implementation PJProgressBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        
        [self setupProgressBar];
    }
    return self;
}

#pragma mark - Public Method
- (void)setProgressBarPercent:(CGFloat)percent {
    
    if (percent > 100.0f) {
        percent = 100.0f;
    }
    
    if (percent < 0.0f) {
        percent = 0.0f;
    }
    
    [_maskLayer setFrame:CGRectMake(0, 0, self.width * percent / 100.0f, self.height)];
}

#pragma mark - UI
- (void)setupProgressBar {
    
    CALayer *backgroundLayer = [CALayer layer];
    backgroundLayer.frame = self.bounds;
    backgroundLayer.backgroundColor = [UIColor grayColor].CGColor;
    backgroundLayer.masksToBounds = YES;
    backgroundLayer.cornerRadius = self.height / 2;
    [self.layer addSublayer:backgroundLayer];
    
    _maskLayer = [CALayer layer];
    _maskLayer.frame = CGRectMake(0, 0, 0, self.height);
    _maskLayer.cornerRadius = self.height / 2;
    _maskLayer.borderWidth = self.bounds.size.height / 2;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.masksToBounds = YES;
    gradientLayer.cornerRadius = self.height / 2;
    gradientLayer.colors = @[(id)[[self p_colorWithHex:0xFF6347] CGColor],
                             (id)[[self p_colorWithHex:0xFFEC8B] CGColor],
                             (id)[[self p_colorWithHex:0x98FB98] CGColor],
                             (id)[[self p_colorWithHex:0x00B2EE] CGColor],
                             (id)[[self p_colorWithHex:0x9400D3] CGColor]];
    gradientLayer.locations = @[@0.1, @0.3, @0.5, @0.7, @1];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.mask = _maskLayer;
    [self.layer addSublayer:gradientLayer];
}

#pragma mark - Private Method
- (UIColor *)p_colorWithHex:(long)hexColor {
    
    CGFloat red = ((CGFloat)((hexColor & 0xFF0000) >> 16)) / 255.0f;
    CGFloat green = ((CGFloat)((hexColor & 0xFF00) >> 8)) / 255.0f;
    CGFloat blue = ((CGFloat)(hexColor & 0xFF)) / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

@end
