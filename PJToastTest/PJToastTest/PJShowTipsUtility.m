//
//  PJShowTipsUtility.m
//  AOF
//
//  Created by Chenkun on 14/12/2016.
//
//

#import "PJShowTipsUtility.h"

@interface PJShowTipsUtility () 

@end

@implementation PJShowTipsUtility

#pragma mark - Show toast.
+ (void)showToastWithMessage:(NSString *)message {
    
    [[self class] showToastWithMessage:message position:CSToastPositionBottom];
}

+ (void)showToastWithMessage:(NSString *)message duration:(NSTimeInterval)duration {
    
    [[self class] showToastWithMessage:message duration:duration position:CSToastPositionBottom];
}

+ (void)showToastWithMessage:(NSString *)message position:(NSString *)position {
    
    [[self class] showToastWithMessage:message duration:3.0f position:position];
}

+ (void)showToastWithMessage:(NSString *)message duration:(NSTimeInterval)duration position:(NSString *)position {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [CSToastManager setQueueEnabled:YES];
        
        UIWindow *topWindow = [UIApplication sharedApplication].windows.lastObject;
        
        [topWindow makeToast:message duration:duration position:position];
    });
}

+ (void)hideToastsImmediately:(BOOL)immediately {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *topWindow = [UIApplication sharedApplication].windows.lastObject;
        [topWindow hideToastsImmediately:immediately];
    });
}

@end
