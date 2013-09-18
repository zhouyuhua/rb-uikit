//
//  UIViewControllerTransitioning_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/17/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIViewControllerTransitioning.h"

@interface _UIViewControllerContextConcreteTransitioning : NSObject <UIViewControllerContextTransitioning>

- (instancetype)initWithContainerView:(UIView *)containerView
                          controllers:(NSDictionary *)controllers
                             animated:(BOOL)animated
                     transitionObject:(id <UIViewControllerAnimatedTransitioning>)transitioningObject
                    completionHandler:(dispatch_block_t)completionHandler;

@end

#pragma mark -

@interface _UIViewControllerAnimatedPresentModalTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithPresentedController:(UIViewController *)presented
                       presentingController:(UIViewController *)presenting
                           sourceController:(UIViewController *)source;

@end

#pragma mark -

@interface _UIViewControllerAnimatedDismissModalTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithDismissingController:(UIViewController *)dismissing;

@end
