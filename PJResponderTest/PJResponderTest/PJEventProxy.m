//
//  PJEventProxy.m
//  PJResponderTest
//
//  Created by Lu Yiwei on 2017/8/7.
//  Copyright © 2017年 Smile. All rights reserved.
//

#import "PJEventProxy.h"

@interface PJEventProxy ()

@property (nonatomic, strong) NSDictionary <NSString *, NSInvocation *> *eventStrategy;

@end

@implementation PJEventProxy
#pragma mark - Public Method
- (void)handleEvent:(NSString *)eventName
           userInfo:(NSDictionary *)userInfo {
    
    NSInvocation *invocation = self.eventStrategy[eventName];
    [invocation setArgument:&userInfo atIndex:2];
    [invocation invoke];
}

#pragma mark - Event
- (void)testEvent:(NSDictionary *)userInfo {
    
    NSLog(@"%s", __func__);
}

#pragma mark - Private Method
- (NSInvocation *)p_createInvocationWithSelector:(SEL)selector {
    
    NSMethodSignature *signature = [PJEventProxy instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = selector;
    
    return invocation;
}

#pragma mark - Setter and Getter
- (NSDictionary <NSString *, NSInvocation *> *)eventStrategy {
    
    if (_eventStrategy == nil) {
        _eventStrategy = @{
                           kBLGoodsDetailTicketEvent : [self p_createInvocationWithSelector:@selector(testEvent:)],
                           };
    }
    return _eventStrategy;
}

@end
