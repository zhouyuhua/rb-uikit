//
//  UIDevice.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIDevice.h"

NSString *const UIDeviceOrientationDidChangeNotification = @"UIDeviceOrientationDidChangeNotification";
NSString *const UIDeviceBatteryStateDidChangeNotification = @"UIDeviceBatteryStateDidChangeNotification";
NSString *const UIDeviceBatteryLevelDidChangeNotification = @"UIDeviceBatteryLevelDidChangeNotification";
NSString *const UIDeviceProximityStateDidChangeNotification = @"UIDeviceProximityStateDidChangeNotification";

@implementation UIDevice

+ (UIDevice *)currentDevice
{
    static UIDevice *sharedDevice = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDevice = [UIDevice new];
    });
    
    return sharedDevice;
}

#pragma mark -

- (NSString *)name
{
    return @"Roundabout's Fake iOS Device";
}

- (NSString *)model
{
    return @"Roundabout";
}

- (NSString *)localizedModel
{
    return @"Mac";
}

- (NSString *)systemName
{
    return @"Roundabout-UIKit";
}

- (NSString *)systemVersion
{
    return @"6.0";
}

- (UIDeviceOrientation)orientation
{
    return UIDeviceOrientationUnknown;
}

#pragma mark -

- (NSUUID *)identifierForVendor
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *savedIdentifierForVendor = [defaults stringForKey:@"RK-UIKit-UIDevice-identifierForVendor"];
    if(savedIdentifierForVendor) {
        return [[NSUUID alloc] initWithUUIDString:savedIdentifierForVendor];
    } else {
        NSUUID *newIdentifier = [NSUUID UUID];
        [defaults setObject:[newIdentifier UUIDString] forKey:@"RK-UIKit-UIDevice-identifierForVendor"];
        
        return newIdentifier;
    }
}

#pragma mark -

- (BOOL)isGeneratingDeviceOrientationNotifications
{
    return NO;
}

- (void)beginGeneratingDeviceOrientationNotifications
{
    //Do nothing
}

- (void)endGeneratingDeviceOrientationNotifications
{
    //Do nothing
}

#pragma mark -

- (void)setBatteryMonitoringEnabled:(BOOL)batteryMonitoringEnabled
{
    //Do nothing
}

- (BOOL)isBatteryMonitoringEnabled
{
    return NO;
}

- (UIDeviceBatteryState)batteryState
{
    return UIDeviceBatteryStateFull;
}

- (float)batteryLevel
{
    return 1.0;
}

#pragma mark -

- (void)setProximityState:(BOOL)proximityState
{
    //Do nothing.
}

- (BOOL)isProximityMonitoringEnabled
{
    return NO;
}

- (BOOL)proximityState
{
    return NO;
}

#pragma mark -

- (BOOL)isMultitaskingSupported
{
    return YES;
}

#pragma mark -

- (UIUserInterfaceIdiom)userInterfaceIdiom
{
    return UIUserInterfaceIdiomMac;
}

#pragma mark -

- (void)playInputClick
{
    NSBeep();
}

@end
