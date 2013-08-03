//
//  RKViewController.h
//  Pinna
//
//  Created by Kevin MacWhinnie on 12/6/12.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIResponder.h"

@class UINavigationController, UINavigationItem, UIView;

@interface UIViewController : UIResponder

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

@property (nonatomic, readonly, weak) UINavigationController *navigationController;
@property (nonatomic, readonly) UINavigationItem *navigationItem;

#pragma mark - Containing View Controllers

@property (nonatomic, readonly) UIViewController *parentViewController;
- (void)willMoveToParentViewController:(UIViewController *)parent;
- (void)didMoveToParentViewController:(UIViewController *)parent;

#pragma mark -

@property (nonatomic, readonly) NSArray *childViewControllers;

- (void)addChildViewController:(UIViewController *)childController;
- (void)removeFromParentViewController;

#pragma mark - Actions

- (IBAction)popFromNavigationController:(id)sender;

@end
