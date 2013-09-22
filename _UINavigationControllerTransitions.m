//
//  _UINavigationControllerTransitions.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/22/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "_UINavigationControllerTransitions.h"
#import "UIViewController.h"
#import "UIView.h"

static CGFloat const kMaxShieldAlpha = 0.2;

@implementation _UINavigationControllerPushTransition

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *source = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *destination = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    CGRect containerBounds = containerView.bounds;
    
    if(!source) {
        destination.view.frame = containerBounds;
        [containerView addSubview:destination.view];
        
        [transitionContext completeTransition:YES];
        
        return;
    }
    
    CGRect initialSourceFrame = containerBounds;
    source.view.frame = initialSourceFrame;
    
    CGRect initialDestinationFrame;
    initialDestinationFrame.size = containerBounds.size;
    initialDestinationFrame.origin.x = CGRectGetMaxX(containerBounds);
    initialDestinationFrame.origin.y = CGRectGetMinY(containerBounds);
    destination.view.frame = initialDestinationFrame;
    
    BOOL shouldApplyBackgroundColor = (destination.view.backgroundColor.alphaComponent == 0.0);
    if(shouldApplyBackgroundColor)
        destination.view.backgroundColor = containerView.backgroundColor;
    
    [containerView addSubview:destination.view];
    
    UIView *shieldView = [[UIView alloc] initWithFrame:containerBounds];
    shieldView.backgroundColor = [UIColor blackColor];
    shieldView.alpha = 0.0;
    [containerView insertSubview:shieldView aboveSubview:source.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        CGRect finalSourceFrame = initialSourceFrame;
        finalSourceFrame.origin.x = round(-(CGRectGetWidth(containerBounds) / 3.0));
        source.view.frame = finalSourceFrame;
        
        CGRect finalDestinationFrame = containerBounds;
        destination.view.frame = finalDestinationFrame;
        
        shieldView.alpha = kMaxShieldAlpha;
    } completion:^(BOOL finished) {
        [shieldView removeFromSuperview];
        [source.view removeFromSuperview];
        
        if(shouldApplyBackgroundColor)
            destination.view.backgroundColor = [UIColor clearColor];
        
        [transitionContext completeTransition:finished];
    }];
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if([transitionContext isAnimated])
        return UIKitDefaultAnimationDuration;
    else
        return 0.0;
}

@end

#pragma mark -

@implementation _UINavigationControllerPopTransition

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *source = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *destination = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    CGRect containerBounds = containerView.bounds;
    
    if(!source) {
        destination.view.frame = containerBounds;
        [containerView addSubview:destination.view];
        
        [transitionContext completeTransition:YES];
        
        return;
    }
    
    CGRect initialSourceFrame = containerBounds;
    source.view.frame = initialSourceFrame;
    
    CGRect initialDestinationFrame;
    initialDestinationFrame.size = containerBounds.size;
    initialDestinationFrame.origin.x = round(-(CGRectGetWidth(containerBounds) / 3.0));
    initialDestinationFrame.origin.y = CGRectGetMinY(containerBounds);
    destination.view.frame = initialDestinationFrame;
    
    BOOL shouldApplyBackgroundColor = (source.view.backgroundColor.alphaComponent == 0.0);
    if(shouldApplyBackgroundColor)
        source.view.backgroundColor = containerView.backgroundColor;
    
    [containerView insertSubview:destination.view belowSubview:source.view];
    
    UIView *shieldView = [[UIView alloc] initWithFrame:containerBounds];
    shieldView.backgroundColor = [UIColor blackColor];
    shieldView.alpha = kMaxShieldAlpha;
    [containerView insertSubview:shieldView aboveSubview:destination.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        CGRect finalSourceFrame = initialSourceFrame;
        finalSourceFrame.origin.x = CGRectGetMaxX(containerBounds);
        source.view.frame = finalSourceFrame;
        
        CGRect finalDestinationFrame = containerBounds;
        destination.view.frame = finalDestinationFrame;
        
        shieldView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [shieldView removeFromSuperview];
        [source.view removeFromSuperview];
        
        if(shouldApplyBackgroundColor)
            source.view.backgroundColor = [UIColor clearColor];
        
        [transitionContext completeTransition:finished];
    }];
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if([transitionContext isAnimated])
        return UIKitDefaultAnimationDuration;
    else
        return 0.0;
}

@end
