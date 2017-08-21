//
//  ViewController.m
//  QRCodeScan
//
//  Created by Smile on 16/11/21.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import "ViewController.h"
#import "PJQRCodeScanViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buttonDidClicked:(id)sender {
    
    [self presentViewController:[[PJQRCodeScanViewController alloc] init] animated:YES completion:nil];
}


@end
