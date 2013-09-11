//
//  UIEvent.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/30/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIEvent_Private.h"
#import "UIWindowHostNativeView.h"
#import "UIWindow.h"
#import "UITouch_Private.h"

@implementation UIEvent

- (instancetype)init
{
    if((self = [super init])) {
        _touches = [NSMutableSet set];
    }
    
    return self;
}

#pragma mark - Touches

- (NSSet *)allTouches
{
    return [_touches copy];
}

- (NSSet *)touchesForWindow:(UIWindow *)window
{
    NSMutableSet *filteredTouches = [NSMutableSet set];
    for (UITouch *touch in _touches) {
        if(touch.window == window)
            [filteredTouches addObject:touch];
    }
    return filteredTouches;
}

- (NSSet *)touchesForView:(UIView *)view
{
    NSMutableSet *filteredTouches = [NSMutableSet set];
    for (UITouch *touch in _touches) {
        if(touch.view == view)
            [filteredTouches addObject:touch];
    }
    return filteredTouches;
}

- (NSSet *)touchesForGestureRecognizer:(UIGestureRecognizer *)gesture
{
    NSMutableSet *filteredTouches = [NSMutableSet set];
    for (UITouch *touch in _touches) {
        if([touch.gestureRecognizers containsObject:gesture])
            [filteredTouches addObject:touch];
    }
    return filteredTouches;
}

@end
