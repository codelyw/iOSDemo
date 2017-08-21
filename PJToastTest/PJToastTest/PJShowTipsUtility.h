//
//  PJShowTipsUtility.h
//  AOF
//
//  Created by Chenkun on 14/12/2016.
//
//

#import <Foundation/Foundation.h>
#import "UIView+Toast.h"

typedef void(^PJAlertHandler)();

@interface PJShowTipsUtility : NSObject

// Toast.
+ (void)showToastWithMessage:(NSString *)message;
+ (void)showToastWithMessage:(NSString *)message duration:(NSTimeInterval)duration;
+ (void)showToastWithMessage:(NSString *)message position:(NSString *)position;
+ (void)showToastWithMessage:(NSString *)message duration:(NSTimeInterval)duration position:(NSString *)position;
+ (void)hideToastsImmediately:(BOOL)immediately;

@end
