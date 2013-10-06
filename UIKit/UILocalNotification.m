//
//  UILocalNotification.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/5/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UILocalNotification_Private.h"

@implementation UILocalNotification

- (instancetype)_initWithNativeNotification:(NSUserNotification *)notification
{
    NSParameterAssert(notification);
    
    if((self = [super init])) {
        self._nativeNotification = [NSUserNotification new];
    }
    
    return self;
}

- (id)init
{
    return [self _initWithNativeNotification:[NSUserNotification new]];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        self.fireDate = [decoder decodeObjectForKey:@"fireDate"];
        self.timeZone = [decoder decodeObjectForKey:@"timeZone"];
        self.repeatInterval = [decoder decodeIntegerForKey:@"repeatInterval"];
        
        self.alertBody = [decoder decodeObjectForKey:@"alertBody"];
        self.alertAction = [decoder decodeObjectForKey:@"alertAction"];
        self.hasAction = [decoder decodeBoolForKey:@"hasAction"];
        self.alertLaunchImage = [decoder decodeObjectForKey:@"alertLaunchImage"];
        
        self.applicationIconBadgeNumber = [decoder decodeIntegerForKey:@"applicationIconBadgeNumber"];
        self.soundName = [decoder decodeObjectForKey:@"soundName"];
        self.userInfo = [decoder decodeObjectForKey:@"userInfo"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.fireDate forKey:@"fireDate"];
    [encoder encodeObject:self.timeZone forKey:@"timeZone"];
    [encoder encodeInteger:self.repeatInterval forKey:@"repeatInterval"];
    
    [encoder encodeObject:self.alertBody forKey:@"alertBody"];
    [encoder encodeObject:self.alertAction forKey:@"alertAction"];
    [encoder encodeBool:self.hasAction forKey:@"hasAction"];
    [encoder encodeObject:self.alertLaunchImage forKey:@"alertLaunchImage"];
    
    [encoder encodeInteger:self.applicationIconBadgeNumber forKey:@"applicationIconBadgeNumber"];
    [encoder encodeObject:self.soundName forKey:@"soundName"];
    [encoder encodeObject:self.userInfo forKey:@"userInfo"];
}

#pragma mark - Copying

- (id)copyWithZone:(NSZone *)zone
{
    UILocalNotification *copy = [self.class new];
    copy._nativeNotification = [self._nativeNotification copy];
    return copy;
}

#pragma mark - Identity

- (NSUInteger)hash
{
    return [self._nativeNotification hash] + 99;
}

- (BOOL)isEqual:(id)object
{
    if([object isKindOfClass:[UILocalNotification class]]) {
        return [self._nativeNotification isEqual:[object _nativeNotification]];
    }
    
    return NO;
}

#pragma mark - Scheduling a Local Notification

- (void)setFireDate:(NSDate *)fireDate
{
    self._nativeNotification.deliveryDate = fireDate;
}

- (NSDate *)fireDate
{
    return self._nativeNotification.deliveryDate;
}

- (void)setTimeZone:(NSTimeZone *)timeZone
{
    self._nativeNotification.deliveryTimeZone = timeZone;
}

- (NSTimeZone *)timeZone
{
    return self._nativeNotification.deliveryTimeZone;
}

- (void)setRepeatInterval:(NSCalendarUnit)repeatInterval
{
    NSDateComponents *dateComponents = [NSDateComponents new];
    
    switch (repeatInterval) {
        case NSCalendarUnitEra: {
            [dateComponents setEra:1];
            break;
        }
            
        case NSCalendarUnitYear: {
            [dateComponents setYear:1];
            break;
        }
            
        case NSCalendarUnitMonth: {
            [dateComponents setMonth:1];
            break;
        }
            
        case NSCalendarUnitDay: {
            [dateComponents setDay:1];
            break;
        }
            
        case NSCalendarUnitHour: {
            [dateComponents setHour:1];
            break;
        }
            
        case NSCalendarUnitMinute: {
            [dateComponents setMinute:1];
            break;
        }
            
        case NSCalendarUnitSecond: {
            [dateComponents setSecond:1];
            break;
        }
            
        default:
            break;
    }
    
    self._nativeNotification.deliveryRepeatInterval = dateComponents;
}

- (NSCalendarUnit)repeatInterval
{
    NSDateComponents *components = self._nativeNotification.deliveryRepeatInterval;
    
    if(components.era > 1)
        return NSEraCalendarUnit;
    else if(components.year > 1)
        return NSYearCalendarUnit;
    else if(components.month > 1)
        return NSMonthCalendarUnit;
    else if(components.day > 1)
        return NSDayCalendarUnit;
    else if(components.hour > 1)
        return NSHourCalendarUnit;
    else if(components.minute > 1)
        return NSMinuteCalendarUnit;
    else if(components.second > 1)
        return NSSecondCalendarUnit;
    else
        return NSDateComponentUndefined;
}

- (void)setRepeatCalendar:(NSCalendar *)repeatCalendar
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"*** Warning, UILocalNotificaiton.repeatCalendar is not supported");
    });
}

- (NSCalendar *)repeatCalendar
{
    return [NSCalendar currentCalendar];
}

#pragma mark - Composing the Alert

- (void)setAlertBody:(NSString *)alertBody
{
    self._nativeNotification.title = alertBody;
}

- (NSString *)alertBody
{
    return self._nativeNotification.title;
}

- (void)setAlertAction:(NSString *)alertAction
{
    self._nativeNotification.actionButtonTitle = alertAction;
}

- (NSString *)alertAction
{
    return self._nativeNotification.actionButtonTitle;
}

- (void)setHasAction:(BOOL)hasAction
{
    self._nativeNotification.hasActionButton = hasAction;
}

- (BOOL)hasAction
{
    return self._nativeNotification.hasActionButton;
}

#pragma mark - Configuring Other Parts of the Notification

- (void)setSoundName:(NSString *)soundName
{
    self._nativeNotification.soundName = soundName;
}

- (NSString *)soundName
{
    return self._nativeNotification.soundName;
}

- (void)setUserInfo:(NSDictionary *)userInfo
{
    self._nativeNotification.userInfo = userInfo;
}

- (NSDictionary *)userInfo
{
    return self._nativeNotification.userInfo;
}

@end
