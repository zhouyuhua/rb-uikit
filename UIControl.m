//
//  UIControl.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIControl.h"
#import <objc/message.h>

@interface UIControlInternalAction : NSObject

@property (nonatomic) UIControlEvents events;
@property (nonatomic, assign) id target;
@property (nonatomic) SEL action;

@end

@implementation UIControlInternalAction

- (BOOL)isEqual:(id)object
{
    if([object isKindOfClass:[UIControlInternalAction class]]) {
        UIControlInternalAction *other = (UIControlInternalAction *)object;
        return (other.events == self.events &&
                other.target == self.target &&
                other.action == self.action);
    }
    return NO;
}

- (NSUInteger)hash
{
    return (((NSInteger)self.events) + [self.target hash] + (NSInteger)sel_getName(self.action));
}

@end

#pragma mark -

@implementation UIControl {
    NSMutableArray *_actions;
}

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
        _actions = [NSMutableArray array];
        _enabled = YES;
    }
    
    return self;
}

//@property (nonatomic) UIControlContentVerticalAlignment contentVerticalAlignment;
//@property (nonatomic) UIControlContentHorizontalAlignment contentHorizontalAlignment;

#pragma mark -

- (UIControlState)state
{
    return self.isEnabled? UIControlStateNormal : UIControlStateDisabled;
}

#pragma mark - Tracking

- (BOOL)isTracking
{
    return NO;
}

- (BOOL)isTouchInside
{
    return NO;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    UIKitUnimplementedMethod();
    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    UIKitUnimplementedMethod();
    return NO;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    UIKitUnimplementedMethod();
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    UIKitUnimplementedMethod();
}

#pragma mark - Actions

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    UIControlInternalAction *internalAction = [UIControlInternalAction new];
    internalAction.target = target;
    internalAction.action = action;
    internalAction.events = controlEvents;
    [_actions addObject:internalAction];
}

- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    NSUInteger firstMatch = [_actions indexOfObjectPassingTest:^BOOL(UIControlInternalAction *internalAction, NSUInteger index, BOOL *stop) {
        return (internalAction.action == action &&
                internalAction.target == target &&
                (internalAction.events & controlEvents) == controlEvents);
    }];
    
    if(firstMatch) {
        [_actions removeObjectAtIndex:firstMatch];
    }
}

- (NSSet *)allTargets
{
    return [NSSet setWithArray:[_actions valueForKey:@"target"]];
}

- (UIControlEvents)allControlEvents
{
    UIControlEvents allEvents = 0;
    
    for (UIControlInternalAction *action in _actions) {
        allEvents |= action.events;
    }
    
    return allEvents;
}

- (NSArray *)actionsForTarget:(id)target forControlEvent:(UIControlEvents)controlEvent
{
    NSMutableArray *matches = [NSMutableArray array];
    
    for (UIControlInternalAction *action in _actions) {
        if(action.target == target && (action.events & controlEvent) == controlEvent) {
            [matches addObject:NSStringFromSelector(action.action)];
        }
    }
    
    return matches;
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
#pragma unused(event)
    if([target respondsToSelector:action]) {
        ((void(*)(id, SEL, id))objc_msgSend)(target, action, self);
    } else {
        UIResponder *responder = [self nextResponder];
        do {
            if([responder respondsToSelector:action]) {
                ((void(*)(id, SEL, id))objc_msgSend)(responder, action, self);
                return;
            } else {
                responder = [responder nextResponder];
            }
        } while (responder != nil);
        
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Unhandled action" userInfo:nil];
    }
}

- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents
{
    for (UIControlInternalAction *action in _actions) {
        if((action.events & controlEvents) == controlEvents)
            [self sendAction:action.action to:action.target forEvent:nil];
    }
}

@end
