//
//  UIViewControllerTransitioning.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/17/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"

@class UIViewController;

UIKIT_EXTERN NSString *const UITransitionContextFromViewControllerKey;
UIKIT_EXTERN NSString *const UITransitionContextToViewControllerKey;

typedef NS_ENUM(NSUInteger, UIModalPresentationStyle) {
    UIModalPresentationFullScreen = 0,
    UIModalPresentationPageSheet,
    UIModalPresentationFormSheet,
    UIModalPresentationCurrentContext,
    UIModalPresentationCustom,
    UIModalPresentationNone
};

typedef NS_ENUM(NSUInteger, UIModalTransitionStyle) {
    UIModalTransitionStyleCoverVertical = 0,
    UIModalTransitionStyleFlipHorizontal,
    UIModalTransitionStyleCrossDissolve,
    UIModalTransitionStylePartialCurl,
};

@protocol UIViewControllerContextTransitioning <NSObject>

#pragma mark - Accessing the Transition Objects

- (UIView *)containerView;
- (UIViewController *)viewControllerForKey:(NSString *)key;

#pragma mark - Defining the Transition Behaviors

- (BOOL)isAnimated;
- (BOOL)isInteractive;
- (UIModalPresentationStyle)presentationStyle;

#pragma mark - Reporting the Transition Progress

- (void)updateInteractiveTransition:(CGFloat)percentComplete UIKIT_UNIMPLEMENTED;
- (void)finishInteractiveTransition UIKIT_UNIMPLEMENTED;
- (void)cancelInteractiveTransition UIKIT_UNIMPLEMENTED;

#pragma mark -

- (BOOL)transitionWasCancelled;
- (void)completeTransition:(BOOL)didComplete;

#pragma mark - Getting the Transition Frame Rectangles

- (CGRect)initialFrameForViewController:(UIViewController *)viewController;
- (CGRect)finalFrameForViewController:(UIViewController *)viewController;

@end

#pragma mark -

@protocol UIViewControllerAnimatedTransitioning <NSObject>

#pragma mark - Performing a Transition
@required
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;

@optional
- (void)animationEnded:(BOOL)completed;

#pragma mark - Reporting Transition Duration
@required
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext;

@end

@protocol UIViewControllerInteractiveTransitioning <NSObject>

#pragma mark - Starting an Interactive Transition

- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext;

#pragma mark - Providing a Transition’s Completion Characteristics

@optional
- (UIViewAnimationCurve)completionCurve;
- (CGFloat)completionSpeed;

@end

#pragma mark -

@protocol UIViewControllerTransitioningDelegate <NSObject>
@optional

#pragma mark - Getting the Animator Objects

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissedController;

#pragma mark - Getting the Interactive Transition Object

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator;
- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator;

@end
