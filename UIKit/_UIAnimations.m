//
//  UIAnimation.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/30/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "_UIAnimations.h"
#import <objc/message.h>

static CAMediaTimingFunction *CAMediaTimingFunctionFromUIViewAnimationCurve(UIViewAnimationCurve curve)
{
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
        case UIViewAnimationCurveEaseIn:
            return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            
        case UIViewAnimationCurveEaseOut:
            return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            
        case UIViewAnimationCurveLinear:
            return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }
}

@implementation _UIAnimations {
    NSUInteger _animationCount;
}

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithName:(NSString *)name context:(void *)context
{
    if((self = [super init])) {
        self.name = name;
        self.context = context;
        
        self.curve = UIViewAnimationCurveEaseIn;
    }
    
    return self;
}

#pragma mark - Dispensing Animations

- (id <CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)keyPath
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    
    animation.removedOnCompletion = YES;
    animation.delegate = self;
    
    if(([NSEvent modifierFlags] & NSShiftKeyMask) == NSShiftKeyMask)
        animation.duration = self.duration * 2.0;
    else
        animation.duration = self.duration;
    animation.beginTime = self.delay;
    animation.timeOffset = [self.startDate timeIntervalSince1970];
    
    animation.repeatCount = self.repeatCount;
    animation.autoreverses = self.repeatAutoreverses;
    animation.timingFunction = CAMediaTimingFunctionFromUIViewAnimationCurve(self.curve);
    
    animation.fromValue = _beginsFromCurrentState? [layer.presentationLayer valueForKeyPath:keyPath] : [layer valueForKeyPath:keyPath];
    
    return animation;
}

#pragma mark - Animation Delegate

/*
 - (void)animationWillStart:(NSString *)animationID context:(void *)context
 - (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished
 */

- (void)animationDidStart:(CAAnimation *)anim
{
    _animationCount++;
    
    if(self.delegate && self.willStartSelector)
        ((void(*)(id, SEL, NSString *, void *))objc_msgSend)(self.delegate, self.willStartSelector, self.name, self.context);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    _animationCount--;
    
    if(_animationCount == 0) {
        if(self.delegate && self.didStopSelector)
            ((void(*)(id, SEL, NSString *, NSNumber *))objc_msgSend)(self.delegate, self.didStopSelector, self.name, @(flag));
        
        if(_completionHandler)
            _completionHandler(flag);
    }
}

#pragma mark - Committing

- (void)commit
{
    
}

@end
