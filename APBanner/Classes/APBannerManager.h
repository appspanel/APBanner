//
//  APBannerManager.h
//
//  Created by Pierre on 30/06/2017.
//  Copyright © 2017 AppsPanel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APBanner.h"
#import <UIKit/UIKit.h>

@interface APBannerManager : NSObject

/**
 Show banner with some values
 
 @param title the title to display
 @param actionCompletion the block called when user do some actions
 */
+ (void)showBannerWithTitle:(NSString *)title actionBlock:(void (^)(APBannerActionType type))actionCompletion;


/**
 Show banner with some values
 
 @param title the title to display
 @param image the image to display
 @param actionCompletion actionCompletion the block called when user do some actions
 */
+ (void)showBannerWithTitle:(NSString *)title image:(UIImage *)image actionBlock:(void (^)(APBannerActionType type))actionCompletion;


/**
 Show banner with some values
 
 @param title the title to display
 @param subtitle the subtitle to display
 @param body the body to display
 @param image the image to display
 @param actionCompletion actionCompletion the block called when user do some actions
 */
+ (void)showBannerWithTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body image:(UIImage *)image actionBlock:(void (^)(APBannerActionType type))actionCompletion;


/**
 Set duration for all next banners
 
 @param duration the duration in seconds
 */
+ (void)setDuration:(NSNumber *)duration;


/**
 Set blur effect style for all next banners
 
 @param blurEffectStyle the style
 */
+ (void)blurEffectStyle:(UIBlurEffectStyle)blurEffectStyle;


/**
 Set background color for all next banners. Use only if UIBlueEffectStyle is not available
 
 @param backgroundColor the color
 */
+ (void)setBackgroundColor:(UIColor *)backgroundColor;


/**
 Set title color for all next banners
 
 @param titleColor the color
 */
+ (void)setTitleColor:(UIColor *)titleColor;


/**
 Set subtitle color for all next banners
 
 @param subTitleColor the color
 */
+ (void)setSubTitleColor:(UIColor *)subTitleColor;


/**
 Set body color for all next banners
 
 @param bodyColor the color
 */
+ (void)setBodyColor:(UIColor *)bodyColor;

/**
 Set title font for all next banners
 
 @param titleFont the font
 */
+ (void)setTitleFont:(UIFont *)titleFont;


/**
 Set subTitle font for all next banners
 
 @param subtitleFont the font
 */
+ (void)setSubtitleFont:(UIFont *)subtitleFont;


/**
 Set body font for all next banners
 
 @param bodyFont the font
 */
+ (void)setBodyFont:(UIFont *)bodyFont;
@end
