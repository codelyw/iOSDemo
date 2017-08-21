//
//  ViewController.m
//  ProgressBar
//
//  Created by Smile on 16/11/19.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import "ViewController.h"
#import "PJProgressBar.h"
#import "ViewUtils.h"

@interface ViewController ()

@property (nonatomic, strong) PJProgressBar *progressBar;
@property (nonatomic, strong) NSTimer *fireTimer;
@property (nonatomic, assign) CGFloat percent;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _progressBar = [[PJProgressBar alloc] initWithFrame:CGRectMake(10, 100, self.view.width - 20, 10)];
    [self.view addSubview:_progressBar];
    
}

- (IBAction)startButtonDidClicked:(id)sender {
    
    [self startFireTimer:YES];
    self.percent = 0.0f;
}

-(void)startFireTimer:(BOOL)bStart {
    
    if (self.fireTimer) {
        [self.fireTimer invalidate];
        self.fireTimer = nil;
    }
    if (bStart) {
        self.fireTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f
                                                          target:self
                                                        selector:@selector(updatePercent:)
                                                        userInfo:nil
                                                         repeats:YES];
    }
}

- (void)updatePercent:(NSTimer *)timer {
    
    if (self.percent++ > 100.0f) {
        [timer setFireDate:[NSDate distantFuture]];
        self.percent = 0.0f;
    } else {
        [_progressBar setProgressBarPercent:_percent];
    }
}

@end
