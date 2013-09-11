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

@interface UIView () <_UIFirstResponderManager> {
    __unsafe_unretained UIResponder *__firstResponder;
    NSMutableArray *_registeredDraggingTypes;
}

- (void)_viewWillMoveToWindow:(UIWindow *)window;
- (void)_viewDidMoveToWindow:(UIWindow *)window;

#pragma mark -

/* The following two methods just forward to their subviews. */
- (void)_windowDidBecomeKey;
- (void)_windowDidResignKey;

#pragma mark -

@property (nonatomic, weak) UIViewController *_viewController;

#pragma mark -

- (void)_enumerateSubviews:(void(^)(UIView *subview, NSUInteger depth, BOOL *stop))block;
- (void)_printSubviews;

#pragma mark - readwrite

@property (nonatomic, readwrite, unsafe_unretained) UIView *superview;
@property (nonatomic, readwrite, retain) CALayer *layer;
@property (nonatomic, readwrite) UIWindow *window;

@end
