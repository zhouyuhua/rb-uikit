//
//  UIScrollViewScrollAnimator.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/7/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIScrollViewScrollAnimator.h"
#import "UIScrollView.h"

@interface UIScrollViewScrollAnimator ()

@property (nonatomic, weak) UIScrollView *scrollView;

#pragma mark -

@property (nonatomic) CGPoint fromContentOffset, toContentOffset;
@property (nonatomic) NSTimeInterval duration, startTime, currentTime;
@property (nonatomic, assign) UIAnimatorFunction timingFunction;

@end

@implementation UIScrollViewScrollAnimator

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                 fromContentOffset:(CGPoint)fromOffset
                                to:(CGPoint)toOffset
                          duration:(NSTimeInterval)duration
                    timingFunction:(UIAnimatorFunction)timingFunction
{
    NSParameterAssert(scrollView);
    NSParameterAssert(timingFunction);
    
    if((self = [super init])) {
        self.scrollView = scrollView;
        
        self.fromContentOffset = fromOffset;
        self.toContentOffset = toOffset;
        self.duration = duration;
        self.timingFunction = timingFunction;
        
        self.startTime = [NSDate timeIntervalSinceReferenceDate];
    }
    
    return self;
}

- (BOOL)animateSingleFrame
{
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate] - _startTime;
    
    _scrollView.contentOffset = CGPointMake(_timingFunction(currentTime, _fromContentOffset.x, _toContentOffset.x, _duration),
                                            _timingFunction(currentTime, _fromContentOffset.y, _toContentOffset.y, _duration));
    
    return (currentTime >= _duration);
}

@end
