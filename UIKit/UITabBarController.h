//
//  UITabBarController.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIViewController.h"

@protocol UITabBarControllerDelegate;
@class UITabBar;

@interface UITabBarController : UIViewController

#pragma mark - Accessing the Tab Bar Controller Properties

@property (nonatomic, unsafe_unretained) id <UITabBarControllerDelegate> delegate;
@property (nonatomic, readonly) UITabBar *tabBar;

#pragma mark - Managing the View Controllers

@property (nonatomic, copy) NSArray *viewControllers;
- (void)setViewControllers:(NSArray *)controllers animated:(BOOL)animate;

@property (nonatomic, copy) NSArray *customizableViewControllers;
@property (nonatomic) UIViewController *moreNavigationController;

#pragma mark - Managing the Selected Tab

@property (nonatomic, unsafe_unretained) UIViewController *selectedViewController;
@property (nonatomic) NSUInteger selectedIndex;

@end

#pragma mark -

@protocol UITabBarControllerDelegate <NSObject>
@optional

#pragma mark - Managing Tab Bar Selections

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)controller;
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)controller;

#pragma mark - Managing Tab Bar Customizations

- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)controllers;
- (void)tabBarController:(UITabBarController *)tabBarController willEndCustomizingViewControllers:(NSArray *)controllers changed:(BOOL)changed;
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)controllers changed:(BOOL)changed;

#pragma mark - Overriding View Rotation Settings

- (NSUInteger)tabBarControllerSupportedInterfaceOrientations:(UITabBarController *)tabBarController;
- (NSUInteger)tabBarControllerPreferredInterfaceOrientationForPresentation:(UITabBarController *)tabBarController;

#pragma mark - Supporting Custom Tab Bar Transition Animations

- (id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromController toViewController:(UIViewController *)toController;
- (id <UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>)controller;

@end
