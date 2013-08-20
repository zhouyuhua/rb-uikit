//
//  UIApplication.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIApplication_Private.h"
#import <objc/message.h>
#import "UIEvent.h"
#import "UITouch.h"
#import "UIWindow_Private.h"

#import "UIWindowAppKitHostView.h"
#import "UIEvent_Private.h"
#import "UIKeyEvent_Private.h"
#import "UITouch_Private.h"
#import "UIGestureRecognizer_Private.h"

UIApplication *UIApp = nil;

@implementation UIApplication

static Class _SharedApplicationClass = Nil;
+ (void)_setSharedApplicationClass:(Class)class
{
    if(class && ![class isKindOfClass:[UIApplication class]]) {
        [NSException raise:NSInternalInconsistencyException format:@"UIApplicationMain called with non-UIApplication descended principle class name."];
    }
    
    _SharedApplicationClass = class;
}

+ (Class)_sharedApplicationClass
{
    return _SharedApplicationClass ?: [UIApplication class];
}

+ (UIApplication *)sharedApplication
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIApp = [[self _sharedApplicationClass] new];
    });
    
    return UIApp;
}

#pragma mark - Properties

- (void)setDelegate:(id <UIApplicationDelegate>)delegate
{
    _delegate = delegate;
    
    _delegateRespondsTo.applicationDidFinishLaunching = [delegate respondsToSelector:@selector(applicationDidFinishLaunching:)];
    
    _delegateRespondsTo.applicationWillFinishLaunchingWithOptions = [delegate respondsToSelector:@selector(application:willFinishLaunchingWithOptions:)];
    _delegateRespondsTo.applicationDidFinishLaunchingWithOptions = [delegate respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)];
    
    _delegateRespondsTo.applicationDidReceiveMemoryWarning = [delegate respondsToSelector:@selector(applicationDidReceiveMemoryWarning:)];
    _delegateRespondsTo.applicationWillTerminate = [delegate respondsToSelector:@selector(applicationWillTerminate:)];
    
    _delegateRespondsTo.applicationDidRegisterForRemoteNotificationsWithDeviceToken = [delegate respondsToSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)];
    _delegateRespondsTo.applicationDidFailToRegisterForRemoteNotificationsWithError = [delegate respondsToSelector:@selector(application:didFailToRegisterForRemoteNotificationsWithError:)];
    
    _delegateRespondsTo.applicationDidReceiveRemoteNotification = [delegate respondsToSelector:@selector(application:didReceiveRemoteNotification:)];
    _delegateRespondsTo.applicationDidReceiveLocalNotification = [delegate respondsToSelector:@selector(application:didReceiveLocalNotification:)];
    
    _delegateRespondsTo.applicationDidBecomeActive = [delegate respondsToSelector:@selector(applicationDidBecomeActive:)];
    _delegateRespondsTo.applicationWillResignActive = [delegate respondsToSelector:@selector(applicationWillResignActive:)];
    _delegateRespondsTo.applicationDidEnterBackground = [delegate respondsToSelector:@selector(applicationDidEnterBackground:)];
    _delegateRespondsTo.applicationWillEnterForeground = [delegate respondsToSelector:@selector(applicationWillEnterForeground:)];
}

- (UIApplicationState)applicationState
{
    if([NSApp isActive])
        return UIApplicationStateActive;
    else
        return UIApplicationStateInactive;
}

#pragma mark - Opening URLs

- (BOOL)openURL:(NSURL *)url
{
    return [[NSWorkspace sharedWorkspace] openURL:url];
}

- (BOOL)canOpenURL:(NSURL *)url
{
    return (LSGetApplicationForURL((__bridge CFURLRef)url, kLSRolesAll, NULL, NULL) != kLSApplicationNotFoundErr);
}

#pragma mark - Event Handling

- (void)sendEvent:(UIEvent *)event
{
    for (UITouch *touch in [event allTouches]) {
        [touch.window sendEvent:event];
    }
}

- (BOOL)sendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event
{
    if(!target)
        target = [self.keyWindow targetForAction:action withSender:sender];
    
    if(target) {
        ((void(*)(id self, SEL _cmd, id sender))objc_msgSend)(target, action, sender);
        
        return YES;
    }
    
    return NO;
}

