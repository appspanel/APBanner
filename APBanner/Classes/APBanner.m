//
//  APBanner.m
//
//  Created by Pierre on 29/06/2017.
//  Copyright © 2017 AppsPanel. All rights reserved.
//

#import "APBanner.h"
#import "APBannerView.h"

#define STATUS_BAR_SIZE [UIApplication sharedApplication].statusBarFrame.size.height

@interface APBanner() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) APBannerView* bannerView;
@property (nonatomic, strong) UIView* parentView;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *verticalConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *minHeightConstraint;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizerShow;
@property (nonatomic, strong) NSTimer* delayTimer;

@property (nonatomic, assign) double heightOfBanner;
@property (nonatomic, assign, getter=isExpanded) BOOL expanded;
@property (nonatomic, assign) BOOL canBeExpanded;

@property (nonatomic, assign) UIBlurEffectStyle defaultBlurEffectStyle;
@property (nonatomic, strong) UIColor *defaultBackgroundColor;
@property (nonatomic, strong) UIColor *defaultTitleColor;
@property (nonatomic, strong) UIColor *defaultSubTitleColor;
@property (nonatomic, strong) UIColor *defaultBodyColor;
@property (nonatomic, strong) UIFont *defaultTitleFont;
@property (nonatomic, strong) UIFont *defaultSubtitleFont;
@property (nonatomic, strong) UIFont *defaultBodyFont;
@property (nonatomic, strong) NSNumber *defaultDuration;

@end

@implementation APBanner

#pragma mark init methods


/**
 Init without values
 
 @return the banner
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        self.expanded = NO;
        self.shown = NO;
    }
    return self;
}


/**
 Get height of banner
 
 @return the height of the banner's view
 */
- (double)heightOfBanner {
    return self.bannerView.frame.size.height;
}


/**
 Init with some values
 
 @param title the title to display
 @param actionCompletion the block called when user do some actions
 @return the banner
 */
- (instancetype)initWithTitle:(NSString *)title actionBlock:(void (^)(APBannerActionType type))actionCompletion{
    return [self initWithTitle:title subtitle:nil body:nil image:nil actionBlock:actionCompletion];
}


/**
 Init with some values
 
 @param title the title to display
 @param image the image to display
 @param actionCompletion actionCompletion the block called when user do some actions
 @return the banner
 */
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image actionBlock:(void (^)(APBannerActionType type))actionCompletion{
        return [self initWithTitle:title subtitle:nil body:nil image:image actionBlock:actionCompletion];
}


/**
  Init with some values
 
 @param title the title to display
 @param subtitle the subtitle to display
 @param body the body to display
 @param image the image to display
 @param actionCompletion actionCompletion the block called when user do some actions
 @return the banner
 */
- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body image:(UIImage *)image actionBlock:(void (^)(APBannerActionType type))actionCompletion{
    self = [self init];
    if (self) {
        _title = title;
        _subtitle = subtitle;
        _body = body;
        _image = image;
        _actionCompletion = actionCompletion;
        _minHeightConstraint.active = _image ? YES : NO;
        
    }
    return self;
}


/**
 Set image to be displayed
 
 @param image the image to be displayed
 */
- (void)setImage:(UIImage *)image {
    _image = image;
    _minHeightConstraint.active = _image ? YES : NO;
}


/**
 Test if label is truncated due to its size
 
 @param label the label to test
 @return if the label is truncated
 */
- (BOOL)labelIsTruncated:(UILabel *)label {
    CGSize size = [label.text sizeWithAttributes: @{NSFontAttributeName: label.font}];
    return (size.width > label.bounds.size.width);
}


/**
 Test if banner can be expanded, i.e. if (at least) one of the three labels is truncated
 
 @return if the banner can be expanded
 */
- (BOOL)canBeExpanded {
    return ([self labelIsTruncated:self.bannerView.titleLabel] ||
    [self labelIsTruncated:self.bannerView.subtitleLabel] ||
    [self labelIsTruncated:self.bannerView.bodyLabel]);
}


#pragma mark - Fire


/**
 Show banner on top screen
 
 @param expand if labels must be on 1 lines or 0 line
 */
