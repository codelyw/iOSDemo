//
//  ViewController.m
//  PJToastTest
//
//  Created by Lu Yiwei on 2017/8/21.
//  Copyright © 2017年 Smile. All rights reserved.
//

#import "ViewController.h"
#import "PJShowTipsUtility.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 原作者 https://github.com/scalessec/Toast
}

- (IBAction)buttonDidClicked:(id)sender {
    
    
}

- (IBAction)buttonDidClicked2:(id)sender {
    
    [PJShowTipsUtility showToastWithMessage:[NSString stringWithFormat:@"%zd", arc4random() % 1000]];
    [PJShowTipsUtility showToastWithMessage:[NSString stringWithFormat:@"%zd", arc4random() % 1000] position:CSToastPositionTop];
}

@end
