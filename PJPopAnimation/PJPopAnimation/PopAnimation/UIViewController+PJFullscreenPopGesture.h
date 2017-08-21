//
//  UIViewController+PJFullscreenPopGesture.h
//  AOF
//
//  Created by Lu Yiwei on 16/7/6.
//
//

#import <UIKit/UIKit.h>

/// Allows any view controller to disable interactive pop gesture, which might
/// be necessary when the view controller itself handles pan gesture in some
/// cases.

typedef void (^PJTransitionFinishedBlock)(void);

@interface UIViewController (PJFullscreenPopGesture)

/// Whether the interactive pop gesture is Enabled when contained in a navigation
/// stack.
@property (nonatomic, assign) BOOL pj_interactivePopDisabled;

@property (nonatomic, copy) PJTransitionFinishedBlock pj_transitionFinishedBlock;

@end
