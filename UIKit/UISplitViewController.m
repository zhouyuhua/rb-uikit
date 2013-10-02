//
//  UISplitViewController.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UISplitViewController.h"
#import "_UISplitViewControllerDividerView.h"

static CGFloat const kLeftPaneWidth = 320.0;

@implementation UISplitViewController {
    _UISplitViewControllerDividerView *_dividerView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dividerView = [_UISplitViewControllerDividerView new];
    [self.view addSubview:_dividerView];
}

#pragma mark - Layout

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if(_viewControllers.count == 2) {
        CGRect bounds = self.view.bounds;
        CGFloat dividerWidth = [_UISplitViewControllerDividerView preferredWidth];
        
        UIView *leftView = [(UIViewController *)_viewControllers[0] view];
        UIView *rightView = [(UIViewController *)_viewControllers[1] view];
        
        CGRect leftViewFrame = CGRectMake(CGRectGetMinX(bounds),
                                          CGRectGetMinY(bounds),
                                          kLeftPaneWidth,
                                          CGRectGetHeight(bounds));
        leftView.frame = leftViewFrame;
        
        CGRect dividerFrame = CGRectMake(CGRectGetMaxX(leftViewFrame), CGRectGetMinY(bounds), dividerWidth, CGRectGetHeight(bounds));
        _dividerView.frame = dividerFrame;
        
        CGRect rightViewFrame = CGRectMake(CGRectGetMaxX(dividerFrame),
                                           CGRectGetMinY(bounds),
                                           CGRectGetWidth(bounds) - CGRectGetMaxX(dividerFrame),
                                           CGRectGetHeight(bounds));
        rightView.frame = rightViewFrame;
    } else {
        _dividerView.frame = CGRectZero;
    }
}

#pragma mark - Properties

- (void)setViewControllers:(NSArray *)viewControllers
{
    if(viewControllers.count != 0 && viewControllers.count != 2)
        [NSException raise:NSInternalInconsistencyException
                    format:@"UISplitViewController requires 0 or 2 view controllers, %ld given", viewControllers.count];
    
    for (UIViewController *controller in _viewControllers) {
        [controller viewWillDisappear:NO];
        [controller.view removeFromSuperview];
        [controller viewDidDisappear:NO];
        
        [controller removeFromParentViewController];
    }
    
    _viewControllers = [viewControllers copy];
    
    for (UIViewController *controller in _viewControllers) {
        [self addChildViewController:controller];
        
        [controller viewWillAppear:NO];
        [self.view addSubview:controller.view];
        [controller viewDidAppear:NO];
    }
}

#pragma mark -

- (void)setPresentsWithGesture:(BOOL)presentsWithGesture
{
    //Do nothing.
}

- (BOOL)presentsWithGesture
{
    return NO;
}

@end
