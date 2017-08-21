//
//  ViewController.m
//  ResponderTest
//
//  Created by Lu Yiwei on 2017/8/7.
//  Copyright © 2017年 Smile. All rights reserved.
//

#import "ViewController.h"
#import "ComplexView.h"
#import "PJEventProxy.h"

@interface ViewController ()

@property (nonatomic, strong) ComplexView *complexView;
@property (nonatomic, strong) PJEventProxy *eventProxy;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 原作者 https://casatwy.com/responder_chain_communication.html
    [self p_addSubviews];
    [self p_layoutSubviews];
}

#pragma mark - Event Response
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {

    [self.eventProxy handleEvent:eventName userInfo:userInfo];
}

#pragma mark - Prtivate Method
- (void)p_addSubviews {
    
    [self.view addSubview:self.complexView];
}

- (void)p_layoutSubviews {
    
    [self.complexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view);
        make.height.width.mas_equalTo(200);
    }];
}

#pragma mark - Setter and Getter
- (ComplexView *)complexView {
    
    if (!_complexView) {
        _complexView = [[ComplexView alloc] init];
    }
    return _complexView;
}

- (PJEventProxy *)eventProxy {
    
    if (!_eventProxy) {
        _eventProxy = [[PJEventProxy alloc] init];
    }
    return _eventProxy;
}

@end