//@property (nonatomic, readonly) NSArray *windows;

#pragma mark - Event Handling

static NSArray *UIGestureRecognizersForView(UIView *view)
{
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    
    while (view != nil) {
        [gestureRecognizers addObjectsFromArray:view.gestureRecognizers];
        view = view.superview;
    }
    
    return gestureRecognizers;
}

static BOOL ScrollWheelEventIsContinuous(NSEvent *event)
{
    return CGEventGetIntegerValueField(event.CGEvent, kCGScrollWheelEventIsContinuous);
}

static CGPoint ScrollWheelEventGetDelta(NSEvent *event)
{
    CGEventRef underlyingEvent = [event CGEvent];
    CGPoint delta = CGPointMake(-CGEventGetDoubleValueField(underlyingEvent, kCGScrollWheelEventFixedPtDeltaAxis2),
                                -CGEventGetDoubleValueField(underlyingEvent, kCGScrollWheelEventFixedPtDeltaAxis1));
    
    if(!ScrollWheelEventIsContinuous(event)) {
        CGEventSourceRef underlyingEventSource = CGEventCreateSourceFromEvent(underlyingEvent);
        double pixelsPerLine = CGEventSourceGetPixelsPerLine(underlyingEventSource);
        CFRelease(underlyingEventSource);
        
        delta.x *= pixelsPerLine;
        delta.y *= pixelsPerLine;
    }
    
    return delta;
}

- (void)_beginTrackingNativeMouseEvent:(NSEvent *)event fromHostView:(UIWindowAppKitHostView *)hostView
{
    _currentEvent = [UIEvent new];
    _currentEvent.type = UIEventTypeTouches;
    _currentEvent.subtype = UIEventSubtypeNone;
    _currentEvent.timestamp = event.timestamp;
    
    _currentTouch = [UITouch new];
    _currentTouch.timestamp = event.timestamp;
    _currentTouch.tapCount = event.clickCount;
    _currentTouch.window = hostView.kitWindow;
    _currentTouch.locationInWindow = [hostView convertPoint:event.locationInWindow fromView:nil];
    _currentTouch.phase = UITouchPhaseBegan;
    
    [_currentEvent.touches addObject:_currentTouch];
    
    _currentTouch.view = [hostView.kitWindow hitTest:_currentTouch.locationInWindow withEvent:_currentEvent];
    
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    for (UIGestureRecognizer *gestureRecognizer in UIGestureRecognizersForView(_currentTouch.view)) {
        if([gestureRecognizer _wantsToTrackEvent:_currentEvent]) {
            [gestureRecognizers addObject:gestureRecognizer];
        }
    }
    _currentTouch.gestureRecognizers = gestureRecognizers;
}

- (void)_updateTrackingPhase:(UITouchPhase)phase withNativeMouseEvent:(NSEvent *)event fromHostView:(UIWindowAppKitHostView *)hostView
{
    _currentEvent.timestamp = event.timestamp;
    
    _currentTouch.timestamp = event.timestamp;
    _currentTouch.previousLocationInWindow = _currentTouch.locationInWindow;
    _currentTouch.locationInWindow = [hostView convertPoint:event.locationInWindow fromView:nil];
    _currentTouch.delta = CGPointMake(event.deltaX, event.deltaY);
    _currentTouch.phase = phase;
}

#pragma mark -

- (void)_beginTrackingNativeGestureEvent:(NSEvent *)event fromHostView:(UIWindowAppKitHostView *)hostView
{
    _currentTouch = [UITouch new];
    _currentTouch.timestamp = event.timestamp;
    _currentTouch.tapCount = 1;
    _currentTouch.window = hostView.kitWindow;
    _currentTouch.locationInWindow = [hostView convertPoint:event.locationInWindow fromView:nil];
    _currentTouch.phase = _UITouchPhaseGestureBegan;
    
    _currentEvent = [UIEvent new];
    _currentEvent.type = _UIEventTypeGesture;
    _currentEvent.subtype = UIEventSubtypeNone;
    _currentEvent.timestamp = event.timestamp;
    [_currentEvent.touches addObject:_currentTouch];
    
    _currentTouch.view = [hostView.kitWindow hitTest:_currentTouch.locationInWindow withEvent:_currentEvent];
    
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    for (UIGestureRecognizer *gestureRecognizer in UIGestureRecognizersForView(_currentTouch.view)) {
        if([gestureRecognizer _wantsToTrackEvent:_currentEvent])
            [gestureRecognizers addObject:gestureRecognizer];
    }
    _currentTouch.gestureRecognizers = gestureRecognizers;
}

