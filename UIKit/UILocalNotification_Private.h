//
//  UILocalNotification_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/5/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UILocalNotification.h"

@interface UILocalNotification ()

- (instancetype)_initWithNativeNotification:(NSUserNotification *)notification;

#pragma mark - Properties

@property (nonatomic) NSUserNotification *_nativeNotification;

@end
