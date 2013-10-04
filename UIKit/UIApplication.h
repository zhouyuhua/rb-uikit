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
#import "UIStatusBar.h"
#import "UIDevice.h"

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

typedef NS_ENUM(NSUInteger, UIBackgroundRefreshStatus) {
    UIBackgroundRefreshStatusRestricted,
    UIBackgroundRefreshStatusDenied,
    UIBackgroundRefreshStatusAvailable
};

typedef NSUInteger UIBackgroundTaskIdentifier;

typedef NS_ENUM(NSInteger, UIUserInterfaceLayoutDirection) {
    UIUserInterfaceLayoutDirectionLeftToRight = NSUserInterfaceLayoutDirectionLeftToRight,
    UIUserInterfaceLayoutDirectionRightToLeft = NSUserInterfaceLayoutDirectionRightToLeft,
};

@protocol UIApplicationDelegate;
@class UILocalNotification;

@interface UIApplication : UIResponder

+ (UIApplication *)sharedApplication;

@property (nonatomic, assign) id <UIApplicationDelegate> delegate;

- (BOOL)openURL:(NSURL*)url;
- (BOOL)canOpenURL:(NSURL *)url;

#pragma mark - Windows

@property (nonatomic, readonly) UIWindow *keyWindow;
@property (nonatomic, readonly) NSArray *windows;

#pragma mark - Event Handling

- (void)sendEvent:(UIEvent *)event;

- (BOOL)sendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event;

#pragma mark -

- (void)beginIgnoringInteractionEvents;
- (void)endIgnoringInteractionEvents;
- (BOOL)isIgnoringInteractionEvents;

#pragma mark -

@property (nonatomic) BOOL applicationSupportsShakeToEdit;

#pragma mark - Managing the Default Interface Orientations

- (UIDeviceOrientation)supportedInterfaceOrientationsForWindow:(UIWindow *)window;

#pragma mark - Managing App Activity

@property (nonatomic, getter=isIdleTimerDisabled) BOOL idleTimerDisabled;

#pragma mark - Multitasking

@property (nonatomic, readonly) UIApplicationState applicationState;

#pragma mark -

@property (nonatomic, readonly) NSTimeInterval backgroundTimeRemaining;
@property (nonatomic, readonly) UIBackgroundRefreshStatus backgroundRefreshStatus;

#pragma mark -

- (void)setMinimumBackgroundFetchInterval:(NSTimeInterval)timeInterval;
- (UIBackgroundTaskIdentifier)beginBackgroundTaskWithName:(NSString *)name expirationHandler:(void(^)(void))handler;
- (UIBackgroundTaskIdentifier)beginBackgroundTaskWithExpirationHandler:(void(^)(void))handler;
- (void)endBackgroundTask:(UIBackgroundTaskIdentifier)identifier;
- (void)setKeepAliveTimeout:(NSTimeInterval)timeInterval handler:(void(^)(void))handler;
- (void)clearKeepAliveTimeout;

#pragma mark - Determining the Availability of Protected Content

@property (nonatomic, readonly, getter=protectedDataAvailable) BOOL protectedDataAvailable;

#pragma mark - Registering for Remote Control Events

- (void)beginReceivingRemoteControlEvents;
- (void)endReceivingRemoteControlEvents;

#pragma mark - Managing Status Bar Orientation

- (void)setStatusBarOrientation:(UIDeviceOrientation)orientation animated:(BOOL)animate;
@property (nonatomic) UIDeviceOrientation statusBarOrientation;
@property (nonatomic) NSTimeInterval statusBarOrientationAnimationDuration;

#pragma mark - Controlling App Appearance

- (void)setStatusBarHidden:(BOOL)hidden withAnimation:(BOOL)animate;
@property (nonatomic, getter=isStatusBarHidden) BOOL statusBarHidden;

- (void)setStatusBarStyle:(UIStatusBarStyle)style animated:(BOOL)animate;
@property (nonatomic) UIStatusBarStyle statusBarStyle;

@property (nonatomic, readonly) CGRect statusBarFrame;
@property (nonatomic, getter=isNetworkActivityIndicatorVisible) BOOL networkActivityIndicatorVisible;
@property (nonatomic) NSInteger applicationIconBadgeNumber;
@property (nonatomic, readonly) UIUserInterfaceLayoutDirection userInterfaceLayoutDirection;

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

UIKIT_EXTERN NSTimeInterval const UIApplicationBackgroundFetchIntervalMinimum;
UIKIT_EXTERN NSTimeInterval const UIApplicationBackgroundFetchIntervalNever;

UIKIT_EXTERN UIBackgroundTaskIdentifier const UIBackgroundTaskInvalid;
UIKIT_EXTERN NSTimeInterval const UIMinimumKeepAliveTimeout;

#endif /* UIKit_UIApplication_h */
