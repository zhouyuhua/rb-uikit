//
//  UIWindow.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIWindow_Private.h"
#import "UIView_Private.h"
#import "UIViewController_Private.h"
#import "UINavigationController.h"

#import "UIApplication_Private.h"
#import "UIWindowHostNativeView.h"
#import "UITouch.h"
#import "UIGestureRecognizer_Private.h"
#import "UIImage_Private.h"

#import "UINSWindow.h"

NSString *const UIWindowDidBecomeVisibleNotification = @"UIWindowDidBecomeVisibleNotification";
NSString *const UIWindowDidBecomeHiddenNotification = @"UIWindowDidBecomeHiddenNotification";
NSString *const UIWindowDidBecomeKeyNotification = @"UIWindowDidBecomeKeyNotification";
NSString *const UIWindowDidResignKeyNotification = @"UIWindowDidResignKeyNotification";

@implementation UIWindow {
    BOOL _shouldIgnoreMouseMovedEvents;
    NSPoint _initialDragLocation;
    NSPoint _initialDragLocationOnScreen;
    NSRect _initialWindowFrameForDrag;
}

- (id)initWithFrame:(CGRect)frame nativeWindow:(NSWindow *)nativeWindow
{
    if((self = [super initWithFrame:frame])) {
        nativeWindow.delegate = self;
        self._nativeWindow = nativeWindow;
        
        self._hostNativeView = [[UIWindowHostNativeView alloc] initWithFrame:frame];
        self._hostNativeView.kitWindow = self;
        self._nativeWindow.contentView = self._hostNativeView;
        
        self.contentScaleFactor = self._nativeWindow.backingScaleFactor;
        
        self.backgroundColor = [UIColor colorWithPatternImage:UIKitImageNamed(@"UIWindowBackground", UIImageResizingModeStretch).NSImage];
        
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    NSWindow *nativeWindow = [[self.class.nativeWindowClass alloc] initWithContentRect:frame
                                                                         styleMask:self.class.nativeWindowStyleMask
                                                                           backing:NSBackingStoreBuffered
                                                                             defer:NO];
    
    [nativeWindow center];
    nativeWindow.level = NSNormalWindowLevel;
    nativeWindow.animationBehavior = NSWindowAnimationBehaviorDocumentWindow;
    
    return [self initWithFrame:frame nativeWindow:nativeWindow];
}

#pragma mark -

- (void)setWindowLevel:(UIWindowLevel)windowLevel
{
    _windowLevel = windowLevel;
    self._nativeWindow.level = CGWindowLevelForKey(windowLevel);
}

- (BOOL)isKeyWindow
{
    return (UIApp.keyWindow == self);
}

- (void)becomeKeyWindow
{
    UIApp.keyWindow = self;
    
    [self._nativeWindow becomeKeyWindow];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIWindowDidBecomeKeyNotification object:self];
    
    [self _windowDidBecomeKey];
}

- (void)resignKeyWindow
{
    [self._nativeWindow resignKeyWindow];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIWindowDidResignKeyNotification object:self];
    
    [self _windowDidResignKey];
}

#pragma mark -

- (void)makeKeyWindow
{
    [self._nativeWindow makeKeyWindow];
}

- (void)makeKeyAndVisible
{
    if(!self.rootViewController) {
        NSLog(@"*** Warning, UIWindow shown without a root view controller");
    }
    
    [self._nativeWindow orderFront:nil];
    [self._nativeWindow makeKeyWindow];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UIWindowDidBecomeVisibleNotification object:self];
}

#pragma mark -

- (void)setHidden:(BOOL)hidden
{
    if(hidden) {
        [self._nativeWindow close];
    } else {
        [self makeKeyAndVisible];
    }
}

- (BOOL)isHidden
{
    return !self._nativeWindow.isVisible;
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
    [self._nativeWindow unbind:@"title"];
    [_rootViewController.view removeFromSuperview];
    _rootViewController._rootViewController = NO;
    
    _rootViewController = rootViewController;
    
    _rootViewController._rootViewController = YES;
    [_rootViewController.view _viewWillMoveToWindow:self];
    _rootViewController.view.frame = self.bounds;
    _rootViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_rootViewController.view];
    [_rootViewController.view _viewDidMoveToWindow:self];
    
    if([_rootViewController respondsToSelector:@selector(visibleViewController)]) {
        [self._nativeWindow bind:@"title" toObject:_rootViewController withKeyPath:@"visibleViewController.navigationItem.title" options:nil];
    } else {
        [self._nativeWindow bind:@"title" toObject:_rootViewController withKeyPath:@"navigationItem.title" options:nil];
    }
    
    [self _recalculateKeyViewLoop];
}

