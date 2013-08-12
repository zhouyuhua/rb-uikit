//
//  UIScrollViewDecelerationAnimator.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/7/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIScrollViewDecelerationAnimator.h"
#import "UIScrollView.h"

typedef NS_ENUM(NSUInteger, AnimationPhase) {
    kAnimationPhaseCoasting,
    kAnimationPhaseDroppingOff,
    kAnimationPhaseDone,
};

static NSTimeInterval const kCoastingDuration = 0.3;

@interface UIScrollViewDecelerationAnimator ()

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic) NSTimeInterval startTime;

@property (nonatomic) CGPoint velocity;

@property (nonatomic) CGPoint startOffset, endOffset, paddingOffset;

@property (nonatomic) NSTimeInterval duration;

@property (nonatomic) AnimationPhase phase;

@end

@implementation UIScrollViewDecelerationAnimator

- (instancetype)initWithScrollView:(UIScrollView *)scrollView velocity:(CGPoint)velocity
{
    NSParameterAssert(scrollView);
    
    if((self = [super init])) {
        self.scrollView = scrollView;
        
        self.startOffset = scrollView.contentOffset;
        self.endOffset = CGPointMake(_startOffset.x + velocity.x, _startOffset.y + velocity.y);
        self.paddingOffset = CGPointMake(_endOffset.x, _endOffset.y - 3.0);
        
        self.duration = 100.0 / abs(velocity.y);
        
        self.startTime = [NSDate timeIntervalSinceReferenceDate];
    }
    
    return self;
}

- (BOOL)animateSingleFrame
{
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate] - _startTime;
    
    _scrollView.contentOffset = CGPointMake(UIAnimatorQuadradicEaseOut(currentTime, _startOffset.x, _endOffset.x, _duration),
                                            UIAnimatorQuadradicEaseOut(currentTime, _startOffset.y, _endOffset.y, _duration));
    
    return (currentTime >= _duration);
}

@end
