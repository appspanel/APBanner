//
//  BannerView.h
//
//  Created by Pierre on 30/06/2017.
//  Copyright © 2017 AppsPanel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APBannerView : UIView


/**
 Constraint to determine space between text and right border
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelsRightConstraint;


/**
 Constraint to determine space between text and image
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelsImageConstraint;


/**
 Constraint to determine space between view and top border (typically if there's a status bar or not)
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;


/**
 Label to display subtitle
 */
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;


/**
 Label to display title
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


/**
 Label to display body
 */
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;


/**
 Constraint to determine height of bottom view (wich contains symbol for pulling banner)
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;


/**
 ImageView to display image
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
