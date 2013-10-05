//
//  UIScreen.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class UIView;

typedef NS_ENUM(NSInteger, UIScreenOverscanCompensation) {
    UIScreenOverscanCompensationScale,
    UIScreenOverscanCompensationInsetBounds,
    UIScreenOverscanCompensationInsetApplicationFrame,
};

@interface UIScreenMode : NSObject

#pragma mark - Accessing the Screen Mode Attributes

@property (nonatomic, readonly) CGSize size;
@property (nonatomic, readonly) CGFloat pixelAspectRatio;

@end

#pragma mark -

@interface UIScreen : NSObject

+ (NSArray *)screens;
+ (UIScreen *)mainScreen;

#pragma mark - Getting the Bounds Information

/*
 bounds and applicationFrame default to using the hardware
 metrics, this may be overriden with a `UIKitInfo.plist` file.
 
 See `UIKitConfigurationManager.h`
 */

@property (nonatomic, readonly) CGRect bounds;
@property (nonatomic, readonly) CGRect applicationFrame;
@property (nonatomic, readonly) CGFloat scale;

#pragma mark - Accessing the Screen Modes

@property (nonatomic, readonly) UIScreenMode *preferredMode UIKIT_STUB;
@property (nonatomic, readonly, copy) NSArray *availableModes UIKIT_STUB;
@property (nonatomic) UIScreenMode *currentMode UIKIT_STUB;

#pragma mark - Getting a Display Link

- (id)displayLinkWithTarget:(id)target selector:(SEL)selector __attribute__((unavailable("No translation for CADisplayLink on OS X")));

#pragma mark - Setting a Display’s Brightness

@property (nonatomic) CGFloat brightness UIKIT_STUB;
@property (nonatomic) BOOL wantsSoftwareDimming UIKIT_STUB;

#pragma mark - Setting a Display’s Overscan Compensation

@property (nonatomic) UIScreenOverscanCompensation overscanCompensation UIKIT_STUB;

#pragma mark - Capturing a Screen Snapshot

- (UIView *)snapshotViewAfterScreenUpdates:(BOOL)afterScreenUpdates;

@end

UIKIT_EXTERN NSString *const UIScreenDidConnectNotification;
UIKIT_EXTERN NSString *const UIScreenDidDisconnectNotification;
UIKIT_EXTERN NSString *const UIScreenModeDidChangeNotification;
UIKIT_EXTERN NSString *const UIScreenBrightnessDidChangeNotification;
