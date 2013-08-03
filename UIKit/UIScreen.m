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
    }
    
    return self;
}

#pragma mark - Properties

- (CGRect)bounds
{
    return self.underlyingScreen.frame;
}

- (CGRect)applicationFrame
{
    return self.underlyingScreen.visibleFrame;
}

- (CGFloat)scale
{
    return self.underlyingScreen.backingScaleFactor;
}

@end
