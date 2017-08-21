//
//  PJRootNavigationViewController.h
//  PJPopAnimation
//
//  Created by Smile on 16/11/29.
//  Copyright © 2016年 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PJNavigationInteractiveTransition.h"

@interface PJRootNavigationViewController : UINavigationController

@property (nonatomic, strong) PJNavigationInteractiveTransition *navTransition;

@end
