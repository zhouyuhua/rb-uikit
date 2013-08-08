//
//  UIScrollViewDecelerationAnimator.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/7/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIScrollViewDecelerationAnimator.h"
#import "UIScrollView.h"

@interface UIScrollViewDecelerationAnimator ()

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation UIScrollViewDecelerationAnimator

- (instancetype)initWithScrollView:(UIScrollView *)scrollView velocity:(CGPoint)velocity
{
    NSParameterAssert(scrollView);
    
    if((self = [super init])) {
        self.scrollView = scrollView;
    }
    
    return self;
}

- (BOOL)animateSingleFrame
{
    return YES;
}

@end
