//
//  UIViewController_Private.h
//  Pinna
//
//  Created by Kevin MacWhinnie on 12/6/12.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIViewController.h"

@interface UIViewController ()

///Whether or not the controller is a root view controller in a window.
@property (nonatomic, getter=_isRootViewController) BOOL _rootViewController;

#pragma mark - readwrite

@property (nonatomic, getter=isMovingFromParentViewController) BOOL movingFromParentViewController;
@property (nonatomic, getter=isMovingToParentViewController) BOOL movingToParentViewController;
@property (nonatomic, getter=isBeingPresented) BOOL beingPresented;
@property (nonatomic, getter=isBeingDismissed) BOOL beingDismissed;

#pragma mark -

@property (nonatomic, readwrite) BOOL isViewLoaded;
@property (nonatomic, readwrite) UIViewController *parentViewController;
@property (nonatomic, readwrite) UIViewController *presentingViewController;
@property (nonatomic, readwrite) UIViewController *presentedViewController;

@end
