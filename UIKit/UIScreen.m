//
//  UIScreen.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIScreen.h"
#import "UIImage.h"
#import "UIImageView.h"

@interface UIScreenMode ()

@property (nonatomic, readwrite) CGSize size;
@property (nonatomic, readwrite) CGFloat pixelAspectRatio;

@end

@implementation UIScreenMode

@end

#pragma mark -

@interface UIScreen ()

@property (nonatomic) NSScreen *underlyingScreen;
@property (nonatomic) BOOL _isMainScreen;

@end

#pragma mark -

@implementation UIScreen

+ (NSArray *)screens
{
    NSMutableArray *screens = [NSMutableArray array];
    for (NSScreen *screen in [NSScreen screens]) {
        [screens addObject:[[UIScreen alloc] initWithUnderlyingScreen:screen]];
    }
    
    return screens;
}

+ (UIScreen *)mainScreen
{
    static UIScreen *mainScreen = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainScreen = [[UIScreen alloc] initWithUnderlyingScreen:[NSScreen mainScreen]];
    });
    
    return mainScreen;
}

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithUnderlyingScreen:(NSScreen *)underlyingScreen
{
    NSParameterAssert(underlyingScreen);
    
    if((self = [super init])) {
        self.underlyingScreen = underlyingScreen;
        self._isMainScreen = [underlyingScreen isEqual:[NSScreen mainScreen]];
    }
    
    return self;
}

#pragma mark - Getting the Bounds Information

- (BOOL)_useHardwareSizing
{
    if(!self._isMainScreen)
        return YES;
    
    UIKitConfigurationManager *sharedConfigurationManager = [UIKitConfigurationManager sharedConfigurationManager];
    return (sharedConfigurationManager.mainScreenWidth == 0.0 || sharedConfigurationManager.mainScreenHeight == 0.0);
}

#pragma mark -

- (CGRect)bounds
{
    if(self._useHardwareSizing) {
        return self.underlyingScreen.frame;
    } else {
        UIKitConfigurationManager *sharedConfigurationManager = [UIKitConfigurationManager sharedConfigurationManager];
        return CGRectMake(0.0, 0.0, sharedConfigurationManager.mainScreenWidth, sharedConfigurationManager.mainScreenHeight);
    }
}

- (CGRect)applicationFrame
{
    if(self._useHardwareSizing) {
        return self.underlyingScreen.visibleFrame;
    } else {
        UIKitConfigurationManager *sharedConfigurationManager = [UIKitConfigurationManager sharedConfigurationManager];
        return CGRectMake(0.0, 0.0, sharedConfigurationManager.mainScreenWidth, sharedConfigurationManager.mainScreenHeight);
    }
}

- (CGFloat)scale
{
    return self.underlyingScreen.backingScaleFactor;
}

#pragma mark - Accessing the Screen Modes

- (UIScreenMode *)preferredMode
{
    UIScreenMode *screenMode = [UIScreenMode new];
    screenMode.pixelAspectRatio = 1.0;
    screenMode.size = self.underlyingScreen.frame.size;
    return screenMode;
}

- (NSArray *)availableModes
{
    return @[ self.preferredMode ];
}

- (void)setCurrentMode:(UIScreenMode *)currentMode
{
    //Do nothing.
}

- (UIScreenMode *)currentMode
{
    return nil;
}

#pragma mark - Setting a Display’s Brightness

- (void)setBrightness:(CGFloat)brightness
{
    //Do nothing.
}

- (CGFloat)brightness
{
    return 1.0;
}

- (void)setWantsSoftwareDimming:(BOOL)wantsSoftwareDimming
{
    //Do nothing.
}

- (BOOL)wantsSoftwareDimming
{
    return NO;
}

#pragma mark - Setting a Display’s Overscan Compensation

- (void)setOverscanCompensation:(UIScreenOverscanCompensation)overscanCompensation
{
    //Do nothing.
}

- (UIScreenOverscanCompensation)overscanCompensation
{
    return UIScreenOverscanCompensationScale;
}

#pragma mark - Capturing a Screen Snapshot

- (UIView *)snapshotViewAfterScreenUpdates:(BOOL)afterScreenUpdates
{
    if(![self _useHardwareSizing]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSLog(@"*** Warning, results of %s will be nonsensical when using an emulated screen size", __PRETTY_FUNCTION__);
        });
    }
    
    CFArrayRef windowList = CGWindowListCreate(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
    CGImageRef underlyingImage = CGWindowListCreateImageFromArray(CGRectInfinite, windowList, kCGWindowImageDefault);
    UIImage *image = [[UIImage alloc] initWithCGImage:underlyingImage
                                                scale:self.scale
                                          orientation:UIImageOrientationUp];
    CFRelease(windowList);
    CFRelease(underlyingImage);
    
    return [[UIImageView alloc] initWithImage:image];
}

@end

NSString *const UIScreenDidConnectNotification = @"UIScreenDidConnectNotification";
NSString *const UIScreenDidDisconnectNotification = @"UIScreenDidDisconnectNotification";
NSString *const UIScreenModeDidChangeNotification = @"UIScreenModeDidChangeNotification";
NSString *const UIScreenBrightnessDidChangeNotification = @"UIScreenBrightnessDidChangeNotification";
