//
//  ComplexView.m
//  ResponderTest
//
//  Created by Lu Yiwei on 2017/8/7.
//  Copyright © 2017年 Smile. All rights reserved.
//

#import "ComplexView.h"
#import "UIResponder+Router.h"

@interface ComplexView ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation ComplexView

- (instancetype)init {
    
    if (self = [super init]) {
        [self p_addSubviews];
        [self p_layoutSubviews];
    }
    return self;
}

#pragma mark - Action
- (void)buttonDidClicked:(id)sender {
    
    [self routerEventWithName:kBLGoodsDetailTicketEvent userInfo:nil];
}

#pragma mark - Private Method
- (void)p_addSubviews {
    
    [self setBackgroundColor:[UIColor grayColor]];
    [self addSubview:self.button];
}

- (void)p_layoutSubviews {
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
    }];
}

#pragma mark - Setter and Getter
- (UIButton *)button {
    
    if (!_button) {
        _button = [[UIButton alloc] init];
        [_button setTitle:@"button" forState:UIControlStateNormal];
        [_button setTitle:@"button" forState:UIControlStateHighlighted];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [_button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _button;
}

@end
