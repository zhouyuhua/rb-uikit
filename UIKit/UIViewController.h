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

@class UINavigationController, UINavigationItem, UIView;

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

#pragma mark - Appearance

- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;

#pragma mark - Properties

@property (nonatomic, readonly) BOOL isViewLoaded;
@property (nonatomic) UIView *view;

#pragma mark - Navigation Stack Support

@property (nonatomic, readonly) UINavigationController *navigationController;
@property (nonatomic, readonly) UINavigationItem *navigationItem;

@property (nonatomic, readonly) BOOL hidesBottomBarWhenPushed;

- (void)setToolbarItems:(NSArray *)items animated:(BOOL)animated;
@property (nonatomic, copy) NSArray *toolbarItems;

#pragma mark - Containing View Controllers

@property (nonatomic, readonly) UIViewController *parentViewController;
- (void)willMoveToParentViewController:(UIViewController *)parent;
- (void)didMoveToParentViewController:(UIViewController *)parent;

#pragma mark -

@property (nonatomic, readonly) NSArray *childViewControllers;
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
