//
//  UITouch_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/30/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UITouch.h"

@interface UITouch ()

@property (nonatomic) CGPoint locationInWindow;
@property (nonatomic) CGPoint previousLocationInWindow;

@property (nonatomic) CGPoint delta;

#pragma mark - readwrite

@property (nonatomic, readwrite) NSTimeInterval timestamp;
@property (nonatomic, readwrite) UITouchPhase phase;
@property (nonatomic, readwrite) NSUInteger tapCount;

#pragma mark -

@property (nonatomic, readwrite, retain) UIWindow *window;
@property (nonatomic, readwrite, retain) UIView *view;
@property (nonatomic, readwrite, copy) NSArray *gestureRecognizers;

@end
