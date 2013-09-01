//
//  UIResponder.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIResponder_Private.h"

@implementation UIResponder

- (UIResponder *)nextResponder
{
    return nil;
}

#pragma mark -

- (BOOL)canBecomeFirstResponder
{
    return NO;
}

- (BOOL)becomeFirstResponder
{
    if([self canBecomeFirstResponder]) {
        self.firstResponderManager.currentFirstResponder = self;
        return YES;
    }
    
    return NO;
}

- (BOOL)canResignFirstResponder
{
    return NO;
}

- (BOOL)resignFirstResponder
{
    if([self canResignFirstResponder]) {
        self.firstResponderManager.currentFirstResponder = [self nextResponder];
        return YES;
    }
    
    return NO;
}

#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesCancelled:touches withEvent:event];
}

#pragma mark -

- (void)motionBegan:(UIEventSubtype)motionType withEvent:(UIEvent *)event
{
    [self.nextResponder motionBegan:motionType withEvent:event];
}

- (void)motionMoved:(UIEventSubtype)motionType withEvent:(UIEvent *)event
{
    [self.nextResponder motionMoved:motionType withEvent:event];
}

- (void)motionEnded:(UIEventSubtype)motionType withEvent:(UIEvent *)event
{
    [self.nextResponder motionEnded:motionType withEvent:event];
}

#pragma mark -

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    [self.nextResponder remoteControlReceivedWithEvent:event];
}

#pragma mark -

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return ([self respondsToSelector:action] || [self.nextResponder canPerformAction:action withSender:sender]);
}

- (id)targetForAction:(SEL)action withSender:(id)sender
{
    if([self canPerformAction:action withSender:sender])
        return self;
    else
        return [self.nextResponder targetForAction:action withSender:sender];
}

- (NSUndoManager *)undoManager
{
    return nil;
}

@end

#pragma mark -

@implementation UIResponder (UIMacAdditions)

- (void)keyDown:(UIKeyEvent *)event
{
    if(self.nextResponder)
        [self.nextResponder keyDown:event];
    else
        NSBeep();
}

- (void)keyUp:(UIKeyEvent *)event
{
    [self.nextResponder keyUp:event];
}

#pragma mark -

- (void)idleScrollTouchesBegan
{
    [self.nextResponder idleScrollTouchesBegan];
}

- (void)idleScrollTouchesEnded
{
    [self.nextResponder idleScrollTouchesEnded];
}

- (void)idleScrollTouchesCanceled
{
    [self.nextResponder idleScrollTouchesCanceled];
}

@end
