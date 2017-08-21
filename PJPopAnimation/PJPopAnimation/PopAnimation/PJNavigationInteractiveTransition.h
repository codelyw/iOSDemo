//
//  PJNavigationInteractiveTransition.h
//  AOF
//
//  Created by Lu Yiwei on 16/7/5.
//
//

#import <UIKit/UIKit.h>

@interface PJNavigationInteractiveTransition : NSObject

- (instancetype)initWithViewController:(UINavigationController *)vc;

- (void)handleControllerPop:(UIPanGestureRecognizer *)recognizer;

@end
