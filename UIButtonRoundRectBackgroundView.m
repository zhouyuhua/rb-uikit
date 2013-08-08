//
//  UIButtonRoundRectBackgroundView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIButtonRoundRectBackgroundView.h"

@implementation UIButtonRoundRectBackgroundView

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect xRadius:5.0 yRadius:5.0];
    if(self.isHighlighted) {
        [[UIColor selectedMenuItemColor] set];
    } else {
        [[UIColor whiteColor] set];
    }
    [bezierPath fill];
    
    if(self.isHighlighted) {
        [[UIColor colorWithWhite:0.1 alpha:1.0] set];
    } else {
        [[UIColor colorWithWhite:0.4 alpha:1.0] set];
    }
    [bezierPath setLineWidth:2.0];
    [bezierPath addClip];
    [bezierPath stroke];
}

@end