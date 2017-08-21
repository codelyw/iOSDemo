//
//  PJHelpers.h
//  AOF
//
//  Created by ck8099 on 15/11/30.
//
//

#pragma once

#ifndef PJHelpers_h
#define PJHelpers_h

#define PJ_LOG_DEBUG_FUNCTION  DDLogDebug(@"__ %s __", __func__)

#define PJ_LANDSCAPE_ORIENTATION (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
#define PJ_PORTRAIT_ORIENTATION (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))

#define SCREEN_SCALE     ([[UIScreen mainScreen] scale])
#define SCREEN_BOUNDS    ([[UIScreen mainScreen] bounds])
#define SCREEN_WIDTH     ((PJ_LANDSCAPE_ORIENTATION && SYSTEM_VERSION_LESS_THAN(@"8.0")) ? SCREEN_BOUNDS.size.height : SCREEN_BOUNDS.size.width)
#define SCREEN_HEIGHT    ((PJ_LANDSCAPE_ORIENTATION && SYSTEM_VERSION_LESS_THAN(@"8.0")) ? SCREEN_BOUNDS.size.width : SCREEN_BOUNDS.size.height)


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_IOS_7 (SYSTEM_VERSION_GREATER_THAN(@"7.0"))
#define IS_IOS_8 (SYSTEM_VERSION_GREATER_THAN(@"8.0"))
// (SYSTEM_VERSION_GREATER_THAN(@"9.0"))
#define IS_IOS_9  0
#define IS_IOS_10 (SYSTEM_VERSION_GREATER_THAN(@"10.0"))

// Check current device.
#define IS_IPhone   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPad     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// Respond to selector.
#define DELEGATE_HAS_METHOD(delegate, sel) (delegate && [delegate respondsToSelector:sel])

// Safe release object.
#define SAFE_RELEASE(obj)       ({ if (obj) { obj = nil; } })
#define SAFE_RELEASE_VIEW(obj)  ({ if (obj) { [obj removeFromSuperview]; obj = nil; } })
#define SAFE_STOP_TIMER(timer)  ({ if (timer) { [timer invalidate]; timer = nil; } })

// Navigation.
#define PJ_NAVIGATION_CONTROLLER                            ([AppDelegate sharedAppdelegate].navController)
#define PJ_CREATE_VIEWCONTROLLER(vc, nib)                   ([[vc alloc] initWithNibName:nib bundle:nil])

#define PJ_PUSH_VIEWCONTROLLER(vc, animation)               ([PJ_NAVIGATION_CONTROLLER pushViewController:vc animated:animation])
#define PJ_POP_VIEWCONTROLLER(animation)                    ([PJ_NAVIGATION_CONTROLLER popViewControllerAnimated:animation])

#define PJ_PUSH_VIEWCONTROLLER_1(nav, vc, animation)        ([nav pushViewController:vc animated:animation])
#define PJ_POP_VIEWCONTROLLER_1(nav, animation)             ([nav popViewControllerAnimated:animation])

#define PJ_PRESENT_VIEWCONTROLLER(vc, animation, cmpltion)  ([PJ_NAVIGATION_CONTROLLER presentViewController:vc animated:animation completion:cmpltion])
#define PJ_DISMISS_VIEWCONTROLLER(animation, cmpltion)      ([PJ_NAVIGATION_CONTROLLER dismissViewControllerAnimated:animation completion:cmpltion])

#define PJ_PRESENT_VIEWCONTROLLER_1(nav, vc, animation, cmpltion)  ([nav presentViewController:vc animated:animation completion:cmpltion])
#define PJ_DISMISS_VIEWCONTROLLER_1(nav, animation, cmpltion)      ([nav dismissViewControllerAnimated:animation completion:cmpltion])

// Weak self.
#define __WS(weakSelf)              __weak __typeof(&*self)weakSelf = self;
#define PJ_WEAKSELF(weakSelf)       __WS(weakSelf)

// Strong self.
#define PJ_STRONGSELF(strongSelf, weakSelf)      __strong __typeof(weakSelf)strongSelf = weakSelf;

// Filter character set.
#define USER_NAME_CHARACTER @"0123456789abcdefghijklmnopqrstuvwxyzABCEDFGHIJKLMNOPQRSTUVWXYZ!\"'#$%&\\()*+-.,/:;<=>?@[]^_~{}`| \n"
#define USER_PASSWORD_CHARACTER @"0123456789abcdefghijklmnopqrstuvwxyzABCEDFGHIJKLMNOPQRSTUVWXYZ"
#define USER_SLIDESHOW_INTERVAL @"0123456789"
#define IP_CHARACTER @"0123456789."

#define LINE_FEED       @"\n"
#define CARRIAGE_RETURN @"\r\n"

// Spacing
#define PJ_SPACING_LEFT           15.0


// TitleBar Height
#define PJ_TITLE_BAR_HEIGHT             64.0
#define PJ_TAPBAR_HEIGHT                50.f
#define PJ_STATUS_BAR_HEIGHT            20.0
#define PJ_FORM_TITLE_BAR_HEIGHT        50.f

