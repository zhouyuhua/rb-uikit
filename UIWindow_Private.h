//
//  UIWindow_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIWindow.h"
#import "UIResponder_Private.h"

@class UIWindowHostNativeView;

@interface UIWindow () <NSWindowDelegate>

@property (nonatomic) NSWindow *_nativeWindow;
@property (nonatomic) UIWindowHostNativeView *_hostNativeView;

#pragma mark -

- (void)_viewWasAddedToWindow:(UIView *)view;
- (void)_viewWasRemovedFromWindow:(UIView *)view;

@property (nonatomic, copy) NSArray *_possibleKeyViews;

@end
