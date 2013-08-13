//
//  UIScrollViewScrollAnimator.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/7/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIAnimator.h"

@class UIScrollView;

@interface UIScrollViewScrollAnimator : UIAnimator

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                 fromContentOffset:(CGPoint)fromOffset
                                to:(CGPoint)toOffset
                          duration:(NSTimeInterval)duration
                    timingFunction:(UIAnimatorFunction)timingFunction;

@end
