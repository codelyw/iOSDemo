//
//  UIView+Toast.m
//  PJToastTest
//
//  Created by Lu Yiwei on 2017/8/21.
//  Copyright © 2017年 Smile. All rights reserved.
//

#import "UIView+Toast.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

NSString * CSToastPositionTop       = @"CSToastPositionTop";
NSString * CSToastPositionCenter    = @"CSToastPositionCenter";
NSString * CSToastPositionBottom    = @"CSToastPositionBottom";

// Keys for values associated with toast views
static const NSString * CSToastTimerKey             = @"CSToastTimerKey";
static const NSString * CSToastDurationKey          = @"CSToastDurationKey";
static const NSString * CSToastPositionKey          = @"CSToastPositionKey";
static const NSString * CSToastCompletionKey        = @"CSToastCompletionKey";

// Keys for values associated with self
static const NSString * CSToastActiveKey            = @"CSToastActiveKey";
static const NSString * CSToastActivityViewKey      = @"CSToastActivityViewKey";
static const NSString * CSToastQueueKey             = @"CSToastQueueKey";

@implementation UIView (Toast)
#pragma mark - Make Toast Methods
- (void)makeToast:(NSString *)message {
    
    [self makeToast:message duration:[CSToastManager defaultDuration] position:[CSToastManager defaultPosition] style:nil];
}

