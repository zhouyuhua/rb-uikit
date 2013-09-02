//
//  UIKitConfigurationManager.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIAvailability.h"

UIKIT_EXTERN NSString *const UIKitConfigurationResourceFileName;

///The UIKitConfigurationManager class encapsulates interaction with
///modifable runtime behavior parameters. For most of these parameters,
///`nil` / `NO` / `0` means use default values.
///
///The configuration manager may be controlled through a static
///`UIKitInfo.plist` file placed in the application's main bundle.
@interface UIKitConfigurationManager : NSObject

///Returns the shared configuration manager, creating it if it does not already exist.
+ (UIKitConfigurationManager *)sharedConfigurationManager;

#pragma mark - UIApplication

///The principle class to use when instantiating `UIApplication`
///from a `UIApplicationMain` function call that does not specify
///a subclass of `UIApplication` to use. Leaving this value `nil`
///will cause UIApplication to use itself.
///
///Corresponding key is `UIPrincipleClassName`.
@property NSString *principleClassName;

#pragma mark - UIScreen

///The width value that `+[UIScreen mainScreen]` should return.
///If unspecified, UIScreen will return the actual hardware screen width.
///
///Both `mainScreenWidth` and `mainScreenHeight` must be set to have an effect.
///
///These properties are provided to allow existing app delegates to
///continue to function without special casing for Mac windows/screens.
///
///Corresponding key is `UIMainScreenWidth`.
@property CGFloat mainScreenWidth;

///The height value that `+[UIScreen mainScreen]` should return.
///If unspecified, UIScreen will return the actual hardware screen height.
///
///Both `mainScreenWidth` and `mainScreenHeight` must be set to have an effect.
///
///These properties are provided to allow existing app delegates to
///continue to function without special casing for Mac windows/screens.
///
///Corresponding key is `UIMainScreenHeight`.
@property CGFloat mainScreenHeight;

#pragma mark - UIButton

///Whether or not UIKit should use iOS 7 style borderless
///buttons in bars and for UIButtons of type UIButtonTypeSystem.
///
///This is off by default as borderless buttons are not
///as common on OS X as they are on iOS. This may change in
///the future, at which point this property will begin to
///default to YES.
///
///Corresponding key is `UIWantsBorderlessButtons`.
@property BOOL wantsBorderlessButtons;

#pragma mark - UINavigationController

///Specifies a logo to use in place of navigation level titles
///for instances of UINavigationController that are used as
///`rootViewController`s in instances of `UIWindow`.
///
///This property does not apply to navigation controllers which
///are not placed at the root of a window.
///
///Corresponding key is `UINavigationControllerBarLogoImageName`
@property NSString *navigationControllerBarLogoImageName;

@end
