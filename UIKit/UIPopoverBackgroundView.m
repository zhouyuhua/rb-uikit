//
//  UIPopoverBackgroundView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIPopoverBackgroundView.h"

@implementation UIPopoverBackgroundView

#pragma mark - Returning the Content View Insets

+ (UIEdgeInsets)contentViewInsets
{
    [NSException raise:NSInternalInconsistencyException
                format:@"%s must be implemented by subclasses", __PRETTY_FUNCTION__];
    return UIEdgeInsetsZero;
}

#pragma mark - Accessing the Arrow Metrics

- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection
{
    [NSException raise:NSInternalInconsistencyException
                format:@"%s must be implemented by subclasses", __PRETTY_FUNCTION__];
}

- (UIPopoverArrowDirection)arrowDirection
{
    [NSException raise:NSInternalInconsistencyException
                format:@"%s must be implemented by subclasses", __PRETTY_FUNCTION__];
    return UIPopoverArrowDirectionUnknown;
}

- (void)setArrowOffset:(UIOffset)arrowOffset
{
    [NSException raise:NSInternalInconsistencyException
                format:@"%s must be implemented by subclasses", __PRETTY_FUNCTION__];
}

- (UIOffset)arrowOffset
{
    [NSException raise:NSInternalInconsistencyException
                format:@"%s must be implemented by subclasses", __PRETTY_FUNCTION__];
    return UIOffsetZero;
}

#pragma mark -

+ (CGFloat)arrowHeight
{
    [NSException raise:NSInternalInconsistencyException
                format:@"%s must be implemented by subclasses", __PRETTY_FUNCTION__];
    return 0.0;
}

+ (CGFloat)arrowBase
{
    [NSException raise:NSInternalInconsistencyException
                format:@"%s must be implemented by subclasses", __PRETTY_FUNCTION__];
    return 0.0;
}

#pragma mark - Controlling the Popover Appearance

+ (BOOL)wantsDefaultContentAppearance
{
    return YES;
}

@end