// Background Color
#define PJ_BACKGROUND_COLOR             [Utility getColorWith:@"#E4E8EC" corlorAlpha:1.0]
#define PJ_BACKGROUND_COLOR_HEADER      [Utility getColorWith:@"#EAECEF" corlorAlpha:1.0]
#define PJ_BACKGROUND_COLOR_CELL        [Utility getColorWith:@"#F6F8FA" corlorAlpha:1.0]

// Label Color
#define PJ_GRAYLABEL_COLOR_HEADER       [Utility getColorWith:@"#9A9A9A" corlorAlpha:1.0]
#define PJ_BLUELABEL_COLOR_CELL         [Utility getColorWith:@"#8EC6F2" corlorAlpha:1.0]
#define PJ_BLUELABEL_COLOR              [UIColor colorWithRed:124.0 / 255.0 green:193.0 / 255.0 blue:196.0 / 255.0 alpha:1.0]
#define PJ_GRAYLABEL_COLOR              [UIColor colorWithRed:192.0 / 255.0 green:193.0 / 255.0 blue:196.0 / 255.0 alpha:1.0]
#define PJ_GRAYLABEL_COLOR_FORM         [UIColor colorWithRed:107.0 / 255.0 green:109.0 / 255.0 blue:113.0 / 255.0 alpha:1.0]
#define PJ_GRAYLABEL_COLOR_SETUP        [UIColor colorWithRed:175.0 / 255.0 green:175.0 / 255.0 blue:176.0 / 255.0 alpha:1.0]

// Projector Select Color
#define PJ_SELECTED_COLOR           [UIColor colorWithRed:0.0 / 255.0 green:222.0 / 255.0 blue:255.0 / 255.0 alpha:1.0]

// Segment Control Color
#define PJ_SEGMENTCTRL_COLOR        [UIColor colorWithRed:124.0 / 255.0 green:193.0 / 255.0 blue:243.0 / 255.0 alpha:1.0]

// Switch Color
#define PJ_SWITCH_COLOR             [Utility getColorWith:@"#7CC0F1" corlorAlpha:1.0]

// Button Color
#define __BAR_BACKGROUND_COLOR      [UIColor colorWithRed:77.0 / 255.0 green:98.0 / 255.0 blue:129.0 / 255.0 alpha:1.0]
#define PJ_DELETEBUTTON_COLOR       __BAR_BACKGROUND_COLOR
#define PJ_BOTTOM_BAR_COLOR         __BAR_BACKGROUND_COLOR

// Divide line color.
#define PJ_DIVIDE_LINE_COLOR        [UIColor colorWithRed:213.0 / 255.0 green:217.0 / 255.0 blue:224.0 / 255.0 alpha:1.0]

// Excel sheet name color.
#define PJ_SHEET_NAME_COLOR         [UIColor colorWithRed:72.0 / 255.0 green:201.0 / 255.0 blue:192.0 / 255.0 alpha:1.0]

// Clear color.
#define PJ_CLEAR_COLOR              [UIColor clearColor]

// Image.
#define PJ_IMAGE(name)                          [UIImage imageNamed:name]
#define PJ_SET_IMAGE_NORMAL(obj, image)         [obj setImage:image forState:UIControlStateNormal]
#define PJ_SET_IMAGE_HIGHLIGHTED(obj, image)    [obj setImage:image forState:UIControlStateHighlighted]
#define PJ_SET_IMAGE_SELECTED(obj, image)       [obj setImage:image forState:UIControlStateSelected]

#define PJ_SET_BGIMAGE_NORMAL(obj, image)       [obj setBackgroundImage:image forState:UIControlStateNormal]
#define PJ_SET_BGIMAGE_HIGHLIGHTED(obj, image)  [obj setBackgroundImage:image forState:UIControlStateHighlighted]
#define PJ_SET_BGIMAGE_SELECTED(obj, image)     [obj setBackgroundImage:image forState:UIControlStateSelected]

// File name limit.
#define PJ_FOLDER_NAME_MAX_LENGTH               32
#define PJ_LIST_MAX_NUMBER                      32

// Empty string.
#define PJ_EMPTY_STRING                         @""

// TODO....
//
// Notification.
//#define PJ_ADD_NOTIFICATION(o, s, n, obj)   ([[NSNotificationCenter defaultCenter] addObserver:o selector:s name:n object:obj];)
//#define PJ_REMOVE_NOTIFICATION()
#define PJ_NOTIFICATION                         [NSNotificationCenter defaultCenter]

// Timers.
#define PJ_SCHEDULED_TIMER_SELF(interval, sel, userinfo, repeates) \
    ([NSTimer scheduledTimerWithTimeInterval:interval target:self selector:sel userInfo:userinfo repeats:repeates])

// Dispatch main.
#define dispatch_main_async_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }

#endif /* PJHelpers_h */

