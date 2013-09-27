//
//  UIViewControllerTransitioning_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/17/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIViewControllerTransitioning.h"

///The _UIViewControllerContextConcreteTransitioning class encapsulates the default concrete
///implementation of <UIViewControllerContextTransitioning> used by RB-UIKit.
@interface _UIViewControllerContextConcreteTransitioning : NSObject <UIViewControllerContextTransitioning>

///Initialize the receiver with the values necessary to operate.
///
/// \param  containerView       The view that will contain the transition. Required.
/// \param  controllers         The controllers participating in the transition. Must contain values for the keys
///                             keys UITransitionContextFromViewControllerKey, UITransitionContextToViewControllerKey.
///                             May not be nil.
/// \param  animated            Whether or not the transition is animated.
/// \param  transitioningObject The object that implements the actual transition. May not be nil.
/// \param  completionHandler   The block to invoke when the transition is completed. Required.
///
/// \result A fully initialized transitioning context.
///
- (instancetype)initWithContainerView:(UIView *)containerView
                          controllers:(NSDictionary *)controllers
                             animated:(BOOL)animated
                     transitionObject:(id <UIViewControllerAnimatedTransitioning>)transitioningObject
                    completionHandler:(dispatch_block_t)completionHandler;

@end

#pragma mark -

///The _UIViewControllerAnimatedPresentModalTransitioning class encapsulates the default modal presentation transition.
@interface _UIViewControllerAnimatedPresentModalTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

/// \seealso(<UIViewControllerAnimatedTransitioning>)
- (instancetype)initWithPresentedController:(UIViewController *)presented
                       presentingController:(UIViewController *)presenting
                           sourceController:(UIViewController *)source;

@end

#pragma mark -

///The _UIViewControllerAnimatedDismissModalTransitioning class encapsulates the default modal dismissal transition.
@interface _UIViewControllerAnimatedDismissModalTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

/// \seealso(<UIViewControllerAnimatedTransitioning>)
- (instancetype)initWithDismissingController:(UIViewController *)dismissing;

@end
