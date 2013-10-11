//
//  UIViewController_Private.h
//  Pinna
//
//  Created by Kevin MacWhinnie on 12/6/12.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIViewController.h"

@class _UIViewControllerContextConcreteTransitioning;

@interface UIViewController () {
    UINavigationItem *_navigationItem;
    UIBarButtonItem *_editButtonItem;
    NSMutableArray *_childViewControllers;
    UIView *_view;
    
    _UIViewControllerContextConcreteTransitioning *_currentAnimationContext;
}

///Whether or not the controller is a root view controller in a window.
@property (nonatomic, getter=_isRootViewController) BOOL _rootViewController;

#pragma mark - Supporting External Presentation

- (BOOL)_isResponsibleForOwnModalPresentation;
- (void)_presentModallyWithinViewController:(UIViewController *)parent animate:(BOOL)animate completionHandler:(dispatch_block_t)completionHandler;

#pragma mark - readwrite

@property (nonatomic, getter=isMovingFromParentViewController) BOOL movingFromParentViewController;
@property (nonatomic, getter=isMovingToParentViewController) BOOL movingToParentViewController;
@property (nonatomic, getter=isBeingPresented) BOOL beingPresented;
@property (nonatomic, getter=isBeingDismissed) BOOL beingDismissed;

#pragma mark -

@property (nonatomic, readwrite) BOOL isViewLoaded;
@property (nonatomic, readwrite, unsafe_unretained) UIViewController *parentViewController;
@property (nonatomic, readwrite) UIViewController *presentingViewController;
@property (nonatomic, readwrite) UIViewController *presentedViewController;

@end
