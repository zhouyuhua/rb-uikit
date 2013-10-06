//
//  UILocalNotification.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/5/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILocalNotification : NSObject <NSCopying, NSCoding>

#pragma mark - Scheduling a Local Notification

@property (nonatomic) NSDate *fireDate;
@property (nonatomic) NSTimeZone *timeZone;
@property (nonatomic) NSCalendarUnit repeatInterval;
@property (nonatomic) NSCalendar *repeatCalendar UIKIT_STUB;

#pragma mark - Composing the Alert

@property (nonatomic, copy) NSString *alertBody;
@property (nonatomic, copy) NSString *alertAction;
@property (nonatomic) BOOL hasAction;
@property (nonatomic, copy) NSString *alertLaunchImage;

#pragma mark - Configuring Other Parts of the Notification

@property (nonatomic) NSInteger applicationIconBadgeNumber;
@property (nonatomic, copy) NSString *soundName;
@property (nonatomic, copy) NSDictionary *userInfo;

@end

#define UILocalNotificationDefaultSoundName NSUserNotificationDefaultSoundName
