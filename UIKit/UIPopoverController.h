//
//  UIPopoverController.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIViewController.h"
#import "UIPopoverBackgroundView.h"

@protocol UIPopoverControllerDelegate;

@interface UIPopoverController : UIViewController

#pragma mark - Initializing the Popover

- (instancetype)initWithContentViewController:(UIViewController *)controller;

#pragma mark - Presenting and Dismissing the Popover

- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animate;
- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animate;
- (void)dismissPopoverAnimated:(BOOL)animate;

#pragma mark - Configuring the Popover Content

@property (nonatomic) UIViewController *contentViewController;
- (void)setContentViewController:(UIViewController *)controller animated:(BOOL)animate;

@property (nonatomic) CGSize popoverContentSize;
- (void)setPopoverContentSize:(CGSize)popoverContentSize animated:(BOOL)animate;
@property (nonatomic, copy) NSArray *passthroughViews;

#pragma mark - Getting the Popover Attributes

@property (nonatomic, getter=isPopovervisible, readonly) BOOL popoverVisible;
@property (nonatomic, readonly) UIPopoverArrowDirection popoverArrowDirection;

#pragma mark - Accessing the Delegate

@property (nonatomic, unsafe_unretained) id <UIPopoverControllerDelegate> delegate;

#pragma mark - Customizing the Popover Appearance

@property (nonatomic) UIEdgeInsets popoverLayoutMargins;
@property (nonatomic, assign) Class popoverBackgroundViewClass;
@property (nonatomic) UIColor *backgroundColor;

@end

#pragma mark -

@protocol UIPopoverControllerDelegate <NSObject>
@optional

#pragma mark - Responding to Popover Position Changes

- (void)popoverController:(UIPopoverController *)popover willRepositionPopoverToRect:(CGRect)rect inView:(UIView *)view;

#pragma mark - Managing the Popover’s Dismissal

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popover;
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popover;

@end
