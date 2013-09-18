//
//  UIViewTransitioning.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/17/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIViewControllerTransitioning_Private.h"
#import "UIViewController.h"

NSString *const UITransitionContextFromViewControllerKey = @"UITransitionContextFromViewControllerKey";
NSString *const UITransitionContextToViewControllerKey = @"UITransitionContextToViewControllerKey";

@implementation _UIViewControllerContextConcreteTransitioning {
    UIView *_containerView;
    BOOL _animated;
    id <UIViewControllerAnimatedTransitioning> _transitioningObject;
    dispatch_block_t _completionHandler;
    
    NSDictionary *_viewControllers;
    NSDictionary *_initialFrames;
    NSDictionary *_finalFrames;
}

- (instancetype)initWithContainerView:(UIView *)containerView
                          controllers:(NSDictionary *)controllers
                             animated:(BOOL)animated
                     transitionObject:(id <UIViewControllerAnimatedTransitioning>)transitioningObject
                    completionHandler:(dispatch_block_t)completionHandler
{
    NSParameterAssert(containerView);
    NSParameterAssert(controllers);
    NSParameterAssert(transitioningObject);
    NSParameterAssert(completionHandler);
    
    NSAssert(controllers[UITransitionContextFromViewControllerKey] != nil, @"UITransitionContextFromViewControllerKey missing");
    NSAssert(controllers[UITransitionContextToViewControllerKey] != nil, @"UITransitionContextToViewControllerKey missing");
    
    if((self = [super init])) {
        _containerView = containerView;
        _viewControllers = controllers;
        _animated = animated;
        _transitioningObject = transitioningObject;
        _completionHandler = [completionHandler copy];
        
        _initialFrames = @{UITransitionContextFromViewControllerKey: [NSValue valueWithRect:[self viewControllerForKey:UITransitionContextFromViewControllerKey].view.frame],
                           UITransitionContextToViewControllerKey: [NSValue valueWithRect:CGRectZero]};
        _finalFrames = @{UITransitionContextFromViewControllerKey: [NSValue valueWithRect:CGRectZero],
                         UITransitionContextToViewControllerKey: [NSValue valueWithRect:_containerView.bounds]};
    }
    
    return self;
}

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - Accessing the Transition Objects

- (UIView *)containerView
{
    return _containerView;
}

- (UIViewController *)viewControllerForKey:(NSString *)key
{
    NSParameterAssert(key);
    
    return _viewControllers[key];
}

#pragma mark - Defining the Transition Behaviors

- (BOOL)isAnimated
{
    return _animated;
}

- (BOOL)isInteractive
{
    return NO;
}

- (UIModalPresentationStyle)presentationStyle
{
    return UIModalPresentationCurrentContext;
}

#pragma mark - Reporting the Transition Progress

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    UIKitUnimplementedMethod();
}

- (void)finishInteractiveTransition
{
    UIKitUnimplementedMethod();
}

- (void)cancelInteractiveTransition
{
    UIKitUnimplementedMethod();
}

#pragma mark -

- (BOOL)transitionWasCancelled
{
    return NO;
}

- (void)completeTransition:(BOOL)didComplete
{
    if([_transitioningObject respondsToSelector:@selector(animationEnded:)]) {
        [_transitioningObject animationEnded:didComplete];
    }
    
    if(_completionHandler)
        _completionHandler();
}

#pragma mark - Getting the Transition Frame Rectangles

- (CGRect)initialFrameForViewController:(UIViewController *)viewController
{
    NSSet *keys = [_viewControllers keysOfEntriesPassingTest:^BOOL(NSString *key, UIViewController *possibleViewController, BOOL *stop) {
        return [possibleViewController isEqual:viewController];
    }];
    
    if(keys.count == 0)
        return CGRectZero;
    
    return [_initialFrames[keys.anyObject] rectValue];
}

- (CGRect)finalFrameForViewController:(UIViewController *)viewController
{
    NSSet *keys = [_viewControllers keysOfEntriesPassingTest:^BOOL(NSString *key, UIViewController *possibleViewController, BOOL *stop) {
        return [possibleViewController isEqual:viewController];
    }];
    
    if(keys.count == 0)
        return CGRectZero;
    
    return [_finalFrames[keys.anyObject] rectValue];
}

@end

#pragma mark -

@implementation _UIViewControllerAnimatedPresentModalTransitioning {
    UIViewController *_presented;
    UIViewController *_presenting;
    UIViewController *_source;
}

- (instancetype)initWithPresentedController:(UIViewController *)presented
                       presentingController:(UIViewController *)presenting
                           sourceController:(UIViewController *)source
{
    NSParameterAssert(presented);
    NSParameterAssert(presenting);
    NSParameterAssert(source);
    
    if((self = [super init])) {
        _presented = presented;
        _presenting = presenting;
        _source = source;
    }
    
    return self;
}

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark -

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    _presented.view.frame = [transitionContext containerView].bounds;
    _presented.view.alpha = 0.0;
    _presented.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [[transitionContext containerView] addSubview:_presented.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        _presented.view.alpha = 1.0;
        _presented.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [_presenting addChildViewController:_presented];
        
        [transitionContext completeTransition:finished];
    }];
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return [transitionContext isAnimated]? 0.25 : 0.0;
}

@end

#pragma mark -

@implementation _UIViewControllerAnimatedDismissModalTransitioning {
    UIViewController *_dismissing;
}

- (instancetype)initWithDismissingController:(UIViewController *)dismissing
{
    NSParameterAssert(dismissing);
    
    if((self = [super init])) {
        _dismissing = dismissing;
    }
    
    return self;
}

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark -

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        _dismissing.view.alpha = 0.0;
        _dismissing.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [_dismissing.view removeFromSuperview];
        [_dismissing removeFromParentViewController];
        
        _dismissing.view.transform = CGAffineTransformIdentity;
        _dismissing.view.alpha = 1.0;
        
        [transitionContext completeTransition:finished];
    }];
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return [transitionContext isAnimated]? 0.35 : 0.0;
}

@end
