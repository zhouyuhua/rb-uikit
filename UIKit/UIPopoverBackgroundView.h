//
//  UIPopoverBackgroundView.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"

typedef NS_OPTIONS(NSUInteger, UIPopoverArrowDirection) {
    UIPopoverArrowDirectionUp = 1UL << 0,
    UIPopoverArrowDirectionDown = 1UL << 1,
    UIPopoverArrowDirectionLeft = 1UL << 2,
    UIPopoverArrowDirectionRight = 1UL << 3,
    UIPopoverArrowDirectionAny = UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown |
    UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionRight,
    UIPopoverArrowDirectionUnknown = NSUIntegerMax
};

@interface UIPopoverBackgroundView : UIView

#pragma mark - Returning the Content View Insets

+ (UIEdgeInsets)contentViewInsets;

#pragma mark - Accessing the Arrow Metrics

@property (nonatomic) UIOffset arrowOffset;
@property (nonatomic) UIPopoverArrowDirection arrowDirection;

#pragma mark -

+ (CGFloat)arrowHeight;
+ (CGFloat)arrowBase;

#pragma mark - Controlling the Popover Appearance

+ (BOOL)wantsDefaultContentAppearance;

@end
