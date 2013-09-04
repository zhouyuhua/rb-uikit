//
//  UIView_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/30/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"
#import "UIResponder_Private.h"

@class UIViewController;

@interface UIView () <UIFirstResponderManager> {
    __unsafe_unretained UIResponder *_currentFirstResponder;
}

- (void)_viewWillMoveToWindow:(UIWindow *)window;
- (void)_viewDidMoveToWindow:(UIWindow *)window;

#pragma mark -

/* The following two methods just forward to their subviews. */
- (void)_windowDidBecomeKey;
- (void)_windowDidResignKey;

#pragma mark -

@property (nonatomic, weak) UIViewController *_viewController;

#pragma mark - readwrite

@property (nonatomic, readwrite, unsafe_unretained) UIView *superview;
@property (nonatomic, readwrite, retain) CALayer *layer;
@property (nonatomic, readwrite) UIWindow *window;

@end
