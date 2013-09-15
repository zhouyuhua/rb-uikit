//
//  UIScrollViewDecelerationAnimator.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/7/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIScrollViewDecelerationAnimator.h"
#import "UIScrollView_Private.h"

static CGFloat const MaxBounceBack = 50.0;

static CGFloat Constrain(CGFloat value, CGFloat min, CGFloat max)
{
    if(value < min)
        return min;
    else if(value > max)
        return max;
    else
        return value;
}

static CGFloat ConstrainVelocity(CGFloat velocity)
{
    CGFloat const MaxVelocity = 500.0;
    return Constrain(velocity, -MaxVelocity, MaxVelocity);
}

typedef NS_ENUM(NSUInteger, AnimationPhase) {
    AnimationPhaseMomentum,
    AnimationPhaseBounce,
};

@interface UIScrollViewDecelerationAnimator ()

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic) NSTimeInterval startTime;

@property (nonatomic) CGPoint initialContentOffset;

@property (nonatomic) CGPoint constrainedTargetContentOffset;

@property (nonatomic) BOOL bounceX, bounceY;

@property (nonatomic) AnimationPhase phase;

@property (nonatomic) UIAnimatorFunction momentumTimingFunction;

@end

@implementation UIScrollViewDecelerationAnimator

- (instancetype)initWithScrollView:(UIScrollView *)scrollView velocity:(CGPoint)velocity
{
    NSParameterAssert(scrollView);
    
    if((self = [super init])) {
        self.scrollView = scrollView;
        
        velocity.x = ConstrainVelocity(velocity.x);
        velocity.y = ConstrainVelocity(velocity.y);
        
        self.initialContentOffset = scrollView.contentOffset;
        if(_initialContentOffset.x == 0.0)
            velocity.x = 0.0;
        
        if(_initialContentOffset.y == 0.0)
            velocity.y = 0.0;
        
        CGSize contentSize = scrollView.contentSize;
        self.targetContentOffset = CGPointMake(Constrain(_initialContentOffset.x + velocity.x, -MaxBounceBack, (contentSize.width - CGRectGetWidth(scrollView.frame)) + MaxBounceBack),
                                               Constrain(_initialContentOffset.y + velocity.y, -MaxBounceBack, (contentSize.height - CGRectGetHeight(scrollView.frame)) + MaxBounceBack));
        self.constrainedTargetContentOffset = [scrollView _constrainContentOffset:_targetContentOffset forBounceBack:YES];
        
        self.bounceX = scrollView.bounces && scrollView.alwaysBounceHorizontal && velocity.x != 0.0 && _targetContentOffset.x != _constrainedTargetContentOffset.x;
        self.bounceY = scrollView.bounces && scrollView.alwaysBounceVertical && velocity.y != 0.0 && _targetContentOffset.y != _constrainedTargetContentOffset.y;
        
        if(_bounceX || _bounceY) {
            _momentumTimingFunction = &UILinearInterpolation;
        } else {
            _momentumTimingFunction = &UIQuadradicEaseOut;
            self.targetContentOffset = self.constrainedTargetContentOffset;
        }
        
        self.duration = abs(velocity.y) > 300? UIScrollViewDecelerationRateFast : UIScrollViewDecelerationRateNormal;

        self.startTime = [NSDate timeIntervalSinceReferenceDate];
    }
    
    return self;
}

- (BOOL)animateSingleFrame
{
    if(CGPointEqualToPoint(_initialContentOffset, CGPointZero) ||
       CGPointEqualToPoint(_initialContentOffset, _targetContentOffset))
        return YES;
    
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate] - _startTime;
    
    if((_bounceX || _bounceY) && ((currentTime >= _duration && (_phase == AnimationPhaseMomentum)) || _phase == AnimationPhaseBounce)) {
        if(_phase == AnimationPhaseMomentum) {
            _phase = AnimationPhaseBounce;
            _startTime = [NSDate timeIntervalSinceReferenceDate];
            _duration = 0.3;
            currentTime = 0.0;
        }
        
        _scrollView.contentOffset = CGPointMake(UIQuadradicEaseOut(currentTime, _targetContentOffset.x, _constrainedTargetContentOffset.x, _duration),
                                                UIQuadradicEaseOut(currentTime, _targetContentOffset.y, _constrainedTargetContentOffset.y, _duration));
    } else if(_phase == AnimationPhaseMomentum) {
        _scrollView.contentOffset = CGPointMake(_momentumTimingFunction(currentTime, _initialContentOffset.x, _targetContentOffset.x, _duration),
                                                _momentumTimingFunction(currentTime, _initialContentOffset.y, _targetContentOffset.y, _duration));
    }
    
    return (currentTime >= _duration);
}

@end
