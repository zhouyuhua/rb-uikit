//
//  UIScrollViewDecelerationAnimator.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/7/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIAnimator.h"

@class UIScrollView;

@interface UIScrollViewDecelerationAnimator : UIAnimator

- (instancetype)initWithScrollView:(UIScrollView *)scrollView velocity:(CGPoint)velocity;

@end
