//
//  UIDevice.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software,  LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UIDeviceOrientation) {
    UIDeviceOrientationUnknown,
    UIDeviceOrientationPortrait,
    UIDeviceOrientationPortraitUpsideDown,
    UIDeviceOrientationLandscapeLeft,
    UIDeviceOrientationLandscapeRight,
    UIDeviceOrientationFaceUp,
    UIDeviceOrientationFaceDown
};

typedef NS_ENUM(NSInteger, UIDeviceBatteryState) {
    UIDeviceBatteryStateUnknown,
    UIDeviceBatteryStateUnplugged,
    UIDeviceBatteryStateCharging,
    UIDeviceBatteryStateFull,
};

typedef NS_ENUM(NSInteger, UIUserInterfaceIdiom) {
    UIUserInterfaceIdiomPhone,
    UIUserInterfaceIdiomPad,
    UIUserInterfaceIdiomMac,
};

#define UIDeviceOrientationIsPortrait(orientation)  ((orientation) == UIDeviceOrientationPortrait || (orientation) == UIDeviceOrientationPortraitUpsideDown)
#define UIDeviceOrientationIsLandscape(orientation) ((orientation) == UIDeviceOrientationLandscapeLeft || (orientation) == UIDeviceOrientationLandscapeRight)

@interface UIDevice : NSObject

+ (UIDevice *)currentDevice;

@property (nonatomic, readonly, retain) NSString *name;
@property (nonatomic, readonly, retain) NSString *model;
@property (nonatomic, readonly, retain) NSString *localizedModel;
@property (nonatomic, readonly, retain) NSString *systemName;
@property (nonatomic, readonly, retain) NSString *systemVersion;
@property (nonatomic, readonly) UIDeviceOrientation orientation;

@property (nonatomic, readonly, retain) NSUUID *identifierForVendor;
@property (nonatomic, readonly, getter=isGeneratingDeviceOrientationNotifications) BOOL generatesDeviceOrientationNotifications;
- (void)beginGeneratingDeviceOrientationNotifications;
- (void)endGeneratingDeviceOrientationNotifications;

@property (nonatomic, getter=isBatteryMonitoringEnabled) BOOL batteryMonitoringEnabled;
@property (nonatomic, readonly) UIDeviceBatteryState batteryState;
@property (nonatomic, readonly) float batteryLevel;

@property (nonatomic, getter=isProximityMonitoringEnabled) BOOL proximityMonitoringEnabled;
@property (nonatomic, readonly) BOOL proximityState;

@property (nonatomic, readonly, getter=isMultitaskingSupported) BOOL multitaskingSupported;

@property (nonatomic, readonly) UIUserInterfaceIdiom userInterfaceIdiom;

- (void)playInputClick;

@end

UIKIT_EXTERN NSString *const UIDeviceOrientationDidChangeNotification;
UIKIT_EXTERN NSString *const UIDeviceBatteryStateDidChangeNotification;
UIKIT_EXTERN NSString *const UIDeviceBatteryLevelDidChangeNotification;
UIKIT_EXTERN NSString *const UIDeviceProximityStateDidChangeNotification;
