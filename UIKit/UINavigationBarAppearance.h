//
//  UINavigationBarAppearance.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/20/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIConcreteAppearance.h"
#import "UINavigationBar.h"

@interface UINavigationBarAppearance : UIConcreteAppearance

@property (nonatomic) UIColor *barTintColor;
@property (nonatomic) UIImage *backgroundImage;

- (void)setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics;
- (UIImage *)backgroundImageForBarMetrics:(UIBarMetrics)barMetrics;
- (BOOL)_hasCustomBackgroundImage;

@property (nonatomic, retain) UIImage *shadowImage;

#pragma mark -

@property (nonatomic, copy) NSDictionary *titleTextAttributes;

- (void)setTitleVerticalPositionAdjustment:(CGFloat)adjustment forBarMetrics:(UIBarMetrics)barMetrics;
- (CGFloat)titleVerticalPositionAdjustmentForBarMetrics:(UIBarMetrics)barMetrics;

@end
