//
//  PJNavigationInteractiveTransition.m
//  AOF
//
//  Created by Lu Yiwei on 16/7/5.
//
//

#import "PJNavigationInteractiveTransition.h"
#import "UIViewController+PJFullscreenPopGesture.h"
#import "PJPopAnimation.h"

@interface PJNavigationInteractiveTransition () <UINavigationControllerDelegate> {
    __weak UIViewController *_fromViewController;
}

@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;

@end

@implementation PJNavigationInteractiveTransition

- (instancetype)initWithViewController:(UINavigationController *)vc {
    
    self = [super init];
    if (self) {
        _navigationController = vc;
        _navigationController.delegate = self;
    }
    return self;
}

- (void)handleControllerPop:(UIGestureRecognizer *)gestureRecognizer {
    /**
     * 稳定进度区间，让它在0.0（未完成）～1.0（已完成）之间
     */
    CGFloat progress = 0.0;
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        progress = [recognizer translationInView:recognizer.view].x / recognizer.view.bounds.size.width;
        progress = MIN(1.0, MAX(0.0, progress));
    } else if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        UIPinchGestureRecognizer *recognizer = (UIPinchGestureRecognizer *)gestureRecognizer;
        if (recognizer.scale > 1.0) {
            progress = 0.0;
        } else {
            progress = 1.0 - recognizer.scale;
        }
    } else {
        return;
    }
    
    [self p_handleGestureRecognizer:gestureRecognizer Progress:progress];
}

- (void)p_handleGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer Progress:(CGFloat)progress {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        [self.interactivePopTransition updateInteractiveTransition:progress];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        if (progress > 0.5) {
            [self.interactivePopTransition finishInteractiveTransition];
            if (_fromViewController && _fromViewController.pj_transitionFinishedBlock) {
                _fromViewController.pj_transitionFinishedBlock();
            }
        } else {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        self.interactivePopTransition = nil;
    }
}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPop) {
        return [[PJPopAnimation alloc] init];
    }
    _fromViewController = fromVC;
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    if ([animationController isKindOfClass:[PJPopAnimation class]]) {
        return self.interactivePopTransition;
    }
    return nil;
}

@end

