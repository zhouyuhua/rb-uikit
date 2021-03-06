//
//  UIHostView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/30/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIWindowHostNativeView.h"
#import "UIColor.h"
#import "UIWindow_Private.h"
#import "UIEvent_Private.h"
#import "UIKeyEvent_Private.h"
#import "UITouch_Private.h"
#import "UIApplication_Private.h"
#import "UIGestureRecognizer_Private.h"

#import "UIView+UIDraggingDestination.h"

@implementation UIWindowHostNativeView {
    UIEvent *_currentEvent;
    UITouch *_currentTouch;
}

- (id)initWithFrame:(NSRect)frame
{
    if((self = [super initWithFrame:frame])) {
        self.wantsLayer = YES;
        self.acceptsTouchEvents = YES;
        self.wantsRestingTouches = YES;
        
        [self registerForDraggedTypes:@[ (id)kUTTypeItem ]]; //We want it all
    }
    
    return self;
}

#pragma mark - Forwarding

- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)item
{
    return ([_kitWindow targetForAction:item.action withSender:nil] != nil);
}

- (BOOL)respondsToSelector:(SEL)selector
{
    return [super respondsToSelector:selector] || ([_kitWindow targetForAction:selector withSender:nil] != nil);
}

- (id)forwardingTargetForSelector:(SEL)selector
{
    return [_kitWindow targetForAction:selector withSender:nil];
}

#pragma mark - Properties

- (BOOL)isFlipped
{
    return YES;
}

- (void)setKitWindow:(UIWindow *)kitWindow
{
    _kitWindow = kitWindow;
    self.layer = _kitWindow.layer ?: [CALayer layer];
    self.layer.needsDisplayOnBoundsChange = YES;
}

#pragma mark - Events

- (BOOL)acceptsFirstResponder
{
    return YES;
}

#pragma mark -

- (void)keyUp:(NSEvent *)event
{
    if(![UIApp _dispatchKeyEvent:event fromHostView:self])
        [super keyUp:event];
}

- (void)keyDown:(NSEvent *)event
{
    if(![UIApp _dispatchKeyEvent:event fromHostView:self])
        [super keyDown:event];
}

#pragma mark -

- (void)mouseUp:(NSEvent *)event
{
    if(![UIApp _dispatchMouseEvent:event fromHostView:self])
        [super mouseUp:event];
}

- (void)mouseDragged:(NSEvent *)event
{
    if(![UIApp _dispatchMouseEvent:event fromHostView:self])
        [super mouseDragged:event];
}

- (void)mouseDown:(NSEvent *)event
{
    if(![UIApp _dispatchMouseEvent:event fromHostView:self])
        [super mouseDown:event];
}

#pragma mark -

- (void)beginGestureWithEvent:(NSEvent *)event
{
    if(![UIApp _dispatchMouseEvent:event fromHostView:self])
        [super beginGestureWithEvent:event];
}

- (void)scrollWheel:(NSEvent *)event
{
    if(![UIApp _dispatchMouseEvent:event fromHostView:self])
        [super scrollWheel:event];
}

- (void)endGestureWithEvent:(NSEvent *)event
{
    if(![UIApp _dispatchMouseEvent:event fromHostView:self])
        [super endGestureWithEvent:event];
}

#pragma mark -

- (void)touchesBeganWithEvent:(NSEvent *)event
{
    NSSet *matchingTouches = [event touchesMatchingPhase:NSTouchPhaseBegan inView:self];
    if(matchingTouches.count == 2) {
        [UIApp _dispatchIdleScrollEvent:event ofPhase:NSEventPhaseBegan fromHostView:self];
    }
}

- (void)touchesEndedWithEvent:(NSEvent *)event
{
    NSSet *matchingTouches = [event touchesMatchingPhase:NSTouchPhaseEnded inView:self];
    if(matchingTouches.count != 0) {
        [UIApp _dispatchIdleScrollEvent:event ofPhase:NSEventPhaseEnded fromHostView:self];
    }
}