#pragma mark - Responder Chain

- (UIResponder *)nextResponder
{
    return UIApp;
}

#pragma mark - Key View Loop

- (void)_recalculateKeyViewLoop
{
    NSMutableArray *views = [NSMutableArray array];
    
    [self _enumerateSubviews:^(UIView *subview, NSUInteger depth, BOOL *stop) {
        if(![subview isKindOfClass:[UIWindow class]] && subview.canBecomeFirstResponder && subview.canResignFirstResponder)
            [views addObject:subview];
    }];
    
    self._possibleKeyViews = views;
}

#pragma mark -

- (void)_viewWasAddedToWindow:(UIView *)view
{
    [self _recalculateKeyViewLoop];
}

- (void)_viewWasRemovedFromWindow:(UIView *)view
{
    [self _recalculateKeyViewLoop];
}

#pragma mark -

- (void)_selectNextKeyView
{
    NSUInteger indexOfKeyView = [self._possibleKeyViews indexOfObject:(UIView *)self._firstResponder];
    if(indexOfKeyView == NSNotFound) {
        if(self._possibleKeyViews.count > 0)
            [self._possibleKeyViews[0] becomeFirstResponder];
    } else if(self._possibleKeyViews.count > 0) {
        NSUInteger newKeyViewIndex = indexOfKeyView + 1;
        if(newKeyViewIndex >= self._possibleKeyViews.count) {
            newKeyViewIndex = 0;
        }
        
        if(newKeyViewIndex != indexOfKeyView) {
            [self._possibleKeyViews[newKeyViewIndex] becomeFirstResponder];
        }
    }
}

#pragma mark - Events

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
    return self._nativeWindow.undoManager;
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

- (void)windowDidChangeBackingProperties:(NSNotification *)notification
{
    CGFloat newScale = self._nativeWindow.backingScaleFactor;
    self.contentScaleFactor = newScale;
    
    [self _enumerateSubviews:^(UIView *subview, NSUInteger depth, BOOL *stop) {
        subview.contentScaleFactor = newScale;
    }];
}

@end

#pragma mark -

@implementation UIWindow (Mac)

static UIWindowNativeStyleMask _NativeWindowStyleMask = UIWindowNativeStyleMaskDefault;

+ (void)setNativeWindowStyleMask:(UIWindowNativeStyleMask)styleMask
{
    if(!UIKIT_FLAG_IS_SET(styleMask, NSBorderlessWindowMask) || UIKIT_FLAG_IS_SET(styleMask, NSTitledWindowMask)) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"Native window style mask must be borderless"];
    }
    
    _NativeWindowStyleMask = styleMask;
}

+ (UIWindowNativeStyleMask)nativeWindowStyleMask
{
    return _NativeWindowStyleMask;
}

#pragma mark -

static Class _NativeWindowClass = Nil;
+ (void)setNativeWindowClass:(Class)nativeWindowClass
{
    NSAssert([nativeWindowClass isKindOfClass:[UINSWindow class]],
             @"Cannot change native window class to non-NSWindow subclass", NSStringFromClass(nativeWindowClass));
    
    _NativeWindowClass = nativeWindowClass;
}

+ (Class)nativeWindowClass
{
    return _NativeWindowClass ?: [UINSWindow class];
}

#pragma mark -

- (void)keyDown:(UIKeyEvent *)event
{
    if(event.keyCode == UIKeyTab) {
        [self _selectNextKeyView];
    } else {
        [super keyDown:event];
    }
}

- (void)sendKeyEvent:(UIKeyEvent *)keyEvent
{
    switch (keyEvent.type) {
        case UIKeyEventTypeKeyDown:
            [self._firstResponder ?: self keyDown:keyEvent];
            break;
            
        case UIKeyEventTypeKeyUp:
            [self._firstResponder ?: self keyUp:keyEvent];
            break;
    }
}

@end
