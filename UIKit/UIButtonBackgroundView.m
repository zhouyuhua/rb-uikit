//
//  UIButtonBackgroundView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIButtonBackgroundView.h"

@implementation UIButtonBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = NO;
    }
    
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    _highlighted = highlighted;
    [self setNeedsDisplay];
}

- (CGSize)constrainButtonSize:(CGSize)size withTitle:(NSString *)title image:(UIImage *)image
{
    return size;
}

@end
