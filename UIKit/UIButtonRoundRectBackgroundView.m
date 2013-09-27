//
//  UIButtonRoundRectBackgroundView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIButtonRoundRectBackgroundView.h"
#import "UIBezierPath.h"
#import "UIColor.h"

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

- (CGSize)constrainButtonSize:(CGSize)size withTitle:(NSString *)title image:(UIImage *)image
{
    if(size.height < 40.0)
        size.height = 40.0;
    
    size.width += 30.0;
    
    return size;
}

@end
