//
//  PJEventProxy.h
//  PJResponderTest
//
//  Created by Lu Yiwei on 2017/8/7.
//  Copyright © 2017年 Smile. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PJEventProxyHandler)(BOOL success);

@interface PJEventProxy : NSObject

- (void)handleEvent:(NSString *)eventName
           userInfo:(NSDictionary *)userInfo;

@end