- (void)_trackingUpdateForNativeGestureEvent:(NSEvent *)event fromHostView:(UIWindowAppKitHostView *)hostView
{
    _currentEvent.timestamp = event.timestamp;
    
    _currentTouch.timestamp = event.timestamp;
    CGPoint locationInWindow = _currentTouch.locationInWindow;
    _currentTouch.previousLocationInWindow = locationInWindow;
    
    CGPoint delta = ScrollWheelEventGetDelta(event);
    locationInWindow.x += delta.x;
    locationInWindow.y += delta.y;
    
    _currentTouch.locationInWindow = locationInWindow;
    _currentTouch.delta = delta;
    _currentTouch.phase = _UITouchPhaseGestureMoved;
}

- (void)_endTrackingNativeGestureEvent:(NSEvent *)event fromHostview:(UIWindowAppKitHostView *)hostView
{
    _currentEvent.timestamp = event.timestamp;
    
    _currentTouch.timestamp = event.timestamp;
    CGPoint locationInWindow = _currentTouch.locationInWindow;
    _currentTouch.previousLocationInWindow = locationInWindow;
    
    CGPoint delta = ScrollWheelEventGetDelta(event);
    locationInWindow.x += delta.x;
    locationInWindow.y += delta.y;
    
    _currentTouch.locationInWindow = locationInWindow;
    _currentTouch.delta = delta;
    _currentTouch.phase = _UITouchPhaseGestureEnd;
}

#pragma mark -

- (void)_dispatchKeyEvent:(NSEvent *)event fromHostView:(UIWindowAppKitHostView *)hostView
{
    switch (event.type) {
        case NSKeyDown: {
            [hostView.kitWindow keyDown:[[UIKeyEvent alloc] initWithNSEvent:event]];
            
            break;
        }
            
        case NSKeyUp:
            [hostView.kitWindow keyUp:[[UIKeyEvent alloc] initWithNSEvent:event]];
            break;
    }
}

- (void)_dispatchMouseEvent:(NSEvent *)event fromHostView:(UIWindowAppKitHostView *)hostView
{
    switch (event.type) {
        case NSLeftMouseDown: {
            [self _beginTrackingNativeMouseEvent:event fromHostView:hostView];
            [self sendEvent:_currentEvent];
            
            break;
        }
            
        case NSLeftMouseDragged: {
            [self _updateTrackingPhase:UITouchPhaseMoved withNativeMouseEvent:event fromHostView:hostView];
            [self sendEvent:_currentEvent];
            
            break;
        }
            
        case NSLeftMouseUp: {
            [self _updateTrackingPhase:UITouchPhaseEnded withNativeMouseEvent:event fromHostView:hostView];
            [self sendEvent:_currentEvent];
            
            _currentEvent = nil;
            _currentTouch = nil;
            
            break;
        }
            
        case NSEventTypeBeginGesture: {
            [self _beginTrackingNativeGestureEvent:event fromHostView:hostView];
            [self sendEvent:_currentEvent];
            
            break;
        }
            
        case NSScrollWheel: {
            if(!ScrollWheelEventIsContinuous(event)) {
                [self _beginTrackingNativeGestureEvent:event fromHostView:hostView];
                _currentEvent._isPartOfBurst = YES;
                _currentTouch._isFromOldStyleScrollWheel = YES;
                [self sendEvent:_currentEvent];
                
                [self _trackingUpdateForNativeGestureEvent:event fromHostView:hostView];
                [self sendEvent:_currentEvent];
                
                [self _endTrackingNativeGestureEvent:event fromHostview:hostView];
                [self sendEvent:_currentEvent];
                
                _currentEvent = nil;
                _currentTouch = nil;
            } else {
                [self _trackingUpdateForNativeGestureEvent:event fromHostView:hostView];
                [self sendEvent:_currentEvent];
            }
            
            break;
        }
            
        case NSEventTypeEndGesture: {
            [self _endTrackingNativeGestureEvent:event fromHostview:hostView];
            [self sendEvent:_currentEvent];
            
            _currentEvent = nil;
            _currentTouch = nil;
            
            break;
        }
    }
}

