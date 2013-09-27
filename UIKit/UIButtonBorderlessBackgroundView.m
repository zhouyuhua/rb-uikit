//
//  UIButtonBorderlessBackgroundView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIButtonBorderlessBackgroundView.h"

@implementation UIButtonBorderlessBackgroundView

- (CGSize)constrainButtonSize:(CGSize)size withTitle:(NSString *)title image:(UIImage *)image
{
    if(size.height < 40.0)
        size.height = 40.0;
    
    size.width += 30.0;
    
    return size;
}

@end
