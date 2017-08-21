//
//  UIResponder+Router.m
//  ResponderTest
//
//  Created by Lu Yiwei on 2017/8/7.
//  Copyright © 2017年 Smile. All rights reserved.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}

@end
