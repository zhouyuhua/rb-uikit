//
//  UIHostView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/30/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIWindowAppKitHostView.h"
#import "UIColor.h"
#import "UIWindow_Private.h"
#import "UIEvent_Private.h"
#import "UITouch_Private.h"
#import "UIApplication_Private.h"
#import "UIGestureRecognizer_Private.h"

@implementation UIWindowAppKitHostView {
    UIEvent *_currentEvent;
    UITouch *_currentTouch;
}

- (id)initWithFrame:(NSRect)frame
{
    if((self = [super initWithFrame:frame])) {
        self.wantsLayer = YES;
    }
    
    return self;
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

- (BOOL)mouseDownCanMoveWindow
{
    return NO;
}

#pragma mark -

- (void)keyUp:(NSEvent *)event
{
    [_kitWindow _handleKeyUp:event];
}

- (void)keyDown:(NSEvent *)event
{
    [_kitWindow _handleKeyDown:event];
}

#pragma mark -

- (void)mouseUp:(NSEvent *)event
{
    [UIApp _dispatchMouseEvent:event fromHostView:self];
}

- (void)mouseDragged:(NSEvent *)event
{
    [UIApp _dispatchMouseEvent:event fromHostView:self];
}

- (void)mouseDown:(NSEvent *)event
{
    [UIApp _dispatchMouseEvent:event fromHostView:self];
}

#pragma mark -

- (void)beginGestureWithEvent:(NSEvent *)event
{
    [UIApp _dispatchMouseEvent:event fromHostView:self];
}

- (void)scrollWheel:(NSEvent *)event
{
    [UIApp _dispatchMouseEvent:event fromHostView:self];
}

- (void)endGestureWithEvent:(NSEvent *)event
{
    [UIApp _dispatchMouseEvent:event fromHostView:self];
}

@end
