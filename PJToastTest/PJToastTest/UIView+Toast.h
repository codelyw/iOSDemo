//
//  UIView+Toast.h
//  PJToastTest
//
//  Created by Lu Yiwei on 2017/8/21.
//  Copyright © 2017年 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * CSToastPositionTop;
extern NSString * CSToastPositionCenter;
extern NSString * CSToastPositionBottom;

@class CSToastStyle;

@interface UIView (Toast)

- (void)makeToast:(NSString *)message;

- (void)makeToast:(NSString *)message
         duration:(NSTimeInterval)duration
         position:(NSString *)position;

- (void)makeToast:(NSString *)message
         duration:(NSTimeInterval)duration
         position:(NSString *)position
            style:(CSToastStyle *)style;

- (void)makeToast:(NSString *)message
         duration:(NSTimeInterval)duration
         position:(NSString *)position
            title:(NSString *)title
            image:(UIImage *)image
            style:(CSToastStyle *)style
       completion:(void(^)(BOOL didTap))completion;

- (void)hideToastsImmediately:(BOOL)immediately;

@end

@interface CSToastStyle : NSObject

@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIColor *messageColor;
@property (assign, nonatomic) CGFloat maxWidthPercentage;
@property (assign, nonatomic) CGFloat maxHeightPercentage;
@property (assign, nonatomic) CGFloat horizontalPadding;
@property (assign, nonatomic) CGFloat verticalPadding;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIFont *messageFont;
@property (assign, nonatomic) NSTextAlignment titleAlignment;
@property (assign, nonatomic) NSTextAlignment messageAlignment;
@property (assign, nonatomic) NSInteger titleNumberOfLines;
@property (assign, nonatomic) NSInteger messageNumberOfLines;
@property (strong, nonatomic) UIColor *shadowColor;
@property (assign, nonatomic) CGFloat shadowOpacity;
@property (assign, nonatomic) CGFloat shadowRadius;
@property (assign, nonatomic) CGSize shadowOffset;
@property (assign, nonatomic) CGSize imageSize;
@property (assign, nonatomic) CGSize activitySize;
@property (assign, nonatomic) NSTimeInterval fadeDuration;

@property (assign, nonatomic) BOOL displayShadow;

- (instancetype)initWithDefaultStyle NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

@interface CSToastManager : NSObject

+ (void)setSharedStyle:(CSToastStyle *)sharedStyle;

+ (CSToastStyle *)sharedStyle;

+ (void)setTapToDismissEnabled:(BOOL)tapToDismissEnabled;

+ (BOOL)isTapToDismissEnabled;

+ (void)setQueueEnabled:(BOOL)queueEnabled;

+ (BOOL)isQueueEnabled;

+ (void)setDefaultDuration:(NSTimeInterval)duration;

+ (NSTimeInterval)defaultDuration;

+ (void)setDefaultPosition:(id)position;

+ (id)defaultPosition;

@end

typedef CGPoint(^PJToastViewUpdateCenterBlock)();

@interface PJToastView : UIView

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *message;
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, strong, readonly) CSToastStyle *style;

@property (nonatomic, copy) PJToastViewUpdateCenterBlock updateCenterBlock;

- (instancetype)initWithMessage:(NSString *)message
                          title:(NSString *)title
                          image:(UIImage *)image
                          style:(CSToastStyle *)style
                       position:(id)position
                      superSize:(CGSize)superSize;

- (void)updateMessage:(NSString *)message
                title:(NSString *)title
                image:(UIImage *)image;

@end
