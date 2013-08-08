//
//  UIView_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/30/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"
#import "UIResponder_Private.h"

@interface UIView ()

- (void)_viewWillMoveToWindow:(UIWindow *)window;
- (void)_viewDidMoveToWindow:(UIWindow *)window;

#pragma mark - readwrite

@property (nonatomic, readwrite, unsafe_unretained) UIView *superview;
@property (nonatomic, readwrite, retain) CALayer *layer;
@property (nonatomic, readwrite) UIWindow *window;

@end