- (void)showExpand:(BOOL)expand {
    if (!self.bannerView) {
        [self initUI];
        [self initGestures];
    }
    
    self.shown = YES;
    self.expanded = expand;
    [self.bannerView.titleLabel setText:self.title ? self.title : @""];
    [self.bannerView.subtitleLabel setText:self.subtitle ? self.subtitle : @""];
    [self.bannerView.bodyLabel setText:self.body ? self.body : @""];
    [self.bannerView.imageView setHidden:(!self.image)];
    [self.bannerView.labelsRightConstraint setActive:self.image ? NO : YES];
    [self.bannerView.labelsImageConstraint setActive:self.image ? YES : NO];
    [self.bannerView.imageView setImage:self.image];
    
    self.bannerView.bottomViewHeightConstraint.constant = ([self canBeExpanded] ? 20 : 0);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(expand ? 0 : 0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.verticalConstraint.constant = 0;
        [self.bannerView.titleLabel setNumberOfLines:expand ? 0 : 1];
        [self.bannerView.subtitleLabel setNumberOfLines:expand ? 0 : 1];
        [self.bannerView.bodyLabel setNumberOfLines:expand ? 0 : 1];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidChangeStatusBarFrameNotification:)
                                                     name:UIApplicationDidChangeStatusBarFrameNotification
                                                   object:nil];
        [self updateConstraintsIfNeeded:YES completion:nil];

        [self.delayTimer invalidate];
        if (!expand) {
            self.delayTimer = [NSTimer timerWithTimeInterval:(self.duration ? [self.duration doubleValue] : 5) target:self selector:@selector(hideBanner) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:self.delayTimer forMode:NSDefaultRunLoopMode];
        }
    });
}

/**
 Show (collapsed) banner on top screen
 */
- (void)show {
    [self showExpand:NO];
}


#pragma mark - Gestures

/**
 Called when a single tap is detected on the banner
 */
- (void)tapOnBanner {
    if (self.actionCompletion) {
        self.actionCompletion(APBannerActionTypeTap);
    }
    [self hideBanner];
}

/**
 Called when a swiper gesture is detected on the banner
 */
- (void)panBanner:(UIPanGestureRecognizer *)recognizer {
    CGPoint velocityOfPan = [recognizer velocityInView:self.bannerView];
    CGPoint delta;
    
    double height = self.heightOfBanner;
    
    switch(recognizer.state) {
        case UIGestureRecognizerStateBegan:
            // retain start point
            self.panStartPoint = delta = [recognizer translationInView:self.bannerView];
            break;
        case UIGestureRecognizerStateChanged:
        {
            // calculate delta between old and new point
            delta = CGPointApplyAffineTransform([recognizer translationInView:self.bannerView],
                                                CGAffineTransformMakeTranslation(-self.panStartPoint.x, -self.panStartPoint.y));
            
            // retain start point for future calls
            self.panStartPoint = [recognizer translationInView:self.bannerView];
            
            
            if ((delta.y > 0 && self.verticalConstraint.constant > 0) || (velocityOfPan.y > 200 && self.verticalConstraint.constant >= 0)) {
                // if pull down
                if (self.canBeExpanded && !self.expanded) {
                    // expand
                    [self showExpand:YES];
                } else {
                    // or do nothing
                    delta.y = 0;
                }
            } else {
                // if pull up, follow finger
                delta.y = self.verticalConstraint.constant + delta.y;
            }
            
            if (([self isExpanded] || ![self canBeExpanded]) && delta.y > 0) {
                // avoid bounce on top
                delta.y = 0;
            }
            
            if (!isnan(delta.y) && (delta.y <= 0 || self.verticalConstraint.constant != 0)) {
                // update view with new constraint
                self.verticalConstraint.constant = delta.y;
                [self updateConstraintsIfNeeded:NO completion:^(BOOL finished) {
                    if (delta.y == -height) {
                        // remove banner if it has disappear
                        [self removeBannerView];
                        if (self.actionCompletion) {
                            self.actionCompletion(APBannerActionTypeDismiss);
                        }
                    }
                }];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            
            if (velocityOfPan.y < 0) {
                // pull up
                if (self.verticalConstraint.constant >= (self.heightOfBanner / 2) && (velocityOfPan.y > -700)) {
                    delta.y = 0;
                } else {
                    delta.y = -height;
                }
            } else if (velocityOfPan.y > 0) {
                // pull down
                delta.y = 0;
            }

            if (!isnan(delta.y <= 0 || self.verticalConstraint.constant != 0)) {
                self.verticalConstraint.constant = delta.y;
                [self updateConstraintsIfNeeded:YES completion:^(BOOL finished) {
                    if (delta.y == -height) {
                        // remove banner if it has disappear
                        [self removeBannerView];
                        if (self.actionCompletion) {
                            self.actionCompletion(APBannerActionTypeDismiss);
                        }
                    }
                }];
            }
            break;
        }
        default:
            break;
    }
}


/**
 Remove the banner view and set it to nil
 Notify delegate is there's one
 */
- (void)removeBannerView {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [self.bannerView removeFromSuperview];
    self.bannerView = nil;
    
    if (self.delegate) {
        [self.delegate didEndDisplayBanner:self];
    }
}

/**
 Hide banner with animation
 */
- (void)hideBanner {
    [self.delayTimer invalidate];
    self.verticalConstraint.constant = -self.heightOfBanner;
    
    [self updateConstraintsIfNeeded:YES completion:^(BOOL finished) {
        [self removeBannerView];
    }];
}

#pragma mark - UI


/**
 Called when use rotate device
 
 @param notification the notification wich called the function
 */
- (void)appDidChangeStatusBarFrameNotification:(NSNotification*)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue* statusBarFrameBegin = [userInfo valueForKey:UIApplicationStatusBarFrameUserInfoKey];
    CGRect statusBarFrameBeginRect = [statusBarFrameBegin CGRectValue];
    BOOL willBeHidden = (statusBarFrameBeginRect.size.height != 0);
    
    self.bannerView.topConstraint.constant = willBeHidden ? 0 : 20;
    [self updateConstraintsIfNeeded:YES completion:nil];
}


