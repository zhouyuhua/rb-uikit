//
//  UIPanGestureRecognizer.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/6/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIPanGestureRecognizer.h"
#import "UIGestureRecognizer_Private.h"
#import "UIGestureRecognizerSubclass.h"

#import "UIEvent_Private.h"
#import "UITouch_Private.h"

@implementation UIPanGestureRecognizer {
    NSTimeInterval _lastEventTimestamp;
    CGPoint _velocity;
    CGPoint _translation;
}

- (void)reset
{
    [super reset];
    
    _velocity = CGPointZero;
    _translation = CGPointZero;
    _lastEventTimestamp = 0.0;
}

#pragma mark -

- (CGPoint)velocityInView:(UIView *)view
{
    return _velocity;
}

#pragma mark -

- (void)setTranslation:(CGPoint)translation inView:(UIView *)view
{
    _velocity = CGPointZero;
    _translation = translation;
}

- (CGPoint)translationInView:(UIView *)view
{
    return _translation;
}

#pragma mark -

///UIScrollWheelGestureRecognizer overrides this to receive its events
///from the scroll wheel instead of the mouse. As such, all code in this
///recognizer must be functional with both the mouse and the scroll wheel.
- (BOOL)_wantsGestureEvents
{
    return NO;
}

- (void)processChangeWithTouch:(UITouch *)touch forEvent:(UIEvent *)event
{
    NSTimeInterval elapsedTime = event.timestamp - _lastEventTimestamp;
    CGPoint delta = touch.delta;
    
    _translation.x += delta.x;
    _translation.y += delta.y;
    
    _velocity.x = delta.x / elapsedTime;
    _velocity.y = delta.y / elapsedTime;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.state == UIGestureRecognizerStatePossible) {
        UITouch *touch = [touches anyObject];
        
        [self setTranslation:touch.delta inView:touch.view];
        _lastEventTimestamp = event.timestamp;
        self.state = UIGestureRecognizerStateBegan;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.state == UIGestureRecognizerStatePossible) {
        UITouch *touch = [touches anyObject];
        
        [self setTranslation:touch.delta inView:touch.view];
        _lastEventTimestamp = event.timestamp;
        self.state = UIGestureRecognizerStateBegan;
    } else if(self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        UITouch *touch = [touches anyObject];
        
        [self processChangeWithTouch:touch forEvent:event];
        
        _lastEventTimestamp = event.timestamp;
        self.state = UIGestureRecognizerStateChanged;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        UITouch *touch = [touches anyObject];
        
        [self processChangeWithTouch:touch forEvent:event];
        
        _lastEventTimestamp = 0.0;
        self.state = UIGestureRecognizerStateEnded;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self reset];
}

@end
