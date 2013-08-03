//
//  UIGestureRecognizer.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIGestureRecognizer_Private.h"

#import "UIEvent_Private.h"
#import "UITouch_Private.h"
#import "UIView_Private.h"

@implementation UIGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action
{
    return nil;
}

#pragma mark - Actions

- (void)addTarget:(id)target action:(SEL)action
{
    
}

- (void)removeTarget:(id)target action:(SEL)action
{
    
}

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    UIGestureRecognizer *gestureRecognizer = [self.class new];
    
    gestureRecognizer->_delegate = _delegate;
    gestureRecognizer->_delegateRespondsTo = _delegateRespondsTo;
    
    return gestureRecognizer;
}

#pragma mark - Properties

- (void)setDelegate:(id<UIGestureRecognizerDelegate>)delegate
{
    _delegate = delegate;
    
    _delegateRespondsTo.gestureRecognizerShouldBegin = [delegate respondsToSelector:@selector(gestureRecognizerShouldBegin:)];
    _delegateRespondsTo.gestureRecognizerShouldRecognizeSimultaneouslyWithGestureRecognizer = [delegate respondsToSelector:@selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)];
    _delegateRespondsTo.gestureRecognizerShouldReceiveTouch = [delegate respondsToSelector:@selector(gestureRecognizer:shouldReceiveTouch:)];
}

+ (NSSet *)keyPathsForValuesAffectingView
{
    return [NSSet setWithObjects:@"_view", nil];
}

- (UIView *)view
{
    return self._view;
}

#pragma mark - Public Methods

- (void)requireGestureRecognizerToFail:(UIGestureRecognizer *)otherGestureRecognizer
{
    if(!_gesturesRequiredToFail) {
        _gesturesRequiredToFail = [NSMutableSet set];
    }
    
    [_gesturesRequiredToFail addObject:otherGestureRecognizer];
}

- (CGPoint)locationInView:(UIView *)view
{
    return [self locationOfTouch:0 inView:view];
}

- (NSUInteger)numberOfTouches
{
    return self._touches.count;
}

- (CGPoint)locationOfTouch:(NSUInteger)touchIndex inView:(UIView *)view
{
    return [self._touches[touchIndex] locationInView:view];
}

#pragma mark -

- (void)ignoreTouch:(UITouch *)touch forEvent:(UIEvent *)event
{
    self._lastIgnoredEvent = event;
    self._lastIgnoredTouch = touch;
}

#pragma mark - To override

- (void)reset
{
    
}

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer
{
    return [_gesturesRequiredToFail containsObject:preventedGestureRecognizer];
}

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer
{
    return [preventingGestureRecognizer canPreventGestureRecognizer:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

#pragma mark - Internal Event Handling

- (BOOL)_wantsToTrackEvent:(UIEvent *)event
{
    if(!self._view)
        return NO;
    
    if(event.type == _UIEventTypeGesture && ![self _wantsGestureEvents])
        return NO;
    
    if(![self._view gestureRecognizerShouldBegin:self])
        return NO;
    
    if(_delegateRespondsTo.gestureRecognizerShouldBegin && ![_delegate gestureRecognizerShouldBegin:self])
        return NO;
    
    return (self.state == UIGestureRecognizerStatePossible);
}

- (void)_handleEvent:(UIEvent *)event
{
    self._currentEvent = event;
    
    NSSet *touches = [event touchesForGestureRecognizer:self];
    for (UITouch *touch in touches) {
        if(self.cancelsTouchesInView || (self._lastIgnoredEvent == event && self._lastIgnoredTouch == touch)) {
            touch.view = nil;
            self._lastIgnoredTouch = nil;
            self._lastIgnoredEvent = nil;
        } else {
            touch.view = self._view;
        }
        
        switch (touch.phase) {
            case UITouchPhaseBegan: {
                [self touchesBegan:touches withEvent:event];
                self._touches = [touches allObjects];
                break;
            }
                
            case UITouchPhaseMoved: {
                [self touchesMoved:touches withEvent:event];
                self._touches = [touches allObjects];
                break;
            }
                
            case UITouchPhaseStationary: {
                break;
            }
                
            case UITouchPhaseEnded: {
                [self touchesEnded:touches withEvent:event];
                self._touches = nil;
                break;
            }
                
                
            case UITouchPhaseCancelled: {
                [self touchesCancelled:touches withEvent:event];
                self._touches = nil;
                break;
            }
                
            case _UITouchPhaseGestureBegan: {
                break;
            }
                
            case _UITouchPhaseGestureMoved: {
                break;
            }
                
            case _UITouchPhaseGestureEnd: {
                break;
            }
        }
    }
}

@end
