//
//  UIApplication_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIApplication.h"

@class UIWindowAppKitHostView, UIEvent, UITouch;

extern UIApplication *UIApp;

@interface UIApplication () <NSApplicationDelegate> {
    struct {
        int applicationDidFinishLaunching : 1;
        
        int applicationWillFinishLaunchingWithOptions : 1;
        int applicationDidFinishLaunchingWithOptions : 1;
        
        int applicationDidReceiveMemoryWarning : 1;
        
        int applicationWillTerminate : 1;
        
        int applicationDidRegisterForRemoteNotificationsWithDeviceToken : 1;
        int applicationDidFailToRegisterForRemoteNotificationsWithError : 1;
        
        int applicationDidReceiveRemoteNotification : 1;
        int applicationDidReceiveLocalNotification : 1;
        
        int applicationDidBecomeActive : 1;
        int applicationWillResignActive : 1;
        int applicationDidEnterBackground : 1;
        int applicationWillEnterForeground : 1;
    } _delegateRespondsTo;
    
    UIEvent *_currentEvent;
    UITouch *_currentTouch;
}

@property (nonatomic, readwrite) UIWindow *keyWindow;

#pragma mark - Event Handling

- (void)_dispatchKeyEvent:(NSEvent *)event fromHostView:(UIWindowAppKitHostView *)hostView;
- (void)_dispatchMouseEvent:(NSEvent *)event fromHostView:(UIWindowAppKitHostView *)hostView;
- (void)_dispatchIdleScrollEvent:(NSEvent *)event ofPhase:(NSEventPhase)phase fromHostView:(UIWindowAppKitHostView *)hostView;

@end
