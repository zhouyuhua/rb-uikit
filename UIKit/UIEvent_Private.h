//
//  UIEvent_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/30/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIEvent.h"

@class UIWindowAppKitHostView;

@interface UIEvent ()

@property (nonatomic) NSMutableSet *touches;

#pragma mark - readwrite

@property (nonatomic, readwrite) UIEventType type;
@property (nonatomic, readwrite) UIEventSubtype subtype;

@property (nonatomic, readwrite) NSTimeInterval timestamp;

@end
