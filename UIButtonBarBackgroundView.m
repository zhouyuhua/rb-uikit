//
//  UIButtonBarBackgroundView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIButtonBarBackgroundView.h"
#import "UIImage_Private.h"

@implementation UIButtonBarBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
        self.contentMode = UIViewContentModeRedraw;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIImage *backgroundImage;
    if(self.highlighted)
        backgroundImage = UIKitImageNamed(@"UIBarButtonItemBackgroundHighlighted", UIImageResizingModeStretch);
    else
        backgroundImage = UIKitImageNamed(@"UIBarButtonItemBackground", UIImageResizingModeStretch);
    
    UIImage *stretchableBackgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    [stretchableBackgroundImage drawInRect:rect];
}

@end
