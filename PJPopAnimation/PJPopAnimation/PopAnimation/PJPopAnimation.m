//
//  PJPopAnimation.m
//  AOF
//
//  Created by Lu Yiwei on 16/7/5.
//
//

#import "PJPopAnimation.h"

#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define IS_IOS_8 (SYSTEM_VERSION_GREATER_THAN(@"8.0"))

@interface PJPopAnimation ()

@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation PJPopAnimation

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    return 0.3;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];

    [toViewController updateViewConstraints];
    [toViewController.view layoutIfNeeded];
    
    UIView *containerView = [transitionContext containerView];
    UIView *toView = nil;
    if (IS_IOS_8) {
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        toView = toViewController.view;
    }
    
    [containerView insertSubview:toView belowSubview:fromViewController.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration animations:^{
        
        fromViewController.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
    }completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end

