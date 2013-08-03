//
//  RKNavigationController.h
//  Pinna
//
//  Created by Kevin MacWhinnie on 12/6/12.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UIViewController.h"
#import "UINavigationBar.h"

@interface UINavigationController : UIViewController

- (id)initWithRootViewController:(UIViewController *)viewController;

#pragma mark - Stack

@property (nonatomic, readonly) UIViewController *topViewController;
@property (nonatomic, readonly) UIViewController *visibleViewController;
@property (nonatomic, readonly, copy) NSArray *viewControllers;

#pragma mark - Navigation Bar

@property (nonatomic, readonly) UINavigationBar *navigationBar;
@property(nonatomic, getter=isNavigationBarHidden) BOOL navigationBarHidden;

#pragma mark - Pushing and Popping Stack Items

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)popViewControllerAnimated:(BOOL)animated;
- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)popToRootViewControllerAnimated:(BOOL)animated;

@end
