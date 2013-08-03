//
//  UIBarCommon.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#ifndef UIKit_UIBarCommon_h
#define UIKit_UIBarCommon_h

typedef enum {
    UIBarStyleDefault = 0,
    UIBarStyleBlack = 1,
    
    UIBarStyleBlackOpaque = 1,
    UIBarStyleBlackTranslucent = 2,
} UIBarStyle;

typedef NS_ENUM(NSInteger, UIBarMetrics) {
    UIBarMetricsDefault,
    UIBarMetricsLandscapePhone,
    UIBarMetricsDefaultPrompt = 101,
    UIBarMetricsLandscapePhonePrompt,
};

#endif
