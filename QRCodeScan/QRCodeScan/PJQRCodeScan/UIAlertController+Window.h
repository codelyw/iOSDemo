//
//  UIAlertController+Window.h
//  testWindow
//
//  Created by Lu Yiwei on 16/9/18.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIAlertController (Window)

- (void)show;
- (void)show:(BOOL)animated;

@end

@interface UIAlertController (Private)

@property (nonatomic, strong) UIWindow *alertWindow;

@end
