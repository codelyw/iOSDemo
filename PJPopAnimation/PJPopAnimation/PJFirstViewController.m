//
//  PJFirstViewController.m
//  PJPopAnimation
//
//  Created by Smile on 16/11/29.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import "PJFirstViewController.h"
#import "UIViewController+PJFullscreenPopGesture.h"
@interface PJFirstViewController ()

@end

@implementation PJFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pj_transitionFinishedBlock = ^{
        NSLog(@"Finished");
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
