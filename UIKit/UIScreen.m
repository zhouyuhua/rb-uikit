//
//  UIScreen.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIScreen.h"

@interface UIScreen ()

@property (nonatomic) NSScreen *underlyingScreen;
@property (nonatomic) BOOL _isMainScreen;

@end

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

#pragma mark - Properties

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

@end
