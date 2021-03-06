//
//  UIBarCommon.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#ifndef UIKit_UIBarCommon_h
#define UIKit_UIBarCommon_h

typedef NS_ENUM(NSInteger, UIBarStyle) {
    UIBarStyleDefault = 0,
    UIBarStyleBlack = 1,
    
    UIBarStyleBlackOpaque = 1,
    UIBarStyleBlackTranslucent = 2,
};

typedef NS_ENUM(NSInteger, UIBarMetrics) {
    UIBarMetricsDefault,
    UIBarMetricsLandscapePhone,
    UIBarMetricsDefaultPrompt = 101,
    UIBarMetricsLandscapePhonePrompt,
};

typedef NS_ENUM(NSInteger, UIBarPosition) {
    UIBarPositionAny = 0,
    UIBarPositionBottom = 1,
    UIBarPositionTop = 2,
    UIBarPositionTopAttached = 3,
};


@protocol UIBarPositioning <NSObject>

@property (nonatomic, readonly) UIBarPosition barPosition;

@end

@protocol UIBarPositioningDelegate <NSObject>

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar;

@end

#endif
