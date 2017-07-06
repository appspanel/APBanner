//
//  APBanner.h
//
//  Created by Pierre on 29/06/2017.
//  Copyright © 2017 AppsPanel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol APBannerDelegate;

typedef NS_ENUM(NSUInteger, APBannerActionType) {
    APBannerActionTypeTap = 1,
    APBannerActionTypeDismiss
};

typedef void (^BannerActionCompletion)(APBannerActionType);

@interface APBanner : NSObject

/**
 The title to display
 */
@property (nullable, nonatomic, strong) NSString *title;

/**
 The subtitle to display
 */
@property (nullable, nonatomic, strong) NSString *subtitle;

/**
 The body to display
 */
@property (nullable, nonatomic, strong) NSString *body;

/**
 The image to display
 */
@property (nullable, nonatomic, strong) UIImage *image;

/**
 How long banner will be displayed. In seconds.
 */
@property (nullable, nonatomic, strong) NSNumber *duration;


/**
 Blur effect apply to the background view
 */
@property (nonatomic, assign) UIBlurEffectStyle blurEffectStyle;

/**
 Background color apply to background view if blur effect is not available
 */
@property (nullable, nonatomic, strong) UIColor *backgroundColor;

/**
 Title's color
 */
@property (nullable, nonatomic, strong) UIColor *titleColor;

/**
 Subtitle's color
 */
@property (nullable, nonatomic, strong) UIColor *subTitleColor;

/**
 Body's color
 */
@property (nullable, nonatomic, strong) UIColor *bodyColor;

/**
 Title's font
 */
@property (nullable, nonatomic, strong) UIFont *titleFont;

/**
 Subtitle's font
 */
@property (nullable, nonatomic, strong) UIFont *subtitleFont;

/**
 Body's font
 */
@property (nullable, nonatomic, strong) UIFont *bodyFont;


/**
 If banner is shown on sreenn
 */
@property (nonatomic, assign, getter=isShown) BOOL shown;

@property (nullable, nonatomic, weak) id<APBannerDelegate> delegate;
@property (nullable, nonatomic, strong) BannerActionCompletion actionCompletion;

/**
 Init with some values
 
 @param title the title to display
 @param actionCompletion the block called when user do some actions
 @return the banner
 */
- (nonnull instancetype)initWithTitle:(nullable NSString *)title actionBlock:(nullable void (^)(APBannerActionType type))actionCompletion;

/**
 Init with some values
 
 @param title the title to display
 @param image the image to display
 @param actionCompletion actionCompletion the block called when user do some actions
 @return the banner
 */
- (nonnull instancetype)initWithTitle:(nullable NSString *)title image:(nullable UIImage *)image actionBlock:(nullable void (^)(APBannerActionType type))actionCompletion;

/**
 Init with some values
 
 @param title the title to display
 @param subtitle the subtitle to display
 @param body the body to display
 @param image the image to display
 @param actionCompletion actionCompletion the block called when user do some actions
 @return the banner
 */
- (nonnull instancetype)initWithTitle:(nullable NSString *)title subtitle:(NSString * _Nullable)subtitle body:(NSString *_Nullable)body image:(UIImage *_Nullable)image actionBlock:(nullable void (^)(APBannerActionType type))actionCompletion;

/**
 Show (collapsed) banner on top screen
 */
- (void)show;

@end

/**
 Delegate of banner
 */
@protocol APBannerDelegate

/**
 Called when a banner did be dismissed
 
 @param banner the banner which be dismissed
 */
- (void)didEndDisplayBanner:(nonnull APBanner *)banner;
@end


