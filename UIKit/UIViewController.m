//
//  RKViewController.m
//  Pinna
//
//  Created by Kevin MacWhinnie on 12/6/12.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIViewController.h"
#import "UIViewController_Private.h"
#import "UIViewControllerTransitioning_Private.h"
#import "UIView_Private.h"
#import "UIResponder_Private.h"
#import "UINavigationController.h"
#import "UITabBarController.h"
#import "UINavigationItem.h"
#import "UITabBar.h"
#import "UIToolbar.h"

#import "UIWindow.h"

@implementation UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(nibNameOrNil) {
        UIKitUnimplementedMethod();
        return nil;
    } else {
        return [super init];
    }
}

- (id)init
{
    return [self initWithNibName:self.nibName bundle:self.nibBundle];
}

#pragma mark -

- (NSBundle *)nibBundle
{
    return [NSBundle bundleForClass:[self class]];
}

- (NSString *)nibName
{
    NSBundle *nibBundle = self.nibBundle;
    
    NSString *nibName = nil;
    Class class = [self class];
    while (class && [nibBundle pathForResource:NSStringFromClass(class) ofType:@"nib"] == nil) {
        class = [class superclass];
    }
    
    if(class)
        nibName = NSStringFromClass(class);
    
    return nibName;
}

#pragma mark - <NSCoding>

- (id)initWithCoder:(NSCoder *)aDecoder
{
    UIKitUnimplementedMethod();
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    UIKitUnimplementedMethod();
}

#pragma mark - Appearance

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)viewWillDisappear:(BOOL)animated
{
}

- (void)viewDidDisappear:(BOOL)animated
{
}

#pragma mark - Managing the View

- (void)viewWillLoad
{
}

- (void)viewDidLoad
{
}

- (void)loadView
{
    if(!self.isViewLoaded) {
        [self viewWillLoad];
        
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 320.0)];
        
        [self viewDidLoad];
    }
}

#pragma mark -

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    
    _tabBarItem.title = title;
    _navigationItem.title = title;
}

#pragma mark - Adding Editing Behaviors to Your View Controller

- (void)setEditing:(BOOL)editing
{
    [self setEditing:editing animated:NO];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    _editing = editing;
}

#pragma mark -

- (void)_toggleEditingStatus:(UIBarButtonItem *)item
{
    [self setEditing:!self.editing animated:YES];
}

#pragma mark - Configuring a Navigation Interface

- (UINavigationItem *)navigationItem
{
    if(!_navigationItem) {
        _navigationItem = [[UINavigationItem alloc] initWithTitle:self.title];
    }
    
    return _navigationItem;
}

- (UIBarButtonItem *)editButtonItem
{
    if(!_editButtonItem) {
        _editButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                        target:self
                                                                        action:@selector(_toggleEditingStatus:)];
    }
    
    return _editButtonItem;
}

#pragma mark -

- (void)setToolbarItems:(NSArray *)toolbarItems
{
    [self setToolbarItems:toolbarItems animated:NO];
}

- (void)setToolbarItems:(NSArray *)items animated:(BOOL)animated
{
    _toolbarItems = [items copy];
    [self.navigationController.toolbar setItems:items animated:animated];
}

#pragma mark - Configuring Tab Bar Items

- (UITabBarItem *)tabBarItem
{
    if(!_tabBarItem) {
        _tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title
                                                    image:nil 
                                                      tag:(NSInteger)self.class];
    }
    
    return _tabBarItem;
}

#pragma mark - Containing View Controllers

- (void)willMoveToParentViewController:(UIViewController *)parent
{
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
}

#pragma mark -

- (NSMutableArray *)mutableChildViewControllers
{
    if(!_childViewControllers)
        _childViewControllers = [NSMutableArray array];
    
    return _childViewControllers;
}

- (NSArray *)childViewControllers
{
    return [self mutableChildViewControllers];
}

- (void)addChildViewController:(UIViewController *)childController
{
    NSParameterAssert(childController);
    
    [childController willMoveToParentViewController:self];
    [[self mutableChildViewControllers] addObject:childController];
    childController.parentViewController = self;
    [childController didMoveToParentViewController:self];
}

- (void)removeFromParentViewController
{
    [self willMoveToParentViewController:nil];
    [[self.parentViewController mutableChildViewControllers] removeObject:self];
    self.parentViewController = nil;
    [self didMoveToParentViewController:nil];
}

#pragma mark - Getting Other Related View Controllers

- (UINavigationController *)navigationController
{
    if([self.parentViewController isKindOfClass:[UINavigationController class]])
        return (UINavigationController *)self.parentViewController;
    else
        return [self.parentViewController navigationController];
}

- (UISplitViewController *)splitViewController
{
    return nil;
}

- (UITabBarController *)tabBarController
{
    if([self.parentViewController isKindOfClass:[UITabBarController class]])
        return (UITabBarController *)self.parentViewController;
    else
        return [self.parentViewController tabBarController];
}

