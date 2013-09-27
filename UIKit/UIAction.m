//
//  UIAction.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/6/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIAction.h"
#import <objc/message.h>

@implementation UIAction

- (BOOL)isEqual:(id)object
{
    if([object isKindOfClass:[UIAction class]]) {
        UIAction *other = (UIAction *)object;
        return (other.events == self.events &&
                other.target == self.target &&
                other.action == self.action);
    }
    return NO;
}

- (NSUInteger)hash
{
    return (((NSInteger)self.events) + [self.target hash] + (NSInteger)sel_getName(self.action));
}

#pragma mark -

- (void)invokeFromSender:(id)sender
{
    ((void(*)(id, SEL, id))objc_msgSend)(self.target, self.action, sender);
}

@end