/**
 Update constraints if needed
 
 @param animated if there's an animation
 @param completion called after animation
 */
- (void)updateConstraintsIfNeeded:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    float duration = animated ? 0.3f : 0;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.parentView layoutIfNeeded];
        [self.bannerView.titleLabel setNeedsLayout];
        [self.bannerView.subtitleLabel setNeedsLayout];
        [self.bannerView.bodyLabel setNeedsLayout];
    } completion:completion];
}


/**
 Init banner view from xib, apply constraint and find top view on screen
 */
- (void)initUI {
    self.bannerView = [[[NSBundle mainBundle] loadNibNamed:@"APBannerView" owner:self options:nil] lastObject];

    self.bannerView.topConstraint.constant = STATUS_BAR_SIZE;
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    [self.bannerView.titleLabel setFont:self.titleFont];
    [self.bannerView.subtitleLabel setFont:self.subtitleFont];
    [self.bannerView.bodyLabel setFont:self.bodyFont];
    
    [self.bannerView.titleLabel setTextColor:self.titleColor];
    [self.bannerView.subtitleLabel setTextColor:self.subTitleColor];
    [self.bannerView.bodyLabel setTextColor:self.bodyColor];
    
    self.parentView = window;
    
    [self initConstraints];
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.bannerView.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:self.blurEffectStyle];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.bannerView.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.bannerView addSubview:blurEffectView];
        [self.bannerView sendSubviewToBack:blurEffectView];
    } else {
        self.bannerView.backgroundColor = self.backgroundColor;
    }
}

/**
 Init gesture for user's actions
 */
- (void)initGestures {
    self.panRecognizerShow = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panBanner:)];
    self.panRecognizerShow.delegate = self;
    [self.panRecognizerShow setMinimumNumberOfTouches:1];
    [self.panRecognizerShow setMaximumNumberOfTouches:1];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnBanner)];
    tapGesture.numberOfTapsRequired = 1;
    
    [self.bannerView setUserInteractionEnabled:YES];
    [self.parentView setUserInteractionEnabled:YES];
    
    [self.bannerView addGestureRecognizer:self.panRecognizerShow];
    [self.bannerView addGestureRecognizer:tapGesture];

}


/**
 Init constraints for perfect UI on any device
 */
