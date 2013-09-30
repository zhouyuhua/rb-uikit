//
//  _UIBarButtonFlexibleSpaceItem.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/29/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "_UIBarButtonFlexibleSpaceItem.h"
#import "UIBarButtonItem_Private.h"

@implementation _UIBarButtonFlexibleSpaceItem

+ (instancetype)sharedFlexibleSpaceItem
{
    static _UIBarButtonFlexibleSpaceItem *sharedFlexibleSpaceItem = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFlexibleSpaceItem = [self new];
    });
    
    return sharedFlexibleSpaceItem;
}

- (id)init
{
    if((self = [super init])) {
        self.style = UIBarButtonItemStylePlain;
        self.width = CGFLOAT_MAX;
        self._systemItem = UIBarButtonSystemItemFlexibleSpace;
    }
    
    return self;
}

#pragma mark - Identity

- (NSString *)description
{
    return @"UIBarButtonSystemItemFlexibleSpace";
}

- (BOOL)isEqual:(id)object
{
    return (object == self);
}

#pragma mark - Overrides

- (UIView *)_itemView
{
    return nil;
}

@end
