//
//  UIApplication.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#ifndef UIKit_UIApplication_h
#define UIKit_UIApplication_h 1

#import "UIResponder.h"

typedef NS_OPTIONS(NSUInteger, UIRemoteNotificationType) {
    UIRemoteNotificationTypeNone    = NSRemoteNotificationTypeNone,
    UIRemoteNotificationTypeBadge   = NSRemoteNotificationTypeBadge,
    UIRemoteNotificationTypeSound   = NSRemoteNotificationTypeSound,
    UIRemoteNotificationTypeAlert   = NSRemoteNotificationTypeAlert,
    UIRemoteNotificationTypeNewsstandContentAvailability = NSRemoteNotificationTypeNone,
};

typedef NS_ENUM(NSInteger, UIApplicationState) {
    UIApplicationStateActive,
    UIApplicationStateInactive,
    UIApplicationStateBackground
};

@protocol UIApplicationDelegate;
@class UILocalNotification;

@interface UIApplication : UIResponder

+ (UIApplication *)sharedApplication;

@property (nonatomic, assign) id <UIApplicationDelegate> delegate;

- (BOOL)openURL:(NSURL*)url;
- (BOOL)canOpenURL:(NSURL *)url;

- (void)sendEvent:(UIEvent *)event;

@property (nonatomic, readonly) UIWindow *keyWindow;
@property (nonatomic, readonly) NSArray *windows;

- (BOOL)sendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event;

#pragma mark - Multitasking

@property (nonatomic, readonly) UIApplicationState applicationState;

#pragma mark - Notifications

- (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types;
- (void)unregisterForRemoteNotifications;
- (UIRemoteNotificationType)enabledRemoteNotificationTypes;

@end

#pragma mark -

@protocol UIApplicationDelegate <NSObject>

@optional

- (void)applicationDidFinishLaunching:(UIApplication *)application;
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application;

- (void)applicationWillTerminate:(UIApplication *)application;

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;

- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)applicationWillResignActive:(UIApplication *)application;
- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationWillEnterForeground:(UIApplication *)application;

@end

#pragma mark -

UIKIT_EXTERN int UIApplicationMain(int argc, char *argv[], NSString *principalClassName, NSString *delegateClassName);

UIKIT_EXTERN NSString *const UIApplicationDidEnterBackgroundNotification;
UIKIT_EXTERN NSString *const UIApplicationWillEnterForegroundNotification;
UIKIT_EXTERN NSString *const UIApplicationDidFinishLaunchingNotification;
UIKIT_EXTERN NSString *const UIApplicationDidBecomeActiveNotification;
UIKIT_EXTERN NSString *const UIApplicationWillResignActiveNotification;
UIKIT_EXTERN NSString *const UIApplicationDidReceiveMemoryWarningNotification;
UIKIT_EXTERN NSString *const UIApplicationWillTerminateNotification;

#endif /* UIKit_UIApplication_h */
