//
//  UIWindow.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIWindow_Private.h"
#import "UIView_Private.h"
#import "UIViewController.h"
#import "UINavigationController.h"

#import "UIApplication_Private.h"
#import "UIWindowAppKitHostView.h"
#import "UITouch.h"
#import "UIGestureRecognizer_Private.h"

NSString *const UIWindowDidBecomeVisibleNotification = @"UIWindowDidBecomeVisibleNotification";
NSString *const UIWindowDidBecomeHiddenNotification = @"UIWindowDidBecomeHiddenNotification";
NSString *const UIWindowDidBecomeKeyNotification = @"UIWindowDidBecomeKeyNotification";
NSString *const UIWindowDidResignKeyNotification = @"UIWindowDidResignKeyNotification";

@implementation UIWindow

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
        self.underlyingWindow = [[self.class.nativeWindowClass alloc] initWithContentRect:frame
                                                                                styleMask:self.class.nativeWindowStyleMask
                                                                                  backing:NSBackingStoreBuffered
                                                                                    defer:NO];
        
        [self.underlyingWindow center];
        self.underlyingWindow.delegate = self;
        self.underlyingWindow.level = NSNormalWindowLevel;
        self.underlyingWindow.animationBehavior = NSWindowAnimationBehaviorDocumentWindow;
        
        self.hostView = [[UIWindowAppKitHostView alloc] initWithFrame:frame];
        self.hostView.kitWindow = self;
        self.underlyingWindow.contentView = self.hostView;
        
        [self.underlyingWindow setAutorecalculatesContentBorderThickness:NO forEdge:NSMaxYEdge];
        [self.underlyingWindow setContentBorderThickness:50.0 forEdge:NSMaxYEdge];
    }
    
    return self;
}
#pragma mark -

- (void)setWindowLevel:(UIWindowLevel)windowLevel
{
    _windowLevel = windowLevel;
    self.underlyingWindow.level = CGWindowLevelForKey(windowLevel);
}

- (BOOL)isKeyWindow
{
    return (UIApp.keyWindow == self);
}

- (void)becomeKeyWindow
{
    UIApp.keyWindow = self;
    
    [self.underlyingWindow becomeKeyWindow];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIWindowDidBecomeKeyNotification object:self];
}

- (void)resignKeyWindow
{
    [self.underlyingWindow resignKeyWindow];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIWindowDidResignKeyNotification object:self];
}

#pragma mark -

- (void)makeKeyWindow
{
    [self.underlyingWindow makeKeyWindow];
}

- (void)makeKeyAndVisible
{
    if(!self.rootViewController) {
        NSLog(@"*** Warning, UIWindow shown without a root view controller");
    }
    
    [self.underlyingWindow orderFront:nil];
    [self.underlyingWindow makeKeyWindow];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UIWindowDidBecomeVisibleNotification object:self];
}

#pragma mark -

- (void)setHidden:(BOOL)hidden
{
    if(hidden) {
        [self.underlyingWindow close];
    } else {
        [self makeKeyAndVisible];
    }
}

- (BOOL)isHidden
{
    return !self.underlyingWindow.isVisible;
}

#pragma mark -

- (CGPoint)convertPoint:(CGPoint)point toWindow:(UIWindow *)window
{
    return [self.layer convertPoint:point toLayer:window.layer];
}

- (CGPoint)convertPoint:(CGPoint)point fromWindow:(UIWindow *)window
{
    return [self.layer convertPoint:point fromLayer:window.layer];
}

- (CGRect)convertRect:(CGRect)rect toWindow:(UIWindow *)window
{
    return [self.layer convertRect:rect toLayer:window.layer];
}

- (CGRect)convertRect:(CGRect)rect fromWindow:(UIWindow *)window
{
    return [self.layer convertRect:rect fromLayer:window.layer];
}

#pragma mark - Root View Controller

