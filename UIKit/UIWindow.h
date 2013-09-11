//
//  UIWindow.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"
#import "UIScreen.h"
#import "UIEvent.h"

@class UIViewController;

//This is not an enum in UIKit.
typedef NS_ENUM(NSUInteger, UIWindowLevel) {
    UIWindowLevelNormal = kCGNormalWindowLevelKey,
    UIWindowLevelAlert = kCGModalPanelWindowLevelKey,
    UIWindowLevelStatusBar = kCGNormalWindowLevelKey,
};

@interface UIWindow : UIView

- (id)initWithFrame:(CGRect)frame;

@property (nonatomic, retain) UIScreen *screen;

@property (nonatomic) UIWindowLevel windowLevel;
@property (nonatomic, readonly, getter=isKeyWindow) BOOL keyWindow;

- (void)becomeKeyWindow;
- (void)resignKeyWindow;

- (void)makeKeyWindow;
- (void)makeKeyAndVisible;

@property (nonatomic, retain) UIViewController *rootViewController;

- (CGPoint)convertPoint:(CGPoint)point toWindow:(UIWindow *)window;
- (CGPoint)convertPoint:(CGPoint)point fromWindow:(UIWindow *)window;
- (CGRect)convertRect:(CGRect)rect toWindow:(UIWindow *)window;
- (CGRect)convertRect:(CGRect)rect fromWindow:(UIWindow *)window;

- (void)sendEvent:(UIEvent *)event;

@end

@interface UIWindow (Mac)

/*
 Changing these properties does not affect
 UIWindows that have already been created.
 */

+ (void)setNativeWindowStyleMask:(NSUInteger)styleMask;
+ (NSUInteger)nativeWindowStyleMask;

+ (void)setNativeWindowClass:(Class)nativeWindowClass;
+ (Class)nativeWindowClass;

- (void)sendKeyEvent:(UIKeyEvent *)keyEvent;

@end

UIKIT_EXTERN NSString *const UIWindowDidBecomeVisibleNotification;
UIKIT_EXTERN NSString *const UIWindowDidBecomeHiddenNotification;
UIKIT_EXTERN NSString *const UIWindowDidBecomeKeyNotification;
UIKIT_EXTERN NSString *const UIWindowDidResignKeyNotification;
