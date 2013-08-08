//
//  UIAnimator.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/7/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIAnimator.h"

//From <http://www.gizma.com/easing/>, <http://stackoverflow.com/questions/10171966/ease-out-cubic-function-arguments-explanation>
CGFloat UIAnimatorQuadradicEaseOut(CGFloat timeWithinDuration, CGFloat start, CGFloat change, CGFloat duration)
{
	timeWithinDuration /= duration;
	return -change * timeWithinDuration * (timeWithinDuration - 2) + start;
}

//From <http://en.wikipedia.org/wiki/Linear_interpolation>
CGFloat UIAnimatorLinear(CGFloat timeWithinDuration, CGFloat start, CGFloat end, CGFloat duration)
{
    return start + (end - start) * (timeWithinDuration / duration);
}

@interface UIAnimator ()

@property (nonatomic, weak) NSTimer *animationPulse;

@end

#pragma mark -

@implementation UIAnimator

- (id)init
{
    if((self = [super init])) {
        self.framesPerSecond = 60.0;
    }
    
    return self;
}

- (BOOL)animateSingleFrame
{
    return YES;
}

- (void)run
{
    if(_animationPulse)
        return;
    
    _animationPulse = [NSTimer scheduledTimerWithTimeInterval:(1.0/_framesPerSecond)
                                                       target:self
                                                     selector:@selector(animationPulseFired:)
                                                     userInfo:nil
                                                      repeats:YES];
}

- (void)stop
{
    [_animationPulse invalidate];
}

#pragma mark -

- (void)animationPulseFired:(NSTimer *)timer
{
    if([self animateSingleFrame]) {
        [timer invalidate];
        
        if(_completionHandler)
            _completionHandler();
    }
}

@end