- (void)touchesCancelledWithEvent:(NSEvent *)event
{
    NSSet *matchingTouches = [event touchesMatchingPhase:NSTouchPhaseCancelled inView:self];
    if(matchingTouches.count != 0) {
        [UIApp _dispatchIdleScrollEvent:event ofPhase:NSEventPhaseCancelled fromHostView:self];
    }
}

#pragma mark -

- (NSMenu *)menuForEvent:(NSEvent *)event
{
    return [UIApp _dispatchForMenuForEvent:event fromHostView:self];
}

#pragma mark - Drag and Drop

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    NSPoint locationInView = [self convertPointFromBase:[sender draggingLocation]];
    UIView *targetView = [_kitWindow hitTest:locationInView withEvent:nil];
    if(targetView && ([[sender draggingPasteboard] availableTypeFromArray:[targetView registeredDragTypes]] != nil)) {
        UIDraggingInfo *info = [[UIDraggingInfo alloc] initWithNSDraggingInfo:sender window:_kitWindow];
        return [targetView draggingEntered:info];
    } else {
        return NSDragOperationNone;
    }
}

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender
{
    NSPoint locationInView = [self convertPointFromBase:[sender draggingLocation]];
    UIView *targetView = [_kitWindow hitTest:locationInView withEvent:nil];
    if(targetView && ([[sender draggingPasteboard] availableTypeFromArray:[targetView registeredDragTypes]] != nil)) {
        UIDraggingInfo *info = [[UIDraggingInfo alloc] initWithNSDraggingInfo:sender window:_kitWindow];
        return [targetView draggingUpdated:info];
    } else {
        return NSDragOperationNone;
    }
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    NSPoint locationInView = [self convertPointFromBase:[sender draggingLocation]];
    UIView *targetView = [_kitWindow hitTest:locationInView withEvent:nil];
    if(targetView && ([[sender draggingPasteboard] availableTypeFromArray:[targetView registeredDragTypes]] != nil)) {
        UIDraggingInfo *info = [[UIDraggingInfo alloc] initWithNSDraggingInfo:sender window:_kitWindow];
        [targetView draggingExited:info];
    }
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
    NSPoint locationInView = [self convertPointFromBase:[sender draggingLocation]];
    UIView *targetView = [_kitWindow hitTest:locationInView withEvent:nil];
    if(targetView && ([[sender draggingPasteboard] availableTypeFromArray:[targetView registeredDragTypes]] != nil)) {
        UIDraggingInfo *info = [[UIDraggingInfo alloc] initWithNSDraggingInfo:sender window:_kitWindow];
        return [targetView prepareForDragOperation:info];
    } else {
        return NO;
    }
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSPoint locationInView = [self convertPointFromBase:[sender draggingLocation]];
    UIView *targetView = [_kitWindow hitTest:locationInView withEvent:nil];
    if(targetView && ([[sender draggingPasteboard] availableTypeFromArray:[targetView registeredDragTypes]] != nil)) {
        UIDraggingInfo *info = [[UIDraggingInfo alloc] initWithNSDraggingInfo:sender window:_kitWindow];
        return [targetView performDragOperation:info];
    } else {
        return NO;
    }
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender
{
    NSPoint locationInView = [self convertPointFromBase:[sender draggingLocation]];
    UIView *targetView = [_kitWindow hitTest:locationInView withEvent:nil];
    if(targetView && ([[sender draggingPasteboard] availableTypeFromArray:[targetView registeredDragTypes]] != nil)) {
        UIDraggingInfo *info = [[UIDraggingInfo alloc] initWithNSDraggingInfo:sender window:_kitWindow];
        [targetView concludeDragOperation:info];
    }
}

- (void)draggingEnded:(id <NSDraggingInfo>)sender
{
    NSPoint locationInView = [self convertPointFromBase:[sender draggingLocation]];
    UIView *targetView = [_kitWindow hitTest:locationInView withEvent:nil];
    if(targetView && ([[sender draggingPasteboard] availableTypeFromArray:[targetView registeredDragTypes]] != nil)) {
        UIDraggingInfo *info = [[UIDraggingInfo alloc] initWithNSDraggingInfo:sender window:_kitWindow];
        [targetView draggingEnded:info];
    }
}

@end
