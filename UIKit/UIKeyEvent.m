//
//  UIKeyEvent.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/19/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIKeyEvent_Private.h"

@implementation UIKeyEvent

- (instancetype)initWithNSEvent:(NSEvent *)event
{
    if((self = [super init])) {
        self.timestamp = [event timestamp];
        self.keyCode = [event keyCode];
        self.modifierFlags = [event modifierFlags];
        self.repeat = [event isARepeat];
        self.type = [event type];
    }
    
    return self;
}

@end
