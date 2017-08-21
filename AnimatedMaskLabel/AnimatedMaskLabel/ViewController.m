//
//  ViewController.m
//  AnimatedMaskLabel
//
//  Created by Smile on 16/11/19.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import "ViewController.h"
#import "PJAnimatedMaskLabel.h"

@interface ViewController ()

@property (nonatomic, strong) PJAnimatedMaskLabel *animatedMaskLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    _animatedMaskLabel = [[PJAnimatedMaskLabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    _animatedMaskLabel.center = self.view.center;
    [_animatedMaskLabel setText:@">滑动来解锁" withFontSize:20.0];
    [self.view addSubview:_animatedMaskLabel];
}

@end