#pragma mark - Responder

- (UIResponder *)nextResponder
{
    return self.view.superview;
}

#pragma mark - Properties

- (void)setView:(UIView *)view
{
    _view._viewController = nil;
    
    _view = view;
    _view._viewController = self;
    self.isViewLoaded = YES;
}

- (UIView *)view
{
    if(!_view)
        [self loadView];
    
    return _view;
}

#pragma mark - Presenting Another View Controller’s Content

- (id <UIViewControllerAnimatedTransitioning>)_animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    if([_transitioningDelegate respondsToSelector:@selector(animationControllerForPresentedController:presentingController:sourceController:)]) {
        return [_transitioningDelegate animationControllerForPresentedController:presented
                                                            presentingController:presenting
                                                                sourceController:source];
    }
    
    return [[_UIViewControllerAnimatedPresentModalTransitioning alloc] initWithPresentedController:presented
                                                                              presentingController:presenting
                                                                                  sourceController:presenting];
}

- (id <UIViewControllerAnimatedTransitioning>)_animationControllerForDismissedController:(UIViewController *)dismissedController
{
    if([_transitioningDelegate respondsToSelector:@selector(animationControllerForDismissedController:)]) {
        return [_transitioningDelegate animationControllerForDismissedController:dismissedController];
    }
    
    return [[_UIViewControllerAnimatedDismissModalTransitioning alloc] initWithDismissingController:dismissedController];
}

- (UIViewController *)_presentationController
{
    return self.parentViewController._presentationController ?: self;
}

#pragma mark -

- (void)presentViewController:(UIViewController *)childController animated:(BOOL)animated completion:(dispatch_block_t)completionHandler
{
    NSParameterAssert(childController);
    
    if(self.presentingViewController) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"UIViewController %@ cannot present more than one controller at once", self];
    }
    
    dispatch_block_t internalCompletionHandler = ^{
        _currentAnimationContext = nil;
        
        childController.beingPresented = NO;
        childController.movingToParentViewController = NO;
        
        self.presentedViewController = childController;
        childController.presentingViewController = self;
        
        [childController viewDidAppear:animated];
        
        if(completionHandler)
            completionHandler();
    };
    UIViewController *presentingController = self._presentationController;
    NSDictionary *controllers = @{UITransitionContextFromViewControllerKey: self,
                                  UITransitionContextToViewControllerKey: childController};
    id <UIViewControllerAnimatedTransitioning> transitioningObject = [self _animationControllerForPresentedController:childController
                                                                                                 presentingController:presentingController
                                                                                                     sourceController:self];
    _currentAnimationContext = [[_UIViewControllerContextConcreteTransitioning alloc] initWithContainerView:presentingController.view
                                                                                                controllers:controllers
                                                                                                   animated:animated
                                                                                           transitionObject:transitioningObject
                                                                                          completionHandler:internalCompletionHandler];
    childController.beingPresented = YES;
    childController.movingToParentViewController = YES;
    [childController viewWillAppear:animated];
    [transitioningObject animateTransition:_currentAnimationContext];
}

- (void)dismissViewControllerAnimated:(BOOL)animated completion:(dispatch_block_t)completionHandler
{
    if(self.isBeingPresented) {
        [self.presentingViewController dismissViewControllerAnimated:animated completion:completionHandler];
        return;
    }
    
    if(!self.presentedViewController) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"Attempting to dismiss modal view controller when none is presented"];
    }
    
    dispatch_block_t internalCompletionHandler = ^{
        _currentAnimationContext = nil;
        
        self.presentedViewController.beingDismissed = NO;
        self.presentedViewController.movingFromParentViewController = NO;
        
        self.presentedViewController.presentingViewController = nil;
        [self.presentedViewController viewDidDisappear:animated];
        self.presentedViewController = nil;
        
        if(completionHandler)
            completionHandler();
    };
    NSDictionary *controllers = @{UITransitionContextFromViewControllerKey: self.presentedViewController,
                                  UITransitionContextToViewControllerKey: self};
    id <UIViewControllerAnimatedTransitioning> transitioningObject = [self _animationControllerForDismissedController:self.presentedViewController];
    _currentAnimationContext = [[_UIViewControllerContextConcreteTransitioning alloc] initWithContainerView:self.view
                                                                                                controllers:controllers
                                                                                                   animated:animated
                                                                                           transitionObject:transitioningObject
                                                                                          completionHandler:internalCompletionHandler];
    self.presentedViewController.beingDismissed = YES;
    self.presentedViewController.movingFromParentViewController = YES;
    [self.presentedViewController viewWillDisappear:animated];
    [transitioningObject animateTransition:_currentAnimationContext];
}

#pragma mark - Actions

- (IBAction)popFromNavigationController:(id)sender
{
    if(self.navigationController.visibleViewController == self)
        [self.navigationController popViewControllerAnimated:YES];
}

@end
