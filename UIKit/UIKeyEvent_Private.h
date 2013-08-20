//
//  UIKeyEvent_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/19/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIKeyEvent.h"

@interface UIKeyEvent ()

- (instancetype)initWithNSEvent:(NSEvent *)event;

#pragma mark - readwrite

@property (nonatomic, readwrite) NSTimeInterval timestamp;
@property (nonatomic, readwrite) UIKeyEventType type;
@property (nonatomic, readwrite) unsigned short keyCode;
@property (nonatomic, readwrite) UIKeyMask modifierFlags;
@property (nonatomic, getter = isRepeat, readwrite) BOOL repeat;

@end
