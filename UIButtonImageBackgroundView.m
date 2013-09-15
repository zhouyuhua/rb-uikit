//
//  UIButtonImageBackgroundView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/14/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIButtonImageBackgroundView.h"
#import "UIImageView.h"

@interface UIButtonImageBackgroundView ()

@property (nonatomic, readwrite) UIImageView *imageView;

@end

@implementation UIButtonImageBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.imageView];
    }
    
    return self;
}

@end
