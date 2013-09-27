//
//  UIBarItem.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIBarItem.h"

@implementation UIBarItem {
    NSMutableDictionary *_titleTextAttributes;
}

- (id)init
{
    if((self = [super init])) {
        _titleTextAttributes = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)setTitleTextAttributes:(NSDictionary *)attributes forState:(UIControlState)state
{
    _titleTextAttributes[@(state)] = attributes;
}

- (NSDictionary *)titleTextAttributesForState:(UIControlState)state
{
    return _titleTextAttributes[@(state)];
}

@end
