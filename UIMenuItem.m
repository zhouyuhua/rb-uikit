//
//  UIMenuItem.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/12/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIMenuItem.h"

@implementation UIMenuItem

- (instancetype)initWithTitle:(NSString *)title action:(SEL)action
{
    if((self = [super init])) {
        self.title = title;
        self.action = action;
    }
    
    return self;
}

@end
