//
//  UISplitViewController.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIViewController.h"

@protocol UISplitViewControllerDelegate;
@class UIPopoverController;

@interface UISplitViewController : UIViewController

@property (nonatomic, copy) NSArray *viewControllers;

/* Always NO */
@property (nonatomic) BOOL presentsWithGesture;

@property (nonatomic, unsafe_unretained) id <UISplitViewControllerDelegate> delegate;

@end

#pragma mark -

@protocol UISplitViewControllerDelegate <NSObject>
@optional

#pragma mark - Showing and Hiding View Controllers

- (void)splitViewController:(UISplitViewController *)splitViewController shouldHideViewController:(UIViewController *)controller inOrientation:(NSUInteger)orientation;
- (void)splitViewController:(UISplitViewController *)splitViewController willHideViewController:(UIViewController *)controller withBarButtonItem:(UIBarButtonItem *)item forPopoverController:(UIPopoverController *)controller;
- (void)splitViewController:(UISplitViewController *)splitViewController willShowViewController:(UIViewController *)controller invalidatingBarButtonItem:(UIBarButtonItem *)item;
- (void)splitViewController:(UISplitViewController *)splitViewController popoverController:(UIPopoverController *)popoverController willPresentViewController:(UIViewController *)controller;

#pragma mark - Overriding View Rotation Settings

- (NSUInteger)splitViewControllerSupportedInterfaceOrientations:(UISplitViewController *)splitViewController;
- (NSUInteger)splitViewControllerPreferredInterfaceOrientationForPresentation:(UISplitViewController *)splitViewController;

@end
