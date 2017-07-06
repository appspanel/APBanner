//
//  APBannerManager.m
//
//  Created by Pierre on 30/06/2017.
//  Copyright © 2017 AppsPanel. All rights reserved.
//

#import "APBannerManager.h"

static NSNumber *duration;
static UIBlurEffectStyle blurEffectStyle;
static UIColor *backgroundColor;
static UIColor *titleColor;
static UIColor *subTitleColor;
static UIColor *bodyColor;
static UIFont *titleFont;
static UIFont *subtitleFont;
static UIFont *bodyFont;

@interface APBannerManager() <APBannerDelegate>

@property (nonatomic, strong) NSMutableArray *banners;
@end

static APBannerManager *sharedInstance = nil;

@implementation APBannerManager

#pragma mark - Singleton
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[APBannerManager alloc] init];
        sharedInstance.banners = [NSMutableArray new];
    });
    return sharedInstance;
}

#pragma mark - Static methods
+ (void)showBannerWithTitle:(NSString *)title actionBlock:(void (^)(APBannerActionType type))actionCompletion {
    [[APBannerManager sharedInstance] showBannerWithTitle:title actionBlock:actionCompletion];
}

+ (void)showBannerWithTitle:(NSString *)title image:(UIImage *)image actionBlock:(void (^)(APBannerActionType type))actionCompletion {
    [[APBannerManager sharedInstance] showBannerWithTitle:title image:image actionBlock:actionCompletion];
}

+ (void)showBannerWithTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body image:(UIImage *)image actionBlock:(void (^)(APBannerActionType type))actionCompletion {
    [[APBannerManager sharedInstance] showBannerWithTitle:title subtitle:subtitle body:body image:image actionBlock:actionCompletion];
}

#pragma mark - private methods
#pragma mark - Manage queue

- (void) addBannerToQueue:(APBanner *)banner {
    @synchronized(self) {
        [self.banners addObject:banner];
    }
    
    [banner setDelegate:self];
    
    [self fireIfNeeded];
}

- (void)fireIfNeeded {
    if (self.banners.count == 1 && ![[self.banners firstObject] isShown]) {
        [[self.banners firstObject] show];
    }
}

- (void)fireNext {
    if (self.banners.count >= 1 && ![[self.banners firstObject] isShown]) {
        [[self.banners firstObject] show];
    }
}

#pragma mark - APBannerDelegate

- (void)didEndDisplayBanner:(APBanner *)banner {
    if ([self.banners containsObject:banner]) {
        [self.banners removeObject:banner];
    }
    
    [self fireNext];
}

#pragma mark - Show banners
- (void)showBannerWithTitle:(NSString *)title actionBlock:(void (^)(APBannerActionType type))actionCompletion {
    if (title && title.length > 0) {
        APBanner *banner = [[APBanner alloc] initWithTitle:title actionBlock:actionCompletion];
        [self setUIForBanner:banner];
        [self addBannerToQueue:banner];
    }
}

- (void)showBannerWithTitle:(NSString *)title image:(UIImage *)image actionBlock:(void (^)(APBannerActionType type))actionCompletion {
    if (title && title.length > 0) {
        APBanner *banner = [[APBanner alloc] initWithTitle:title image:image actionBlock:actionCompletion];
        [self setUIForBanner:banner];
        [self addBannerToQueue:banner];
    }
}


- (void)showBannerWithTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body image:(UIImage *)image actionBlock:(void (^)(APBannerActionType type))actionCompletion {
    if ((title && title.length > 0) || (subtitle && subtitle.length > 0) || (body && body.length > 0)) {
        APBanner *banner = [[APBanner alloc] initWithTitle:title subtitle:subtitle body:body image:image actionBlock:actionCompletion];
        [self setUIForBanner:banner];
        [self addBannerToQueue:banner];
    }
}

#pragma mark - UI
- (void) setUIForBanner:(APBanner *)banner {
    [banner setDuration:duration];
    [banner setBlurEffectStyle:blurEffectStyle];
    [banner setBackgroundColor:backgroundColor];
    [banner setTitleColor:titleColor];
    [banner setSubTitleColor:subTitleColor];
    [banner setBodyColor:bodyColor];
    [banner setTitleFont:titleFont];
    [banner setSubtitleFont:subtitleFont];
    [banner setBodyFont:bodyFont];
}

+ (void)setDuration:(NSNumber *)kduration {
    duration = kduration;
}

+ (void)blurEffectStyle:(UIBlurEffectStyle)kblurEffectStyle {
    blurEffectStyle = kblurEffectStyle;
}
+ (void)setBackgroundColor:(UIColor *)kbackgroundColor {
    backgroundColor = kbackgroundColor;
}
+ (void)setTitleColor:(UIColor *)ktitleColor {
    titleColor = ktitleColor;
}
+ (void)setSubTitleColor:(UIColor *)ksubTitleColor {
    subTitleColor = ksubTitleColor;
}
+ (void)setBodyColor:(UIColor *)kbodyColor {
    bodyColor = kbodyColor;
}
+ (void)setTitleFont:(UIFont *)ktitleFont {
    titleFont = ktitleFont;
}
+ (void)setSubtitleFont:(UIFont *)ksubtitleFont {
    subtitleFont = ksubtitleFont;
}
+ (void)setBodyFont:(UIFont *)kbodyFont {
    bodyFont = kbodyFont;
}

@end