#pragma mark - Notifications

- (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types
{
    [NSApp registerForRemoteNotificationTypes:types];
}

- (void)unregisterForRemoteNotifications
{
    [NSApp unregisterForRemoteNotifications];
}

- (UIRemoteNotificationType)enabledRemoteNotificationTypes
{
    return [NSApp enabledRemoteNotificationTypes];
}

#pragma mark - <NSApplicationDelegate>

- (void)applicationWillFinishLaunching:(NSNotification *)notification
{
    if(_delegateRespondsTo.applicationWillFinishLaunchingWithOptions)
        [_delegate application:self willFinishLaunchingWithOptions:@{}];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    if(_delegateRespondsTo.applicationDidFinishLaunching)
        [_delegate applicationDidFinishLaunching:self];
    
    if(_delegateRespondsTo.applicationDidFinishLaunchingWithOptions)
        [_delegate application:self didFinishLaunchingWithOptions:@{}];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidFinishLaunchingNotification object:self];
}

#pragma mark -

- (void)applicationWillResignActive:(NSNotification *)notification
{
    if(_delegateRespondsTo.applicationWillResignActive)
        [_delegate applicationWillResignActive:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillResignActiveNotification object:self];
}

- (void)applicationDidResignActive:(NSNotification *)notification
{
    if(_delegateRespondsTo.applicationDidEnterBackground)
        [_delegate applicationDidEnterBackground:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidEnterBackgroundNotification object:self];
}

- (void)applicationWillBecomeActive:(NSNotification *)notification
{
    if(_delegateRespondsTo.applicationWillEnterForeground)
        [_delegate applicationWillEnterForeground:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillEnterForegroundNotification object:self];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    if(_delegateRespondsTo.applicationDidBecomeActive)
        [_delegate applicationDidBecomeActive:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification object:self];
}

#pragma mark -

- (void)applicationWillTerminate:(NSNotification *)notification
{
    if(_delegateRespondsTo.applicationWillTerminate)
        [_delegate applicationWillTerminate:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillTerminateNotification object:self];
}

#pragma mark -

- (void)application:(NSApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    if(_delegateRespondsTo.applicationDidFailToRegisterForRemoteNotificationsWithError)
        [_delegate application:self didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(NSApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    if(_delegateRespondsTo.applicationDidRegisterForRemoteNotificationsWithDeviceToken)
        [_delegate application:self didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(NSApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if(_delegateRespondsTo.applicationDidReceiveRemoteNotification)
        [_delegate application:self didReceiveRemoteNotification:userInfo];
}

#pragma mark -

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)application
{
    return YES;
}

@end

#pragma mark -

int UIApplicationMain(int argc, char *argv[], NSString *principalClassName, NSString *delegateClassName)
{
    [UIApplication _setSharedApplicationClass:NSClassFromString(principalClassName)];
    UIApplication *app = [UIApplication sharedApplication];
    
    id <UIApplicationDelegate> delegate = [NSClassFromString(delegateClassName) new];
    app.delegate = delegate;
    
    [NSApplication sharedApplication].delegate = app;
    
    return NSApplicationMain(argc, (const char **)argv);
}

NSString *const UIApplicationDidEnterBackgroundNotification = @"UIApplicationDidEnterBackgroundNotification";
NSString *const UIApplicationWillEnterForegroundNotification = @"UIApplicationWillEnterForegroundNotification";
NSString *const UIApplicationDidFinishLaunchingNotification = @"UIApplicationDidFinishLaunchingNotification";
NSString *const UIApplicationDidBecomeActiveNotification = @"UIApplicationDidBecomeActiveNotification";
NSString *const UIApplicationWillResignActiveNotification = @"UIApplicationWillResignActiveNotification";
NSString *const UIApplicationDidReceiveMemoryWarningNotification = @"UIApplicationDidReceiveMemoryWarningNotification";
NSString *const UIApplicationWillTerminateNotification = @"UIApplicationWillTerminateNotification";
