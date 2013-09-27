//
//  UIDataDetectorTypes.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/26/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#ifndef UIKit_UIDataDetectorTypes_h
#define UIKit_UIDataDetectorTypes_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, UIDataDetectorTypes) {
    UIDataDetectorTypePhoneNumber   = 1 << 0,
    UIDataDetectorTypeLink          = 1 << 1,
    UIDataDetectorTypeAddress       = 1 << 2,
    UIDataDetectorTypeCalendarEvent = 1 << 3,
    UIDataDetectorTypeNone          = 0,
    UIDataDetectorTypeAll           = NSUIntegerMax
};

#endif
