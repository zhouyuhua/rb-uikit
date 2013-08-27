//
//  UIView_UIViewAnimation.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/30/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView_Private.h"
#import "UIAnimationCollection.h"

static NSMutableArray *AnimationStack()
{
    static NSMutableArray *animationStack = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        animationStack = [NSMutableArray array];
    });
    
    return animationStack;
}

static UIAnimationCollection *TopAnimation()
{
    return [AnimationStack() lastObject];
}

#pragma mark -

@implementation UIView (UIViewAnimation)

+ (void)beginAnimations:(NSString *)animationID context:(void *)context
{
    UIAnimationCollection *animation = [[UIAnimationCollection alloc] initWithName:animationID context:context];
    [AnimationStack() addObject:animation];
}

+ (void)commitAnimations
{
    UIAnimationCollection *animation = [AnimationStack() lastObject];
    [AnimationStack() removeLastObject];
    
    [animation commit];
}

#pragma mark -

+ (void)setAnimationDelegate:(id)delegate
{
    TopAnimation().delegate = delegate;
}

+ (void)setAnimationWillStartSelector:(SEL)selector
{
    TopAnimation().willStartSelector = selector;
}

+ (void)setAnimationDidStopSelector:(SEL)selector
{
    TopAnimation().didStopSelector = selector;
}

#pragma mark -

+ (void)setAnimationDuration:(NSTimeInterval)duration
{
    TopAnimation().duration = duration;
}

+ (void)setAnimationDelay:(NSTimeInterval)delay
{
    TopAnimation().delay = delay;
}

+ (void)setAnimationStartDate:(NSDate *)startDate
{
    TopAnimation().startDate = startDate;
}

#pragma mark -

+ (void)setAnimationCurve:(UIViewAnimationCurve)curve
{
    TopAnimation().curve = curve;
}

+ (void)setAnimationRepeatCount:(float)repeatCount
{
    TopAnimation().repeatCount = repeatCount;
}

+ (void)setAnimationRepeatAutoreverses:(BOOL)repeatAutoreverses
{
    TopAnimation().repeatAutoreverses = repeatAutoreverses;
}

#pragma mark -

+ (void)setAnimationBeginsFromCurrentState:(BOOL)fromCurrentState
{
    TopAnimation().beginsFromCurrentState = fromCurrentState;
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
    UIKitUnimplementedMethod();
}

#pragma mark - <CALayerDelegate> Continued

- (id <CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    if([UIView areAnimationsEnabled] && TopAnimation() != nil && layer == self.layer) {
        return [TopAnimation() actionForLayer:layer forKey:event] ?: (id <CAAction>)[NSNull null];
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
    
    //TODO: Handle all options
    
    TopAnimation().completionHandler = completion;
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

+ (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion NS_AVAILABLE_IOS(7_0)
{
    UIKitUnimplementedMethod();
}

+ (void)transitionWithView:(UIView *)view duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
{
    UIKitUnimplementedMethod();
}

+ (void)transitionFromView:(UIView *)fromView toView:(UIView *)toView duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion
{
    UIKitUnimplementedMethod();
}

@end
