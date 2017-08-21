//
//  PJAnimatedMaskLabel.m
//  AnimatedMaskLabel
//
//  Created by Smile on 16/11/19.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import "PJAnimatedMaskLabel.h"

@interface PJAnimatedMaskLabel ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation PJAnimatedMaskLabel

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setText:(NSString *)text withFontSize:(CGFloat)size {
    
    [self setNeedsDisplay];
    
    NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:size];
    
    textAttributes[NSParagraphStyleAttributeName] = style;
    textAttributes[NSFontAttributeName] = font;
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0);
    [text drawInRect:self.bounds withAttributes:textAttributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.backgroundColor = [UIColor clearColor].CGColor;
    maskLayer.frame = CGRectOffset(self.bounds, self.bounds.size.width, 0);
    maskLayer.contents = (id)(image.CGImage);
    _gradientLayer.mask = maskLayer;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    _gradientLayer.frame = CGRectMake(-self.bounds.size.width,
                                      self.bounds.origin.y,
                                      3 * self.bounds.size.width,
                                      self.bounds.size.height);
}

- (void)didMoveToWindow {
    
    [self.layer addSublayer:_gradientLayer];
    
    CABasicAnimation *gradientAnimation = [CABasicAnimation animationWithKeyPath:@"locations"];
    gradientAnimation.fromValue = @[@0.0, @0.0, @0.25];
    gradientAnimation.toValue = @[@0.75, @1.0, @1.0];
    gradientAnimation.duration = 3.0;
    gradientAnimation.repeatCount = CGFLOAT_MAX;
    [_gradientLayer addAnimation:gradientAnimation forKey:nil];
}

- (void)setupUI {
    
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.colors = @[(id)[UIColor blackColor].CGColor,
                              (id)[UIColor whiteColor].CGColor,
                              (id)[UIColor blackColor].CGColor];
    _gradientLayer.locations = @[@0.25, @0.5, @0.75];
    _gradientLayer.startPoint = CGPointMake(0.0, 0.5);
    _gradientLayer.endPoint = CGPointMake(1.0, 0.5);
}

@end
