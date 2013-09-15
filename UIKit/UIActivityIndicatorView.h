//
//  UIActivityIndicatorView.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/14/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"
#import "UIColor.h"

typedef NS_ENUM(NSUInteger, UIActivityIndicatorViewStyle) {
    UIActivityIndicatorViewStyleWhiteLarge,
    UIActivityIndicatorViewStyleWhite,
    UIActivityIndicatorViewStyleGray,
};

@interface UIActivityIndicatorView : UIView

- (instancetype)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style;

#pragma mark - Managing an Activity Indicator

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

@property (nonatomic) BOOL hidesWhenStopped;

#pragma mark - Configuring the Activity Indicator Appearance

@property (nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@property (nonatomic) UIColor *color;

@end
