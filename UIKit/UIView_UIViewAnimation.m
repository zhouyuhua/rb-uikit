//
//  UIView_UIViewAnimation.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/30/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView_Private.h"
#import "_UIAnimations.h"

@implementation UIView (UIViewAnimation)

+ (NSMutableArray *)_sharedAnimationsStack
{
    static NSMutableArray *animationStack = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        animationStack = [NSMutableArray array];
    });
    
    return animationStack;
}

+ (void)_pushAnimations:(_UIAnimations *)animations
{
    NSParameterAssert(animations);
    
    [self._sharedAnimationsStack addObject:animations];
}

+ (_UIAnimations *)_popAnimations
{
    _UIAnimations *lastAnimations = [self._sharedAnimationsStack lastObject];
    [self._sharedAnimationsStack removeLastObject];
    
    return lastAnimations;
}

+ (_UIAnimations *)_currentAnimations
{
    return [self._sharedAnimationsStack lastObject];
}

#pragma mark -

+ (void)beginAnimations:(NSString *)animationID context:(void *)context
{
    [self _pushAnimations:[[_UIAnimations alloc] initWithName:animationID context:context]];
}

+ (void)commitAnimations
{
    [[self _popAnimations] commit];
}

#pragma mark -

+ (void)setAnimationDelegate:(id)delegate
{
    self._currentAnimations.delegate = delegate;
}

+ (void)setAnimationWillStartSelector:(SEL)selector
{
    self._currentAnimations.willStartSelector = selector;
}

+ (void)setAnimationDidStopSelector:(SEL)selector
{
    self._currentAnimations.didStopSelector = selector;
}

#pragma mark -

+ (void)setAnimationDuration:(NSTimeInterval)duration
{
    self._currentAnimations.duration = duration;
}

+ (void)setAnimationDelay:(NSTimeInterval)delay
{
    self._currentAnimations.delay = delay;
}

+ (void)setAnimationStartDate:(NSDate *)startDate
{
    self._currentAnimations.startDate = startDate;
}

#pragma mark -

+ (void)setAnimationCurve:(UIViewAnimationCurve)curve
{
    self._currentAnimations.curve = curve;
}

+ (void)setAnimationRepeatCount:(float)repeatCount
{
    self._currentAnimations.repeatCount = repeatCount;
}

+ (void)setAnimationRepeatAutoreverses:(BOOL)repeatAutoreverses
{
    self._currentAnimations.repeatAutoreverses = repeatAutoreverses;
}

#pragma mark -

+ (void)setAnimationBeginsFromCurrentState:(BOOL)fromCurrentState
{
    self._currentAnimations.beginsFromCurrentState = fromCurrentState;
}

#pragma mark -

+ (void)setAnimationTransition:(UIViewAnimationTransition)transition forView:(UIView *)view cache:(BOOL)cache
{
    UIKitUnimplementedMethod();
}

#pragma mark -

static BOOL AnimationsEnabled = YES;
+ (void)setAnimationsEnabled:(BOOL)enabled
{
    AnimationsEnabled = enabled;
}

+ (BOOL)areAnimationsEnabled
{
    return AnimationsEnabled;
}

+ (void)performWithoutAnimation:(void (^)(void))actionsWithoutAnimation
{
    NSParameterAssert(actionsWithoutAnimation);
    
    static NSInteger NestCount = 0;
    if(++NestCount == 1) {
        [self setAnimationsEnabled:NO];
    }
    
    actionsWithoutAnimation();
    
    if(--NestCount == 0) {
        [self setAnimationsEnabled:YES];
    }
}

#pragma mark - <CALayerDelegate> Continued

- (id <CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    if([UIView areAnimationsEnabled] && self.class._currentAnimations != nil && layer == self.layer) {
        return [self.class._currentAnimations actionForLayer:layer forKey:event] ?: (id <CAAction>)[NSNull null];
    } else {
        return (id <CAAction>)[NSNull null];
    }
}

@end

#pragma mark -

@implementation UIView (UIViewAnimationWithBlocks)

+ (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
{
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationDelay:delay];
    
    if((options & UIViewAnimationOptionBeginFromCurrentState) == UIViewAnimationOptionBeginFromCurrentState)
        [UIView setAnimationBeginsFromCurrentState:YES];
    
    if((options & UIViewAnimationOptionRepeat) == UIViewAnimationOptionRepeat)
        [UIView setAnimationRepeatAutoreverses:YES];
    
    if((options & UIViewAnimationOptionCurveEaseInOut) == UIViewAnimationOptionCurveEaseInOut)
       [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if((options & UIViewAnimationOptionCurveEaseIn) == UIViewAnimationOptionCurveEaseIn)
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    if((options & UIViewAnimationOptionCurveEaseOut) == UIViewAnimationOptionCurveEaseOut)
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    if((options & UIViewAnimationOptionCurveEaseInOut) == UIViewAnimationOptionCurveLinear)
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    if(UIKIT_FLAG_IS_SET(options, UIViewAnimationOptionTransitionFlipFromLeft) ||
       UIKIT_FLAG_IS_SET(options, UIViewAnimationOptionTransitionFlipFromRight) ||
       UIKIT_FLAG_IS_SET(options, UIViewAnimationOptionTransitionCurlUp) ||
       UIKIT_FLAG_IS_SET(options, UIViewAnimationOptionTransitionCurlDown) ||
       UIKIT_FLAG_IS_SET(options, UIViewAnimationOptionTransitionCrossDissolve) ||
       UIKIT_FLAG_IS_SET(options, UIViewAnimationOptionTransitionFlipFromTop) ||
       UIKIT_FLAG_IS_SET(options, UIViewAnimationOptionTransitionFlipFromBottom)) {
        UIKitWarnUnimplementedMethod(__PRETTY_FUNCTION__, @"Transitions not implemented");
    }
    
    self._currentAnimations.completionHandler = completion;
    if(animations)
        animations();
    
    [UIView commitAnimations];
}

+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
{
    [self animateWithDuration:duration delay:0.0 options:kNilOptions animations:animations completion:completion];
}

+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations
{
    [self animateWithDuration:duration delay:0.0 options:kNilOptions animations:animations completion:NULL];
}

+ (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
{
    UIKitWarnUnimplementedMethod(__PRETTY_FUNCTION__, @"Damping not unimplemented");
    
    [self animateWithDuration:duration delay:delay options:options animations:animations completion:completion];
}

+ (void)transitionWithView:(UIView *)view duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
{
    UIKitUnimplementedMethod();
}

+ (void)transitionFromView:(UIView *)fromView toView:(UIView *)toView duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion
{
    UIKitUnimplementedMethod();
}

#pragma mark -

+ (void)animateKeyframesWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
{
    UIKitUnimplementedMethod();
}

+ (void)addKeyframeWithRelativeStartTime:(NSTimeInterval)relativeStartTime relativeDuration:(NSTimeInterval)duration animations:(void (^)(void))animations
{
    UIKitUnimplementedMethod();
}

+ (void)performSystemAnimation:(UISystemAnimation)animation onViews:(NSArray *)views options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
{
    UIKitUnimplementedMethod();
}

@end
