//
//  ViewController.m
//
//  Created by Pierre on 29/06/2017.
//  Copyright © 2017 AppsPanel. All rights reserved.
//

#import "ViewController.h"
#import <APBanner/APBannerManager.h>
#import <APBanner/APBanner.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *subtitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *bodyLabel;
@property (weak, nonatomic) IBOutlet UISwitch *imageSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *navbarSwitch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"TITLES"];
    [self initGestures];
    
//    [self setRedTitle];
}

- (void)initGestures {
    UITapGestureRecognizer *tapGestureReco = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGestureReco.numberOfTapsRequired = 1;
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:tapGestureReco];
}

- (void)hideKeyboard {
    [self.titleLabel resignFirstResponder];
    [self.subtitleLabel resignFirstResponder];
    [self.bodyLabel resignFirstResponder];
}

- (IBAction)navbarSwitchAction:(id)sender {
    [self.navigationController setNavigationBarHidden:!((UISwitch *)sender).isOn];
}

- (void)setRedTitle {
    [APBannerManager setTitleColor:[UIColor redColor]];
}

- (IBAction)showToast:(id)sender {
    static int i = 0;

    [APBannerManager showBannerWithTitle:(self.titleLabel.text && self.titleLabel.text.length > 0) ? [NSString stringWithFormat:@"%@ %i", self.titleLabel.text, i++] : nil
                                      subtitle:self.subtitleLabel.text
                                          body:self.bodyLabel.text
                                   image:self.imageSwitch.isOn ? [UIImage imageNamed:@"logo"] : nil
                                   actionBlock:^(APBannerActionType type) {
                                       switch (type) {
                                           case APBannerActionTypeTap:
                                               NSLog(@"TAP");
                                               break;
                                           case APBannerActionTypeDismiss:
                                               NSLog(@"DISMISS");
                                               break;
                                       }
                                   }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