- (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(NSString *)position {
    
    [self makeToast:message duration:duration position:position style:nil];
}

- (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(NSString *)position style:(CSToastStyle *)style {
    
    [self makeToast:message duration:duration position:position title:nil image:nil style:style completion:nil];
}

- (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(NSString *)position title:(NSString *)title image:(UIImage *)image style:(CSToastStyle *)style completion:(void(^)(BOOL didTap))completion {
    
    PJToastView *toast = [self cs_toastViewForMessage:message title:title image:image style:style position:position];
    
    objc_setAssociatedObject(toast, &CSToastCompletionKey, completion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(toast, &CSToastDurationKey, @(duration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(toast, &CSToastPositionKey, position, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self showToast:toast];
}

#pragma mark - Show Toast Methods
- (void)showToast:(PJToastView *)toast {
    
    if (!toast) {
        return;
    }
    
    NSString *position = objc_getAssociatedObject(toast, &CSToastPositionKey);
    
    if ([CSToastManager isQueueEnabled] && [self cs_getCurrentToastWithPosition:position]) {
        [self.cs_toastQueue addObject:toast];
    } else {
        PJToastView *currentToast = [self cs_getCurrentToastWithPosition:position];
        NSTimeInterval duration = [objc_getAssociatedObject(toast, &CSToastDurationKey) doubleValue];
        
        if (currentToast) {
            [self cs_updateCurrentToast:currentToast withNextToast:toast];
        } else {
            [self cs_showToast:toast duration:duration position:position];
        }
    }
}

#pragma mark - Hide Toast Method
- (void)hideToastsImmediately:(BOOL)immediately {
    
    for (PJToastView *toast in [self cs_activeToasts]) {
        if (immediately) {
            [toast setHidden:YES];
        }
        
        [self hideToast:toast];
    }
}

- (void)hideToast:(PJToastView *)toast {
    
    if (!toast || ![[self cs_activeToasts] containsObject:toast]) return;
    
    NSTimer *timer = (NSTimer *)objc_getAssociatedObject(toast, &CSToastTimerKey);
    [timer invalidate];
    
    [self cs_hideToast:toast];
}

#pragma mark - Events
- (void)cs_toastTimerDidFinish:(NSTimer *)timer {
    
    [self cs_hideToast:(PJToastView *)(timer.userInfo)];
}

- (void)cs_handleToastTapped:(UITapGestureRecognizer *)recognizer {
    
    PJToastView *toast = (PJToastView *)recognizer.view;
    NSTimer *timer = (NSTimer *)objc_getAssociatedObject(toast, &CSToastTimerKey);
    [timer invalidate];
    
    [self cs_hideToast:toast fromTap:YES];
}

/*
#pragma mark - Activity Methods
- (void)makeToastActivity:(NSString *)position {
    // sanity
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &CSToastActivityViewKey);
    if (existingActivityView != nil) return;
    
    CSToastStyle *style = [CSToastManager sharedStyle];
    
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, style.activitySize.width, style.activitySize.height)];
    activityView.center = [self cs_centerPointForPosition:position withToast:activityView];
    activityView.backgroundColor = style.backgroundColor;
    activityView.alpha = 0.0;
    activityView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    activityView.layer.cornerRadius = style.cornerRadius;
    
    if (style.displayShadow) {
        activityView.layer.shadowColor = style.shadowColor.CGColor;
        activityView.layer.shadowOpacity = style.shadowOpacity;
        activityView.layer.shadowRadius = style.shadowRadius;
        activityView.layer.shadowOffset = style.shadowOffset;
    }
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = CGPointMake(activityView.bounds.size.width / 2, activityView.bounds.size.height / 2);
    [activityView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    // associate the activity view with self
    objc_setAssociatedObject (self, &CSToastActivityViewKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addSubview:activityView];
    
    [UIView animateWithDuration:style.fadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         activityView.alpha = 1.0;
                     } completion:nil];
}

- (void)hideToastActivity {
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &CSToastActivityViewKey);
    if (existingActivityView != nil) {
        [UIView animateWithDuration:[[CSToastManager sharedStyle] fadeDuration]
                              delay:0.0
                            options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             existingActivityView.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             [existingActivityView removeFromSuperview];
                             objc_setAssociatedObject (self, &CSToastActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         }];
    }
}
*/
#pragma mark - Private Method
#pragma mark Toast Construction
- (PJToastView *)cs_toastViewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image style:(CSToastStyle *)style position:(NSString *)position {
    
    if(message == nil && title == nil && image == nil) return nil;
    
    style = style ? : [CSToastManager sharedStyle];
    
    PJ_WEAKSELF(ws);
    PJToastView *wrapperView = [[PJToastView alloc] initWithMessage:message title:title image:image style:style position:position superSize:self.bounds.size];
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = style.cornerRadius;
    wrapperView.updateCenterBlock = ^CGPoint{
        return [ws cs_centerPointForPosition:position withToast:(PJToastView *)[[ws cs_activeToasts] lastObject]];
    };
    
    if (style.displayShadow) {
        wrapperView.layer.shadowColor = style.shadowColor.CGColor;
        wrapperView.layer.shadowOpacity = style.shadowOpacity;
        wrapperView.layer.shadowRadius = style.shadowRadius;
        wrapperView.layer.shadowOffset = style.shadowOffset;
    }
    
    wrapperView.backgroundColor = style.backgroundColor;
    
    return wrapperView;
}

#pragma mark Toast Center Point
- (CGPoint)cs_centerPointForPosition:(NSString *)position withToast:(PJToastView *)toast {
    
    CSToastStyle *style = [CSToastManager sharedStyle];
    
    if ([position isEqualToString:CSToastPositionTop]) {
        return CGPointMake(self.frame.size.width / 2, 60 + style.verticalPadding);
    } else if([position isEqualToString:CSToastPositionCenter]) {
        return CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    }
    
    return CGPointMake(self.frame.size.width / 2, self.frame.size.height - 60);
}

#pragma mark Update Toast
- (void)cs_updateCurrentToast:(PJToastView *)currentToast withNextToast:(PJToastView *)nextToast {
    
    NSTimeInterval duration = [objc_getAssociatedObject(nextToast, &CSToastDurationKey) doubleValue];
    NSString *position = objc_getAssociatedObject(currentToast, &CSToastPositionKey);
    
    [currentToast updateMessage:nextToast.message title:nextToast.title image:nextToast.image];
    currentToast.center = [self cs_centerPointForPosition:position withToast:currentToast];
    
    NSTimer *timer = (NSTimer *)objc_getAssociatedObject(currentToast, &CSToastTimerKey);
    [timer invalidate];
    
    NSTimer *newTimer = [NSTimer timerWithTimeInterval:duration target:self selector:@selector(cs_toastTimerDidFinish:) userInfo:currentToast repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:newTimer forMode:NSRunLoopCommonModes];
    objc_setAssociatedObject(currentToast, &CSToastTimerKey, newTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (PJToastView *)cs_getCurrentToastWithPosition:(NSString *)position {
    
    PJToastView *currentToast = nil;
    
    for (PJToastView *toast in [self cs_activeToasts]) {
        if ([objc_getAssociatedObject(toast, &CSToastPositionKey) isEqualToString:position]) {
            currentToast = toast;
            break;
        }
    }
    
    return currentToast;
}

#pragma mark Show/Hide Toast
- (void)cs_showToast:(PJToastView *)toast duration:(NSTimeInterval)duration position:(NSString *)position {
    
    toast.alpha = 0.0;
    
    if ([CSToastManager isTapToDismissEnabled]) {
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cs_handleToastTapped:)];
        [toast addGestureRecognizer:recognizer];
        toast.userInteractionEnabled = YES;
        toast.exclusiveTouch = YES;
    }
    
    [[self cs_activeToasts] addObject:toast];
    
    toast.center = [self cs_centerPointForPosition:position withToast:toast];
    [self addSubview:toast];
    
    [UIView animateWithDuration:[[CSToastManager sharedStyle] fadeDuration]
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         NSTimer *timer = [NSTimer timerWithTimeInterval:duration target:self selector:@selector(cs_toastTimerDidFinish:) userInfo:toast repeats:NO];
                         [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                         objc_setAssociatedObject(toast, &CSToastTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];
}

- (void)cs_hideToast:(PJToastView *)toast {
    
    [self cs_hideToast:toast fromTap:NO];
}

- (void)cs_hideToast:(PJToastView *)toast fromTap:(BOOL)fromTap {
    
    NSString *position = objc_getAssociatedObject(toast, &CSToastPositionKey);
    PJToastView *updateToast = [self cs_getUpdateToastWithPosition:position];
    
    if (updateToast) {
        
        void (^completion)(BOOL didTap) = objc_getAssociatedObject(toast, &CSToastCompletionKey);
        if (completion) {
            completion(fromTap);
        }
        
        [[self cs_toastQueue] removeObject:updateToast];
        
        [self cs_updateCurrentToast:toast withNextToast:updateToast];
    } else {
        [UIView animateWithDuration:[[CSToastManager sharedStyle] fadeDuration]
                              delay:0.0
                            options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             toast.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             
                             [[self cs_activeToasts] removeObject:toast];
                             
                             [toast removeFromSuperview];
                             
                             // execute the completion block, if necessary
                             void (^completion)(BOOL didTap) = objc_getAssociatedObject(toast, &CSToastCompletionKey);
                             if (completion) {
                                 completion(fromTap);
                             }
                         }];
    }
}

- (PJToastView *)cs_getUpdateToastWithPosition:(NSString *)position {
    
    if (0 == [[self cs_toastQueue] count]) {
        return nil;
    }
    
    PJToastView *updateToast = nil;

    for (PJToastView *toast in [self cs_toastQueue]) {
        if ([objc_getAssociatedObject(toast, &CSToastPositionKey) isEqualToString:position]) {
            updateToast = toast;
            break;
        }
    }
    
    return updateToast;
}

#pragma mark - Storage
- (NSMutableArray *)cs_activeToasts {
    
    NSMutableArray *cs_activeToasts = objc_getAssociatedObject(self, &CSToastActiveKey);
    if (cs_activeToasts == nil) {
        cs_activeToasts = [[NSMutableArray alloc] init];
        objc_setAssociatedObject(self, &CSToastActiveKey, cs_activeToasts, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cs_activeToasts;
}

- (NSMutableArray *)cs_toastQueue {
    
    NSMutableArray *cs_toastQueue = objc_getAssociatedObject(self, &CSToastQueueKey);
    if (cs_toastQueue == nil) {
        cs_toastQueue = [[NSMutableArray alloc] init];
        objc_setAssociatedObject(self, &CSToastQueueKey, cs_toastQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cs_toastQueue;
}

@end

#pragma mark - CSToastStyle
@implementation CSToastStyle

- (instancetype)initWithDefaultStyle {

    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:80.0 / 255.0 green:80.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
        self.titleColor = [UIColor whiteColor];
        self.messageColor = [UIColor whiteColor];
        self.maxWidthPercentage = 0.8;
        self.maxHeightPercentage = 0.8;
        self.horizontalPadding = 10.0;
        self.verticalPadding = 10.0;
        self.cornerRadius = 10.0;
        self.titleFont = [UIFont boldSystemFontOfSize:16.0];
        self.messageFont = [UIFont systemFontOfSize:16.0];
        self.titleAlignment = NSTextAlignmentCenter;
        self.messageAlignment = NSTextAlignmentCenter;
        self.titleNumberOfLines = 0;
        self.messageNumberOfLines = 0;
        self.shadowOpacity = 0.8;
        self.shadowRadius = 6.0;
        self.shadowOffset = CGSizeMake(4.0, 4.0);
        self.imageSize = CGSizeMake(80.0, 80.0);
        self.activitySize = CGSizeMake(100.0, 100.0);
        self.fadeDuration = 0.2;
        self.displayShadow = NO;
    }
    
    return self;
}

- (void)setMaxWidthPercentage:(CGFloat)maxWidthPercentage {
    
    _maxWidthPercentage = MAX(MIN(maxWidthPercentage, 1.0), 0.0);
}

- (void)setMaxHeightPercentage:(CGFloat)maxHeightPercentage {
    
    _maxHeightPercentage = MAX(MIN(maxHeightPercentage, 1.0), 0.0);
}

- (instancetype)init NS_UNAVAILABLE {
    
    return nil;
}

@end

#pragma mark - CSToastManager
@interface CSToastManager ()

@property (strong, nonatomic) CSToastStyle *sharedStyle;
@property (assign, nonatomic, getter=isTapToDismissEnabled) BOOL tapToDismissEnabled;
@property (assign, nonatomic, getter=isQueueEnabled) BOOL queueEnabled;
@property (assign, nonatomic) NSTimeInterval defaultDuration;
@property (strong, nonatomic) NSString *defaultPosition;

@end

@implementation CSToastManager

#pragma mark - Constructors

+ (instancetype)sharedManager {
    
    static CSToastManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.sharedStyle = [[CSToastStyle alloc] initWithDefaultStyle];
        self.tapToDismissEnabled = YES;
        self.queueEnabled = NO;
        self.defaultDuration = 3.0;
        self.defaultPosition = CSToastPositionBottom;
    }
    return self;
}

#pragma mark - Singleton Methods
+ (void)setSharedStyle:(CSToastStyle *)sharedStyle {
    
    [[self sharedManager] setSharedStyle:sharedStyle];
}

+ (CSToastStyle *)sharedStyle {
    
    return [[self sharedManager] sharedStyle];
}

+ (void)setTapToDismissEnabled:(BOOL)tapToDismissEnabled {
    
    [[self sharedManager] setTapToDismissEnabled:tapToDismissEnabled];
}

+ (BOOL)isTapToDismissEnabled {
    
    return [[self sharedManager] isTapToDismissEnabled];
}

+ (void)setQueueEnabled:(BOOL)queueEnabled {
    
    [[self sharedManager] setQueueEnabled:queueEnabled];
}

+ (BOOL)isQueueEnabled {
    
    return [[self sharedManager] isQueueEnabled];
}

+ (void)setDefaultDuration:(NSTimeInterval)duration {
    
    [[self sharedManager] setDefaultDuration:duration];
}

+ (NSTimeInterval)defaultDuration {
    
    return [[self sharedManager] defaultDuration];
}

+ (void)setDefaultPosition:(NSString *)position {
    
    if ([position isKindOfClass:[NSString class]] || [position isKindOfClass:[NSValue class]]) {
        [[self sharedManager] setDefaultPosition:position];
    }
}

+ (id)defaultPosition {
    
    return [[self sharedManager] defaultPosition];
}

@end

#pragma mark - PJToastView
@interface PJToastView ()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *message;
@property (nonatomic, strong, readwrite) UIImage *image;
@property (nonatomic, strong, readwrite) CSToastStyle *style;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) id position;
@property (nonatomic, assign) CGSize superSize;

@end

@implementation PJToastView
#pragma mark - Life Cycle
- (instancetype)initWithMessage:(NSString *)message
                          title:(NSString *)title
                          image:(UIImage *)image
                          style:(CSToastStyle *)style
                       position:(NSString *)position
                      superSize:(CGSize)superSize {
    
    if (self = [super init]) {
        
        self.message = message;
        self.title = title;
        self.image = image;
        self.style = style;
        self.position = position;
        self.superSize = superSize;
        
        [self p_addSubviews];
        [self p_layoutSubviews];
        [self p_addObserver];
    }
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public Method
- (void)updateMessage:(NSString *)message
                title:(NSString *)title
                image:(UIImage *)image {
    
    self.transform = CGAffineTransformIdentity;

    if (![message isEqualToString:self.message]) {
        self.message = message;
        [self.messageLabel setText:message];
    }
    
    if (![title isEqualToString:self.title]) {
        self.title = title;
        [self.titleLabel setText:title];
    }
    
    if (image != self.image) {
        self.image = image;
        [self.imageView setImage:image];
    }
    
    [self p_layoutSubviews];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    
    [UIView animateWithDuration:0.3 animations:^{
        if (self.updateCenterBlock) {
            self.center = self.updateCenterBlock();
        }
    }];
}

#pragma mark - Private Method
- (void)p_addSubviews {
    
    if (self.image) {
        [self addSubview:self.imageView];
    }
    
    if (self.title) {
        [self addSubview:self.titleLabel];
    }
    
    if (self.message) {
        [self addSubview:self.messageLabel];
    }
}

- (void)p_layoutSubviews {
    
    CGRect titleRect = CGRectZero;
    CGRect imageRect = CGRectZero;
    CGRect messageRect = CGRectZero;
    
    CGFloat maxWidthPercentage = [self.style maxWidthPercentage];
    CGFloat maxHeightPercentage = [self.style maxHeightPercentage];
    CGFloat horizontalPadding = [self.style horizontalPadding];
    CGFloat verticalPadding = [self.style verticalPadding];
    
    if (self.image) {
        self.imageView.frame = CGRectMake(horizontalPadding,
                                          verticalPadding,
                                          self.style.imageSize.width,
                                          self.style.imageSize.height);
        
        imageRect.origin.x = horizontalPadding;
        imageRect.origin.y = verticalPadding;
        imageRect.size.width = self.imageView.bounds.size.width;
        imageRect.size.height = self.imageView.bounds.size.height;
    }
    
    if (self.title) {
        // size the title label according to the length of the text
        CGSize maxSizeTitle = CGSizeMake((SCREEN_WIDTH * maxWidthPercentage) - imageRect.size.width,
                                         SCREEN_HEIGHT * maxHeightPercentage);
        CGSize expectedSizeTitle = [self.titleLabel sizeThatFits:maxSizeTitle];
        // UILabel can return a size larger than the max size when the number of lines is 1
        expectedSizeTitle = CGSizeMake(MIN(maxSizeTitle.width, expectedSizeTitle.width),
                                       MIN(maxSizeTitle.height, expectedSizeTitle.height));
        self.titleLabel.frame = CGRectMake(0.0,
                                           0.0,
                                           expectedSizeTitle.width,
                                           expectedSizeTitle.height);
        
        titleRect.origin.x = imageRect.origin.x + imageRect.size.width + horizontalPadding;
        titleRect.origin.y = verticalPadding;
        titleRect.size.width = self.titleLabel.bounds.size.width;
        titleRect.size.height = self.titleLabel.bounds.size.height;
        
        self.titleLabel.frame = titleRect;
    }
    
    if (self.message) {
        CGSize maxSizeMessage = CGSizeMake((SCREEN_WIDTH * maxWidthPercentage) - imageRect.size.width,
                                           SCREEN_HEIGHT * maxHeightPercentage);
        CGSize expectedSizeMessage = [self.messageLabel sizeThatFits:maxSizeMessage];
        // UILabel can return a size larger than the max size when the number of lines is 1
        expectedSizeMessage = CGSizeMake(MIN(maxSizeMessage.width, expectedSizeMessage.width),
                                         MIN(maxSizeMessage.height, expectedSizeMessage.height));
        
        self.messageLabel.frame = CGRectMake(0.0,
                                             0.0,
                                             expectedSizeMessage.width,
                                             expectedSizeMessage.height);
        
        messageRect.origin.x = imageRect.origin.x + imageRect.size.width + horizontalPadding;
        messageRect.origin.y = titleRect.origin.y + titleRect.size.height + verticalPadding;
        messageRect.size.width = self.messageLabel.bounds.size.width;
        messageRect.size.height = self.messageLabel.bounds.size.height;
        
        self.messageLabel.frame = messageRect;
    }
    
    CGFloat longerWidth = MAX(titleRect.size.width, messageRect.size.width);
    CGFloat longerX = MAX(titleRect.origin.x, messageRect.origin.x);
    
    CGFloat wrapperWidth = MAX((imageRect.size.width + (horizontalPadding * 2.0)),
                               (longerX + longerWidth + horizontalPadding));
    CGFloat wrapperHeight = MAX((messageRect.origin.y + messageRect.size.height + verticalPadding),
                                (imageRect.size.height + (verticalPadding * 2.0)));
    
    self.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
}

- (void)p_addObserver {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}
#pragma mark - Setter and Getter
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = [self.style titleNumberOfLines];
        _titleLabel.font = [self.style titleFont];
        _titleLabel.textAlignment = [self.style titleAlignment];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textColor = [self.style titleColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.alpha = 1.0;
        _titleLabel.text = self.title;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.numberOfLines = [self.style messageNumberOfLines];
        _messageLabel.font = [self.style messageFont];
        _messageLabel.textAlignment = [self.style messageAlignment];
        _messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _messageLabel.textColor = [self.style messageColor];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.alpha = 1.0;
        _messageLabel.text = self.message;
    }
    return _messageLabel;
}

- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:self.image];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

@end
