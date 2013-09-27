//
//  UIGestureRecognizer.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIGestureRecognizer_Private.h"

#import "UIApplication_Private.h"
#import "UIEvent_Private.h"
#import "UITouch_Private.h"
#import "UIView_Private.h"

#import "UIAction.h"

@implementation UIGestureRecognizer {
    NSMutableArray *_actions;
}

- (id)init
{
    if((self = [super init])) {
        _actions = [NSMutableArray array];
        self.state = UIGestureRecognizerStatePossible;
    }
    
    return self;
}

- (id)initWithTarget:(id)target action:(SEL)action
{
    if((self = [self init])) {
        if(target && action)
            [self addTarget:target action:action];
    }
    
    return self;
}

#pragma mark - Actions

- (void)addTarget:(id)target action:(SEL)action
{
    UIAction *actionObject = [UIAction new];
    actionObject.target = target;
    actionObject.action = action;
    [_actions addObject:actionObject];
}

- (void)removeTarget:(id)target action:(SEL)action
{
    NSUInteger firstMatch = [_actions indexOfObjectPassingTest:^BOOL(UIAction *internalAction, NSUInteger index, BOOL *stop) {
        return (internalAction.action == action &&
                internalAction.target == target);
    }];
    
    if(firstMatch) {
        [_actions removeObjectAtIndex:firstMatch];
    }
}

- (BOOL)_wantsAutomaticActionSending
{
    return YES;
}

- (void)_sendActions
{
    for (UIAction *action in _actions) {
        [action invokeFromSender:self];
    }
}

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    UIGestureRecognizer *gestureRecognizer = [self.class new];
    
    gestureRecognizer->_delegate = _delegate;
    gestureRecognizer->_delegateRespondsTo = _delegateRespondsTo;
    gestureRecognizer->_actions = [_actions copy];
    
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
    self.state = UIGestureRecognizerStatePossible;
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

- (BOOL)_wantsGestureEvents
{
    return NO;
}

- (BOOL)_wantsToTrackEvent:(UIEvent *)event
{
    if(!self._view)
        return NO;
    
    if(event.type == _UIEventTypeGesture && ![self _wantsGestureEvents])
        return NO;
    
    if(event.type == UIEventTypeTouches && [self _wantsGestureEvents])
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
            [UIApp _cancelTouches:touches event:event];
            self._lastIgnoredTouch = nil;
            self._lastIgnoredEvent = nil;
        }
        
        switch (touch.phase) {
            case _UITouchPhaseGestureBegan:
            case UITouchPhaseBegan: {
                [self touchesBegan:touches withEvent:event];
                self._touches = [touches allObjects];
                break;
            }
                
            case _UITouchPhaseGestureMoved:
            case UITouchPhaseMoved: {
                [self touchesMoved:touches withEvent:event];
                self._touches = [touches allObjects];
                break;
            }
                
            case UITouchPhaseStationary: {
                break;
            }
                
            case _UITouchPhaseGestureEnd:
            case UITouchPhaseEnded: {
                [self touchesEnded:touches withEvent:event];
                self._touches = nil;
                
                [self performSelector:@selector(reset) withObject:nil afterDelay:0.0];
                
                break;
            }
                
                
            case UITouchPhaseCancelled: {
                [self touchesCancelled:touches withEvent:event];
                self._touches = nil;
                break;
            }
        }
    }
    
    if([self _wantsAutomaticActionSending])
        [self _sendActions];
}

@end
