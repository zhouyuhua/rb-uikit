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

#pragma mark -

///This enum is provided so that a no-op kludge can be created for the real UIKit so that
///native window modification code can live in a normal project without #ifdefs.
typedef NS_OPTIONS(NSUInteger, UIWindowNativeStyleMask) {
    UIWindowNativeStyleMaskBorderless = NSBorderlessWindowMask,
    UIWindowNativeStyleMaskTitled = NSTitledWindowMask,
    UIWindowNativeStyleMaskClosable = NSClosableWindowMask,
    UIWindowNativeStyleMaskMiniaturizable = NSMiniaturizableWindowMask,
    UIWindowNativeStyleMaskResizable = NSResizableWindowMask,
    UIWindowNativeStyleMaskTextured = NSTexturedBackgroundWindowMask,
    UIWindowNativeStyleMaskFullScreen = NSFullScreenWindowMask,
    
    UIWindowNativeStyleMaskDefault = (UIWindowNativeStyleMaskBorderless |
                                      UIWindowNativeStyleMaskClosable |
                                      UIWindowNativeStyleMaskMiniaturizable |
                                      UIWindowNativeStyleMaskResizable)
};

///The UIWindow+Mac category describes the methods available in UIWindow on the Mac.
@interface UIWindow (Mac)

///Sets the style mask used for the native windows backing UIWindows.
///
/// \param  styleMask   The style mask to use. Must be borderless.
///
///Setting the style mask does not affect any instances of UIWindow already created.
+ (void)setNativeWindowStyleMask:(UIWindowNativeStyleMask)styleMask;

///Returns the native window style mask used by UIWindows upon creation.
+ (UIWindowNativeStyleMask)nativeWindowStyleMask;

///Sets the native window class used by UIWindow upon creation.
///
/// \param  nativeWindowClass   The class to use. Must be a subclass of UINSWindow. May not be nil.
///
///Setting the window class does not affect any instances of UIWindow already created.
+ (void)setNativeWindowClass:(Class)nativeWindowClass;

///Returns the current native window class used by UIWindows upon creation.
+ (Class)nativeWindowClass;

#pragma mark -

///Dispatches key events sent to the receiver by the UIApplication object to its views.
- (void)sendKeyEvent:(UIKeyEvent *)keyEvent;

@end

UIKIT_EXTERN NSString *const UIWindowDidBecomeVisibleNotification;
UIKIT_EXTERN NSString *const UIWindowDidBecomeHiddenNotification;
UIKIT_EXTERN NSString *const UIWindowDidBecomeKeyNotification;
UIKIT_EXTERN NSString *const UIWindowDidResignKeyNotification;
