//
//  RKViewController.h
//  Pinna
//
//  Created by Kevin MacWhinnie on 12/6/12.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIResponder.h"
#import "UIDevice.h"
#import "UIViewControllerTransitioning.h"

@class UINavigationController, UITabBarController, UISplitViewController;
@class UINavigationItem, UIBarButtonItem, UITabBarItem, UIView;

typedef NS_ENUM(NSInteger, UIInterfaceOrientation) {
    UIInterfaceOrientationPortrait           = UIDeviceOrientationPortrait,
    UIInterfaceOrientationPortraitUpsideDown = UIDeviceOrientationPortraitUpsideDown,
    UIInterfaceOrientationLandscapeLeft      = UIDeviceOrientationLandscapeRight,
    UIInterfaceOrientationLandscapeRight     = UIDeviceOrientationLandscapeLeft
};

@interface UIViewController : UIResponder <NSCoding>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

#pragma mark -

- (NSBundle *)nibBundle;
- (NSString *)nibName;

#pragma mark - Loading

- (void)viewWillLoad;
- (void)viewDidLoad;
- (void)loadView;

#pragma mark - Responding to View Events

- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;

#pragma mark -

- (void)viewWillLayoutSubviews;
- (void)viewDidLayoutSubviews;

#pragma mark - Managing the View

@property (nonatomic, readonly) BOOL isViewLoaded;
@property (nonatomic) UIView *view;
@property (nonatomic, copy) NSString *title;

#pragma mark - Adding Editing Behaviors to Your View Controller

@property (nonatomic, getter=isEditing) BOOL editing;
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

#pragma mark - Configuring a Navigation Interface

@property (nonatomic, readonly) UINavigationItem *navigationItem;
- (UIBarButtonItem *)editButtonItem;

@property (nonatomic, readonly) BOOL hidesBottomBarWhenPushed;

- (void)setToolbarItems:(NSArray *)items animated:(BOOL)animated;
@property (nonatomic, copy) NSArray *toolbarItems;

#pragma mark - Configuring Tab Bar Items

@property (nonatomic) UITabBarItem *tabBarItem;

#pragma mark - Containing View Controllers

- (void)willMoveToParentViewController:(UIViewController *)parent;
- (void)didMoveToParentViewController:(UIViewController *)parent;

#pragma mark -

@property (nonatomic, readonly) NSArray *childViewControllers;

#pragma mark - Getting Other Related View Controllers

@property (nonatomic, readonly) UINavigationController *navigationController;
@property (nonatomic, readonly) UISplitViewController *splitViewController;
@property (nonatomic, readonly) UITabBarController *tabBarController;

#pragma mark -

@property (nonatomic, readonly) UIViewController *parentViewController;
@property (nonatomic, readonly) UIViewController *presentingViewController;
@property (nonatomic, readonly) UIViewController *presentedViewController;

#pragma mark -

- (void)addChildViewController:(UIViewController *)childController;
- (void)removeFromParentViewController;

#pragma mark - Testing for Specific Kinds of View Transitions

- (BOOL)isMovingFromParentViewController;
- (BOOL)isMovingToParentViewController;
- (BOOL)isBeingPresented;
- (BOOL)isBeingDismissed;

#pragma mark - Presenting Another View Controller’s Content

- (void)presentViewController:(UIViewController *)childController animated:(BOOL)animated completion:(dispatch_block_t)completionHandler;
- (void)dismissViewControllerAnimated:(BOOL)aniamted completion:(dispatch_block_t)completionHandler;

#pragma mark -

@property (nonatomic) UIModalTransitionStyle modalTransitionStyle; //Ignored
@property (nonatomic) UIModalPresentationStyle modalPresentationStyle; //Ignored
@property (nonatomic) BOOL definesPresentationContext; //Ignored
@property (nonatomic, unsafe_unretained) id <UIViewControllerTransitioningDelegate> transitioningDelegate;
@property (nonatomic) BOOL providesPresentationContextTransitionStyle; //Ignored

#pragma mark - Actions

- (IBAction)popFromNavigationController:(id)sender;

@end