- (void)setRootViewController:(UIViewController *)rootViewController
{
    [self.underlyingWindow unbind:@"title"];
    [_rootViewController.view removeFromSuperview];
    
    _rootViewController = rootViewController;
    self.nextResponder = _rootViewController;
    
    [_rootViewController.view _viewWillMoveToWindow:self];
    _rootViewController.view.frame = self.bounds;
    _rootViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_rootViewController.view];
    [_rootViewController.view _viewDidMoveToWindow:self];
    
    if([_rootViewController respondsToSelector:@selector(visibleViewController)]) {
        [self.underlyingWindow bind:@"title" toObject:_rootViewController withKeyPath:@"visibleViewController.navigationItem.title" options:nil];
    } else {
        [self.underlyingWindow bind:@"title" toObject:_rootViewController withKeyPath:@"navigationItem.title" options:nil];
    }
}

#pragma mark - Events

- (void)_handleKeyUp:(NSEvent *)event
{
    
}

- (void)_handleKeyDown:(NSEvent *)event
{
    
}

- (void)sendEvent:(UIEvent *)event
{
    if(event.type == UIEventTypeTouches) {
        for (UITouch *touch in [event allTouches]) {
            for (UIGestureRecognizer *gestureRecognizer in touch.gestureRecognizers) {
                [gestureRecognizer _handleEvent:event];
            }
        }
        
        NSSet *touches = [event touchesForWindow:self];
        for (UITouch *touch in touches) {
            switch (touch.phase) {
                case UITouchPhaseBegan: {
                    [touch.view touchesBegan:touches withEvent:event];
                    break;
                }
                    
                case UITouchPhaseMoved: {
                    [touch.view touchesMoved:touches withEvent:event];
                    break;
                }
                    
                case UITouchPhaseStationary: {
                    break;
                }
                    
                case UITouchPhaseEnded: {
                    [touch.view touchesEnded:touches withEvent:event];
                    break;
                }
                    
                case UITouchPhaseCancelled: {
                    [touch.view touchesCancelled:touches withEvent:event];
                    break;
                }
                    
                case _UITouchPhaseGestureBegan:
                case _UITouchPhaseGestureMoved:
                case _UITouchPhaseGestureEnd: {
                    //Shut up the compiler.
                    break;
                }
            }
        }
    } else if(event.type == UIEventTypeRemoteControl) {
        [self remoteControlReceivedWithEvent:event];
    } else if(event.type == _UIEventTypeGesture) {
        for (UITouch *touch in [event allTouches]) {
            for (UIGestureRecognizer *gestureRecognizer in touch.gestureRecognizers) {
                [gestureRecognizer _handleEvent:event];
            }
        }
    }
}

#pragma mark - Properties

- (NSUndoManager *)undoManager
{
    return self.underlyingWindow.undoManager;
}

#pragma mark - <UIFirstResponderManager>

@synthesize firstResponder = _firstResponder;
- (void)setFirstResponder:(UIResponder *)firstResponder
{
    _firstResponder = firstResponder;
}

#pragma mark - <NSWindowDelegate>

- (void)windowDidBecomeMain:(NSNotification *)notification
{
    [self becomeKeyWindow];
}

- (void)windowDidResignMain:(NSNotification *)notification
{
    [self resignKeyWindow];
}

- (void)windowWillClose:(NSNotification *)notification
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:UIWindowDidBecomeHiddenNotification object:self];
    }];
}

@end

#pragma mark -

@implementation UIWindow (Mac)

static NSUInteger _NativeWindowStyleMask = (NSTitledWindowMask |
                                            NSTexturedBackgroundWindowMask |
                                            NSClosableWindowMask |
                                            NSMiniaturizableWindowMask |
                                            NSResizableWindowMask);

+ (void)setNativeWindowStyleMask:(NSUInteger)styleMask
{
    _NativeWindowStyleMask = styleMask;
}

+ (NSUInteger)nativeWindowStyleMask
{
    return _NativeWindowStyleMask;
}

#pragma mark -

static Class _NativeWindowClass = Nil;
+ (void)setNativeWindowClass:(Class)nativeWindowClass
{
    NSAssert([nativeWindowClass isKindOfClass:[NSWindow class]],
             @"Cannot change native window class to non-NSWindow subclass", NSStringFromClass(nativeWindowClass));
    
    _NativeWindowClass = nativeWindowClass;
}

+ (Class)nativeWindowClass
{
    return _NativeWindowClass ?: [NSWindow class];
}

@end
