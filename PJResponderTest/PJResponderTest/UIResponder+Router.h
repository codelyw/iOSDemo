//
//  UIResponder+Router.h
//  ResponderTest
//
//  Created by Lu Yiwei on 2017/8/7.
//  Copyright © 2017年 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (Router)

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;

@end