- (void)initConstraints {
    [self.parentView addSubview:self.bannerView];
    
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;

    //Trailing
    NSLayoutConstraint *trailing = [NSLayoutConstraint
                                    constraintWithItem:self.bannerView
                                    attribute:NSLayoutAttributeTrailing
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.parentView
                                    attribute:NSLayoutAttributeTrailing
                                    multiplier:1.0f
                                    constant:0.f];
    
    //Leading
    
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:self.bannerView
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.parentView
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:0.f];
    
    //Top
    self.verticalConstraint = [NSLayoutConstraint
                               constraintWithItem:self.bannerView
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:self.parentView
                               attribute:NSLayoutAttributeTop
                               multiplier:1.0f
                               constant:-self.heightOfBanner];
    
    //Height to be fixed for SubView
    self.minHeightConstraint = [NSLayoutConstraint
                             constraintWithItem:self.bannerView
                             attribute:NSLayoutAttributeHeight
                             relatedBy:NSLayoutRelationGreaterThanOrEqual
                             toItem:nil
                             attribute:NSLayoutAttributeNotAnAttribute
                             multiplier:0
                             constant:80];
    
    //Add constraints to the Parent
    [self.parentView addConstraint:trailing];
    [self.parentView addConstraint:self.verticalConstraint];
    [self.parentView addConstraint:leading];
    [self.parentView addConstraint:self.minHeightConstraint];
    
    //Add height constraint to the subview, as subview owns it.

}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - User UI Custom

-(NSNumber *)duration {
    return (_duration ? _duration : self.defaultDuration);
}

- (UIBlurEffectStyle)blurEffectStyle {
    return (_blurEffectStyle ? _blurEffectStyle : self.defaultBlurEffectStyle);
}

- (UIColor *)backgroundColor {
    return (_backgroundColor ? _backgroundColor : self.defaultBackgroundColor);
}

- (UIColor *)titleColor {
    return (_titleColor ? _titleColor : self.defaultTitleColor);
}

- (UIColor *)subTitleColor {
    return (_subTitleColor ? _subTitleColor : self.defaultTitleColor);
}

- (UIColor *)bodyColor {
    return (_bodyColor ? _bodyColor : self.defaultBodyColor);
}

- (UIFont *)titleFont {
    return (_titleFont ? _titleFont : self.defaultTitleFont);
}

- (UIFont *)subtitleFont {
    return (_subtitleFont ? _subtitleFont : self.defaultSubtitleFont);
}

- (UIFont *)bodyFont {
    return (_bodyFont ? _bodyFont : self.defaultBodyFont);
}

#pragma mark - Default UI values


/**
 value if user has no override blurEffectStyle
 @return the default BlurEffectStyle
 */
- (UIBlurEffectStyle)defaultBlurEffectStyle {
    return UIBlurEffectStyleDark;
}

/**
 value if user has no override backgroundColor
 @return the default BackgroundColor
 */
- (UIColor *)defaultBackgroundColor {
    return [UIColor blackColor];
}

/**
 value if user has no override titleColor
 
 @return the default titleColor
 */
- (UIColor *)defaultTitleColor {
    return [UIColor whiteColor];
}

/**
 value if user has no override subTitleColor
 
 @return the default subTitleColor
 */
- (UIColor *)defaultSubTitleColor {
    return [UIColor whiteColor];
}

/**
 value if user has no override bodyColor
 
 @return the default bodyColor
 */
- (UIColor *)defaultBodyColor {
    return [UIColor whiteColor];
}

/**
 value if user has no override TitleFont
 
 @return the default TitleFont
 */
- (UIFont *)defaultTitleFont {
    return [UIFont boldSystemFontOfSize:14];
}

/**
 value if user has no override SubtitleFont
 
 @return the default SubtitleFont
 */
- (UIFont *)defaultSubtitleFont {
    //if (@available(iOS 8.2, *)) {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.2) {
        return [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    } else {
        return [UIFont systemFontOfSize:13];
    }
}

/**
 value if user has no override BodyFont
 
 @return the default BodyFont
 */
- (UIFont *)defaultBodyFont {
    return [UIFont systemFontOfSize:12];
}

/**
 value if user has no override Duration
 
 @return the default Duration
 */
- (NSNumber *)defaultDuration {
    return @5;
}

@end
