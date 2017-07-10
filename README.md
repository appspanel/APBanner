APBanner by AppsPanel (APNL)
===
![alt text](demo.gif)

APBanner is a simple and customizable iOS in-app notification you can display from wherever you want.

This lib can :
  - Display title, subtitle and body
  - Display auto resizable image
  - Auto expand-collapse with user's gestures 
  
Getting Started
---

#### 1 - Install ####

APBanner is available on [cocoapods](https://cocoapods.org/).

```sh
$ pod 'APBanner', '~> 1.0.1'
```

#### 2 - Import ####

Add this import where you want to display banner. You can use it in a ViewController, or wherever you want.

```sh
#import <APBanner/APBannerManager.h>
```

#### 3 - Use ####

##### Simple manager option #####

There are three static methods in APBannerManager to show banner. One with only a title, another with only title and image, and the last one with title, subtitle, body and image.

Each parameter is optionnal. The last paramameter is a completion block to catch user's action on this banner (i.e. Single tap and dismiss).

Use it as following :

```sh
    [APBannerManager showBannerWithTitle:@"Title"
                                          subtitle:@"Subtitle"
                                          body:@"Body"
                                          image:[UIImage imageNamed:@"myPicture"]
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
```


##### Own management #####

If you don't want to use the manager, you can init banners by yourself, as following : 

```
    APBanner *myBanner = [[APBanner alloc]  initWithTitle:@"title" 
                                            subtitle:@"subtitle" 
                                            body:@"body" 
                                            image:[UIImage imageNamed:@"myPicture"]] 
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
    [myBanner show];
```

#### 4 - Customization ####

You can customize all futures banners by using static properties on APBannerManager, or customize only one using APBanner's properties by instantiate it by yourself.

Properties are following : 

- NSString *title
- NSString *subtitle
- NSString *body
- UIImage *image
- NSNumber *duration
- UIBlurEffectStyle blurEffectStyle
- UIColor *backgroundColor
- UIColor *titleColor
- UIColor *subTitleColor
- UIColor *bodyColor
- UIFont *titleFont
- UIFont *subtitleFont
- UIFont *bodyFont

For example, if you want all futures title's color to red, do : 

```
[APBannerManager setTitleColor:[UIColor redColor]];
```

#### 5 - Demo ####

You can find a demo project inside Examples folder.

Have a problem ?
---

Feel free to contact us on : support@apps-panel.com

Resources
---
  - [Cocoapods website](https://cocoapods.org/)
  - [AppsPanel Website](http://www.appspanel.com/)
  - [AppsPanel Management Console](https://backend.appspanel.com)




