//
//  RKNavigationController.m
//  Pinna
//
//  Created by Kevin MacWhinnie on 12/6/12.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UINavigationController_Private.h"
#import "UINavigationBar_Private.h"
#import "UIViewController_Private.h"
#import "UIResponder_Private.h"
#import "UIView.h"
#import "UIBarButtonItem_Private.h"

@implementation UINavigationController

- (id)init
{
    return [self initWithRootViewController:nil];
}

- (id)initWithRootViewController:(UIViewController *)viewController
{
    if((self = [super init])) {
        _viewControllers = [NSMutableArray array];
        
        self.view = [[UIView alloc] initWithFrame:NSMakeRect(0.0, 0.0, 320.0, 500.0)];
        self.contentView = [[UIView alloc] initWithFrame:self.view.frame];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentView.backgroundColor = [UIColor windowBackgroundColor];
        [self.view addSubview:self.contentView];
        
        _navigationBar = [[UINavigationBar alloc] initWithFrame:NSMakeRect(0.0, 0.0, 320.0, 40.0)];
        _navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _navigationBar._navigationController = self;
        [self.view addSubview:_navigationBar];
        
        [self layoutViews];
        
        if(viewController)
            [self pushViewController:viewController animated:NO];
    }
    
    return self;
}

- (void)layoutViews
{
    CGRect contentArea = self.view.frame;
    contentArea.origin = CGPointZero;
    
    CGRect navigationBarFrame = self.navigationBar.frame;
    navigationBarFrame.size.width = CGRectGetWidth(contentArea);
    self.navigationBar.frame = navigationBarFrame;
    
    CGRect contentViewFrame = self.contentView.frame;
    if(self.navigationBarHidden) {
        contentViewFrame.origin = CGPointZero;
        contentViewFrame.size = contentArea.size;
    } else {
        contentViewFrame.origin.y = CGRectGetHeight(self.navigationBar.bounds);
        contentViewFrame.size.width = CGRectGetWidth(contentArea);
        contentViewFrame.size.height = CGRectGetHeight(contentArea) - CGRectGetHeight(self.navigationBar.frame);
    }
    
    self.contentView.frame = contentViewFrame;
}

#pragma mark - Stack

- (UIViewController *)topViewController
{
    return self.viewControllers[0];
}

+ (NSSet *)keyPathsForValuesAffectingVisibleViewController
{
    return [NSSet setWithObjects:@"viewControllers", nil];
}

- (UIViewController *)visibleViewController
{
    return [self.viewControllers lastObject];
}

@synthesize viewControllers = _viewControllers;

#pragma mark - Navigation Bar

@synthesize navigationBar = _navigationBar;

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden
{
    self.navigationBar.hidden = navigationBarHidden;
    [self layoutViews];
}

- (BOOL)isNavigationBarHidden
{
    return self.navigationBar.isHidden;
}

#pragma mark - Pushing and Popping Stack Items

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSParameterAssert(viewController);
    
    NSAssert((viewController.navigationController == nil),
             @"Cannot push view controller %@ into multiple navigation controllers.", viewController);
    NSAssert((viewController.view.superview == nil),
              @"View controller %@ cannot be hosted in multiple places.", viewController);
    
    [self willChangeValueForKey:@"viewControllers"];
    [_viewControllers addObject:viewController];
    viewController.navigationController = self;
    [self didChangeValueForKey:@"viewControllers"];
    
    [self.visibleViewController viewWillDisappear:animated];
    [viewController viewWillAppear:animated];
    if(animated) {
        [self replaceVisibleViewWithViewPushingFromRight:viewController.view completionHandler:^{
            [self.visibleViewController viewDidDisappear:animated];
            [viewController viewDidAppear:animated];
        }];
    } else {
        [self replaceVisibleViewWithView:viewController.view];
        
        [self.visibleViewController viewDidDisappear:animated];
        [viewController viewDidAppear:animated];
    }
    
    if([self.viewControllers count] > 1) {
        NSString *backButtonTitle = [self.viewControllers[self.viewControllers.count - 2] navigationItem].title;
        if([backButtonTitle length] > 15)
            backButtonTitle = @"Back";
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:backButtonTitle
                                                                       style:UIBarButtonItemStyle_Private_Back
                                                                      target:self
                                                                      action:@selector(popFromNavigationController:)];
        viewController.navigationItem.backBarButtonItem = backButton;
    }
    
    [_navigationBar pushNavigationItem:viewController.navigationItem animated:animated];
}

- (void)popViewControllerAnimated:(BOOL)animated
{
    if([self.viewControllers count] == 1)
        return;
    
    [self willChangeValueForKey:@"viewControllers"];
    UIViewController *previousViewController = self.visibleViewController;
    [_viewControllers removeLastObject];
    previousViewController.navigationController = nil;
    [self didChangeValueForKey:@"viewControllers"];
    
    [previousViewController viewWillDisappear:animated];
    [self.visibleViewController viewWillAppear:animated];
    if(animated) {
        [self replaceVisibleViewWithViewPushingFromLeft:self.visibleViewController.view completionHandler:^{
            [previousViewController viewDidDisappear:animated];
            [self.visibleViewController viewDidAppear:animated];
        }];
    } else {
        [self replaceVisibleViewWithView:self.visibleViewController.view];
        
        [previousViewController viewDidDisappear:animated];
        [self.visibleViewController viewDidAppear:animated];
    }
    
    [_navigationBar popNavigationItemAnimated:animated];
}

- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSUInteger indexOfViewController = [self.viewControllers indexOfObject:viewController];
    NSAssert((indexOfViewController != NSNotFound),
             @"View controller %@ is not in navigation stack", viewController);
    
    [self willChangeValueForKey:@"viewControllers"];
    NSIndexSet *indexesToRemove = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexOfViewController + 1, _viewControllers.count - (indexOfViewController + 1))];
    [_viewControllers enumerateObjectsAtIndexes:indexesToRemove options:0 usingBlock:^(UIViewController *viewController, NSUInteger index, BOOL *stop) {
        viewController.navigationController = nil;
    }];
    [_viewControllers removeObjectsAtIndexes:indexesToRemove];
    [self didChangeValueForKey:@"viewControllers"];
    
    [self.visibleViewController viewWillDisappear:animated];
    [viewController viewWillAppear:animated];
    if(animated) {
        [self replaceVisibleViewWithViewPushingFromLeft:viewController.view completionHandler:^{
            [self.visibleViewController viewDidDisappear:animated];
            [viewController viewDidAppear:animated];
        }];
    } else {
        [self replaceVisibleViewWithView:viewController.view];
        
        [self.visibleViewController viewDidDisappear:animated];
        [viewController viewDidAppear:animated];
    }
    
    [_navigationBar popToNavigationItem:viewController.navigationItem animated:animated];
}

- (void)popToRootViewControllerAnimated:(BOOL)animated
{
    if([self.viewControllers count] == 1)
        return;
    
    UIViewController *topViewController = self.topViewController;
    
    [self willChangeValueForKey:@"viewControllers"];
    NSIndexSet *indexesToRemove = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, _viewControllers.count - 1)];
    [_viewControllers enumerateObjectsAtIndexes:indexesToRemove options:0 usingBlock:^(UIViewController *viewController, NSUInteger index, BOOL *stop) {
        viewController.navigationController = nil;
    }];
    [_viewControllers removeObjectsAtIndexes:indexesToRemove];
    [self didChangeValueForKey:@"viewControllers"];
    
    [self.visibleViewController viewWillDisappear:animated];
    [topViewController viewWillAppear:animated];
    if(animated) {
        [self replaceVisibleViewWithViewPushingFromLeft:topViewController.view completionHandler:^{
            [self.visibleViewController viewDidDisappear:animated];
            [topViewController viewDidAppear:animated];
        }];
    } else {
        [self replaceVisibleViewWithView:topViewController.view];
        
        [self.visibleViewController viewDidDisappear:animated];
        [topViewController viewDidAppear:animated];
    }
    
    [_navigationBar popToRootNavigationItemAnimated:animated];
}

#pragma mark - Changing Views

- (void)replaceVisibleViewWithView:(UIView *)view
{
    if(_visibleView) {
        [_visibleView removeFromSuperview];
        _visibleView = nil;
    }
    
    _visibleView = view;
    
    if(_visibleView) {
        [_visibleView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_visibleView setFrame:self.contentView.bounds];
        [self.contentView addSubview:_visibleView];
    }
}

- (void)replaceVisibleViewWithViewPushingFromLeft:(UIView *)newView completionHandler:(dispatch_block_t)completionHandler
{
    if(!_visibleView) {
        [self replaceVisibleViewWithView:newView];
        return;
    }
    
    NSRect initialNewViewFrame = self.contentView.bounds;
    initialNewViewFrame.origin.x = -NSWidth(initialNewViewFrame);
    [newView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [newView setFrame:initialNewViewFrame];
    [self.contentView addSubview:newView];
    
    UIView *oldView = _visibleView;
    NSRect oldViewTargetFrame = oldView.frame;
    oldViewTargetFrame.origin.x = NSMaxX(oldViewTargetFrame);
    
    NSRect newViewTargetFrame = initialNewViewFrame;
    newViewTargetFrame.origin.x = 0;
    
    _visibleView = newView;
    [UIView animateWithDuration:0.2 animations:^{
        [oldView setFrame:oldViewTargetFrame];
        [newView setFrame:newViewTargetFrame];
    } completion:^(BOOL finished) {
        [oldView removeFromSuperview];
        
        if(completionHandler)
            completionHandler();
    }];
}

- (void)replaceVisibleViewWithViewPushingFromRight:(UIView *)newView completionHandler:(dispatch_block_t)completionHandler
{
    if(!_visibleView) {
        [self replaceVisibleViewWithView:newView];
        return;
    }
    
    NSRect initialNewViewFrame = self.contentView.bounds;
    initialNewViewFrame.origin.x = NSWidth(initialNewViewFrame);
    [newView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [newView setFrame:initialNewViewFrame];
    [self.contentView addSubview:newView];
    
    UIView *oldView = _visibleView;
    NSRect oldViewTargetFrame = oldView.frame;
    oldViewTargetFrame.origin.x = -NSWidth(oldViewTargetFrame);
    
    NSRect newViewTargetFrame = initialNewViewFrame;
    newViewTargetFrame.origin.x = 0.0;
    
    _visibleView = newView;
    [UIView animateWithDuration:0.2 animations:^{
        [oldView setFrame:oldViewTargetFrame];
        [newView setFrame:newViewTargetFrame];
    } completion:^(BOOL finished) {
        [oldView removeFromSuperview];
        
        if(completionHandler)
            completionHandler();
    }];
}

#pragma mark - Actions

- (IBAction)popFromNavigationController:(id)sender
{
    [self popViewControllerAnimated:YES];
}

@end
