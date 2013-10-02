//
//  _UISplitViewControllerDividerView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "_UISplitViewControllerDividerView.h"

@implementation _UISplitViewControllerDividerView

+ (CGFloat)preferredWidth
{
    return 1.0;
}

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor colorWithRed:0.34 green:0.34 blue:0.34 alpha:1.00];
    }
    
    return self;
}

@end
