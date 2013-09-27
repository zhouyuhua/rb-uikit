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

@class UIToolbar;
@protocol UINavigationControllerDelegate;

typedef enum {
    UINavigationControllerOperationNone,
    UINavigationControllerOperationPush,
    UINavigationControllerOperationPop
} UINavigationControllerOperation;

@interface UINavigationController : UIViewController

- (instancetype)initWithRootViewController:(UIViewController *)viewController;
- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass;

#pragma mark - Stack

@property (nonatomic, readonly) UIViewController *topViewController;
@property (nonatomic, readonly) UIViewController *visibleViewController;
@property (nonatomic, copy) NSArray *viewControllers;
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;

#pragma mark - Configuring Navigation Bars

@property (nonatomic, readonly) UINavigationBar *navigationBar;
@property(nonatomic, getter=isNavigationBarHidden) BOOL navigationBarHidden;
- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;

#pragma mark - Pushing and Popping Stack Items

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)popViewControllerAnimated:(BOOL)animated;
- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)popToRootViewControllerAnimated:(BOOL)animated;

#pragma mark - Accessing the Delegate

@property (nonatomic, unsafe_unretained) id <UINavigationControllerDelegate> delegate;

#pragma mark - Configuring Custom Toolbars

@property (nonatomic, readonly) UIToolbar *toolbar;

- (void)setToolbarHidden:(BOOL)hidden animated:(BOOL)animated;
@property (nonatomic, getter=isToolbarHidden) BOOL toolbarHidden;

@end

#pragma mark -

@protocol UINavigationControllerDelegate <NSObject>
@optional

#pragma mark - Responding to a View Controller Being Shown

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)controller animated:(BOOL)animated;
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)controller animated:(BOOL)animated;

#pragma mark - Supporting Custom Transition Animations

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromController
                                                  toViewController:(UIViewController *)toController;
- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>)transitioning;

#pragma mark -

- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController UIKIT_UNIMPLEMENTED;
- (NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController UIKIT_UNIMPLEMENTED;

@end
