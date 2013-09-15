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
        [[UIColor alternateSelectedControlColor] set];
    } else {
        [[UIColor whiteColor] set];
    }
    [bezierPath fill];
    
    [[UIColor colorWithWhite:0.0 alpha:0.5] set];
    [bezierPath setLineWidth:2.0];
    [bezierPath addClip];
    [bezierPath stroke];
}

#pragma mark - Properties

- (UIOffset)sizeOffsets
{
    return UIOffsetMake(30.0, 10.0);
}

@end
