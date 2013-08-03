//
//  UITouch.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/30/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIWindow, UIView;

typedef NS_ENUM(NSInteger, UITouchPhase) {
    UITouchPhaseBegan,
    UITouchPhaseMoved,
    UITouchPhaseStationary,
    UITouchPhaseEnded,
    UITouchPhaseCancelled,
    
    _UITouchPhaseGestureBegan,
    _UITouchPhaseGestureMoved,
    _UITouchPhaseGestureEnd,
};

@interface UITouch : NSObject

@property (nonatomic, readonly) NSTimeInterval timestamp;
@property (nonatomic, readonly) UITouchPhase phase;
@property (nonatomic, readonly) NSUInteger tapCount;

@property (nonatomic, readonly, retain) UIWindow *window;
@property (nonatomic, readonly, retain) UIView *view;
@property (nonatomic, readonly, copy) NSArray *gestureRecognizers;

- (CGPoint)locationInView:(UIView *)view;
- (CGPoint)previousLocationInView:(UIView *)view;

@end
