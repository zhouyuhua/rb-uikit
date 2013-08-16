//
//  UITouch.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/30/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UITouch_Private.h"
#import "UIView.h"
#import "UIWindow.h"

@implementation UITouch

- (CGPoint)locationInView:(UIView *)view
{
    if(view.window == self.window) {
        return [self.window convertPoint:self.locationInWindow toView:view];
    }
    
    return CGPointZero;
}

- (CGPoint)previousLocationInView:(UIView *)view
{
    if(view.window == self.window) {
        return [view convertPoint:self.previousLocationInWindow fromView:self.window];
    }
    
    return CGPointZero;
}

@end
