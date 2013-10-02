//
//  UITabBarController.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UITabBarController.h"
#import "UITabBar.h"

@interface UITabBarController () <UITabBarDelegate> {
    struct {
        int tabBarControllerShouldSelectViewController : 1;
        int tabBarControllerDidSelectViewController : 1;
        
        int tabBarControllerWillBeginCustomizingViewControllers : 1;
        int tabBarControllerWillEndCustomizingViewControllersChanged : 1;
        int tabBarControllerDidEndCustomizingViewControllersChanged : 1;
        
        int tabBarControllerSupportedInterfaceOrientations : 1;
        int tabBarControllerPreferredInterfaceOrientationForPresentation : 1;
        
        int tabBarControllerAnimationControllerForTransitionFromViewControllerToViewController : 1;
        int tabBarControllerInteractionControllerForAnimationController : 1;
    } _delegateRespondsTo;
}

@property (nonatomic) UIView *_contentView;

#pragma mark - readwrite

@property (nonatomic, readwrite) UITabBar *tabBar;

@end

@implementation UITabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        [self loadView];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect bounds = self.view.bounds;
    
    
    self.tabBar = [UITabBar new];
    self.tabBar.delegate = self;
    self.tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    CGRect tabBarFrame = CGRectZero;
    tabBarFrame.size = [self.tabBar sizeThatFits:bounds.size];
    tabBarFrame.origin.x = 0.0;
    tabBarFrame.origin.y = CGRectGetMaxY(bounds) - CGRectGetHeight(tabBarFrame);
    self.tabBar.frame = tabBarFrame;
    [self.view addSubview:self.tabBar];
    
    CGRect contentViewFrame = CGRectMake(CGRectGetMinX(bounds),
                                         CGRectGetMinY(bounds),
                                         CGRectGetWidth(bounds),
                                         CGRectGetHeight(bounds) - CGRectGetHeight(tabBarFrame));
    self._contentView = [[UIView alloc] initWithFrame:contentViewFrame];
    self._contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self._contentView.backgroundColor = [UIColor windowBackgroundColor];
    [self.view insertSubview:self._contentView belowSubview:self.tabBar];
}

#pragma mark - Accessing the Tab Bar Controller Properties

- (void)setDelegate:(id<UITabBarControllerDelegate>)delegate
{
    _delegate = delegate;
    
    _delegateRespondsTo.tabBarControllerShouldSelectViewController = [_delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)];
    _delegateRespondsTo.tabBarControllerDidSelectViewController = [_delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)];
    
    _delegateRespondsTo.tabBarControllerWillBeginCustomizingViewControllers = [_delegate respondsToSelector:@selector(tabBarController:willBeginCustomizingViewControllers:)];
    _delegateRespondsTo.tabBarControllerWillEndCustomizingViewControllersChanged = [_delegate respondsToSelector:@selector(tabBarController:willEndCustomizingViewControllers:changed:)];
    _delegateRespondsTo.tabBarControllerDidEndCustomizingViewControllersChanged = [_delegate respondsToSelector:@selector(tabBarController:didEndCustomizingViewControllers:changed:)];
    
    _delegateRespondsTo.tabBarControllerSupportedInterfaceOrientations = [_delegate respondsToSelector:@selector(tabBarControllerSupportedInterfaceOrientations:)];
    _delegateRespondsTo.tabBarControllerPreferredInterfaceOrientationForPresentation = [_delegate respondsToSelector:@selector(tabBarControllerPreferredInterfaceOrientationForPresentation:)];
    
    _delegateRespondsTo.tabBarControllerAnimationControllerForTransitionFromViewControllerToViewController = [_delegate respondsToSelector:@selector(tabBarController:animationControllerForTransitionFromViewController:toViewController:)];
    _delegateRespondsTo.tabBarControllerInteractionControllerForAnimationController = [_delegate respondsToSelector:@selector(tabBarController:interactionControllerForAnimationController:)];
}

#pragma mark - Managing the View Controllers

- (void)setViewControllers:(NSArray *)viewControllers
{
    [self setViewControllers:viewControllers animated:NO];
}

- (void)setViewControllers:(NSArray *)controllers animated:(BOOL)animate
{
    self.selectedViewController = nil;
    
    for (UIViewController *controller in _viewControllers)
        [controller removeFromParentViewController];
    
    _viewControllers = [controllers copy];
    
    for (UIViewController *controller in _viewControllers)
        [self addChildViewController:controller];
    
    [self.tabBar setItems:[_viewControllers valueForKey:@"tabBarItem"] animated:animate];
}

#pragma mark - Managing the Selected Tab

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    NSUInteger indexOfController = [self.viewControllers indexOfObject:selectedViewController];
    if(indexOfController == NSNotFound)
        [NSException raise:NSInternalInconsistencyException format:@"Cannot select view controller %@ that is not a child of %@", selectedViewController, self];
    
    [_selectedViewController viewWillDisappear:NO];
    [_selectedViewController.view removeFromSuperview];
    [_selectedViewController viewDidDisappear:NO];
    
    _selectedViewController = selectedViewController;
    _selectedIndex = indexOfController;
    
    if(_selectedViewController) {
        [_selectedViewController viewWillAppear:NO];
        
        UIView *view = _selectedViewController.view;
        view.frame = self._contentView.bounds;
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self._contentView addSubview:view];
        
        [_selectedViewController viewDidAppear:NO];
        
        self._contentView.backgroundColor = [UIColor clearColor];
    } else {
        self._contentView.backgroundColor = [UIColor windowBackgroundColor];
    }
    
    self.tabBar.selectedItem = _selectedViewController.tabBarItem;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    self.selectedViewController = self.viewControllers[selectedIndex];
    _selectedIndex = selectedIndex;
}

#pragma mark - <UITabBarDelegate>

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSUInteger index = [tabBar.items indexOfObject:item];
    if(_delegateRespondsTo.tabBarControllerShouldSelectViewController) {
        if(![self.delegate tabBarController:self shouldSelectViewController:self.viewControllers[index]]) {
            self.tabBar.selectedItem = self.selectedViewController.tabBarItem;
            return;
        }
    }
    
    self.selectedIndex = index;
    if(_delegateRespondsTo.tabBarControllerDidSelectViewController)
        [self.delegate tabBarController:self didSelectViewController:self.viewControllers[index]];
}

@end
