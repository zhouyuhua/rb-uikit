//
//  RKNavigationController.m
//  Pinna
//
//  Created by Kevin MacWhinnie on 12/6/12.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UINavigationController_Private.h"
#import "_UINavigationControllerTransitions.h"
#import "UINavigationBar_Private.h"

#import "UIViewController_Private.h"
#import "UIViewControllerTransitioning_Private.h"

#import "UIResponder_Private.h"
#import "UIView.h"
#import "UIBarButtonItem_Private.h"
#import "UINavigationItem_Private.h"

#import "UIToolbar.h"

@implementation UINavigationController

- (id)init
{
    return [self initWithNavigationBarClass:Nil toolbarClass:Nil];
}

- (instancetype)initWithRootViewController:(UIViewController *)viewController
{
    if((self = [self initWithNavigationBarClass:Nil toolbarClass:Nil])) {
        if(viewController)
            self.viewControllers = @[ viewController ];
    }
    
    return self;
}

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass
{
    if(!navigationBarClass)
        navigationBarClass = [UINavigationBar class];
    
    if((self = [super init])) {
        _viewControllers = [NSMutableArray array];
        
        self.view = [[UIView alloc] initWithFrame:NSMakeRect(0.0, 0.0, 320.0, 500.0)];
        self.contentView = [[UIView alloc] initWithFrame:self.view.frame];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentView.backgroundColor = [UIColor windowBackgroundColor];
        [self.view addSubview:self.contentView];
        
        _navigationBar = [[navigationBarClass alloc] initWithFrame:NSMakeRect(0.0, 0.0, 320.0, 40.0)];
        _navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _navigationBar._navigationController = self;
        [self.view addSubview:_navigationBar];
        
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
        _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:_toolbar];
        self.toolbarHidden = YES;
        
        [self layoutViews];
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
    
    CGRect toolbarFrame = _toolbar.frame;
    toolbarFrame.size.width = CGRectGetWidth(contentArea);
    if(_toolbarHidden) {
        toolbarFrame.origin.y = CGRectGetMaxY(contentArea);
    } else {
        toolbarFrame.origin.y = CGRectGetMaxY(contentArea) - CGRectGetHeight(toolbarFrame);
    }
    _toolbar.frame = toolbarFrame;
    
    CGRect contentViewFrame = self.contentView.frame;
    contentViewFrame.origin = CGPointZero;
    contentViewFrame.size = contentArea.size;
    if(!self.navigationBarHidden) {
        contentViewFrame.origin.y += CGRectGetHeight(self.navigationBar.bounds);
        contentViewFrame.size.height -= CGRectGetHeight(self.navigationBar.frame);
    }
    
    if(!self.toolbarHidden) {
        contentViewFrame.size.height -= CGRectGetHeight(toolbarFrame);
    }
    
    self.contentView.frame = contentViewFrame;
}

#pragma mark - Overrides

- (NSString *)title
{
    return super.title ?: self.visibleViewController.title;
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

- (void)setViewControllers:(NSArray *)viewControllers
{
    [self setViewControllers:viewControllers animated:NO];
}

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated
{
    UIViewController *sourceController = self.visibleViewController;
    
    [self willChangeValueForKey:@"viewControllers"];
    [_viewControllers setArray:viewControllers];
    [self didChangeValueForKey:@"viewControllers"];
    
    if(viewControllers.count > 1) {
        NSIndexSet *backableItems = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, viewControllers.count - 1)];
        [viewControllers enumerateObjectsAtIndexes:backableItems options:kNilOptions usingBlock:^(UIViewController *viewController, NSUInteger index, BOOL *stop) {
            UIViewController *previousController = self.viewControllers[index - 1];
            UIBarButtonItem *backItem = previousController.navigationItem.backBarButtonItem;
            backItem.target = self;
            backItem.action = @selector(_popVisibleController:);
            if(backItem.title == nil) {
                backItem.title = previousController.navigationItem.title;
            }
            viewController.navigationItem._backItem = backItem;
        }];
    }
    
    UIViewController *destinationController = self.visibleViewController;
    [self _transitionWithSourceController:sourceController
                    destinationController:destinationController
                                operation:UINavigationControllerOperationPush
                                 animated:animated
                        completionHandler:nil];
    
    self.navigationBar.items = [self.viewControllers valueForKey:@"navigationItem"];
    self.toolbar.items = self.visibleViewController.toolbarItems;
    if(self.visibleViewController.hidesBottomBarWhenPushed)
        self.toolbarHidden = YES;
}

- (NSArray *)viewControllers
{
    return _viewControllers;
}

#pragma mark - Navigation Bar

@synthesize navigationBar = _navigationBar;

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden animated:(BOOL)animated
{
    self.navigationBar.hidden = navigationBarHidden;
    [self layoutViews];
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden
{
    [self setNavigationBarHidden:navigationBarHidden animated:NO];
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
    
    [self _transitionWithSourceController:self.visibleViewController
                    destinationController:viewController
                                operation:UINavigationControllerOperationPush
                                 animated:animated
                        completionHandler:nil];
    
    [self willChangeValueForKey:@"viewControllers"];
    [_viewControllers addObject:viewController];
    [self didChangeValueForKey:@"viewControllers"];
    
    if(self.viewControllers.count > 1) {
        UIViewController *previousController = self.viewControllers[self.viewControllers.count - 2];
        UIBarButtonItem *backItem = previousController.navigationItem.backBarButtonItem;
        backItem.target = self;
        backItem.action = @selector(_popVisibleController:);
        if(backItem.title == nil) {
            backItem.title = previousController.navigationItem.title;
        }
        viewController.navigationItem._backItem = backItem;
    }
    
    [_navigationBar pushNavigationItem:viewController.navigationItem animated:animated];
    self.toolbar.items = self.visibleViewController.toolbarItems;
    if(viewController.hidesBottomBarWhenPushed)
        self.toolbarHidden = YES;
}

- (void)popViewControllerAnimated:(BOOL)animated
{
    if([self.viewControllers count] == 1)
        return;
    
    [self willChangeValueForKey:@"viewControllers"];
    UIViewController *previousViewController = self.visibleViewController;
    [_viewControllers removeLastObject];
    [self didChangeValueForKey:@"viewControllers"];
    
    [self _transitionWithSourceController:previousViewController
                    destinationController:self.visibleViewController
                                operation:UINavigationControllerOperationPop
                                 animated:animated
                        completionHandler:nil];
    
    [_navigationBar popNavigationItemAnimated:animated];
    self.toolbar.items = self.visibleViewController.toolbarItems;
}

- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSUInteger indexOfViewController = [self.viewControllers indexOfObject:viewController];
    NSAssert((indexOfViewController != NSNotFound),
             @"View controller %@ is not in navigation stack", viewController);
    
    [self willChangeValueForKey:@"viewControllers"];
    UIViewController *previousViewController = self.visibleViewController;
    NSIndexSet *indexesToRemove = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexOfViewController + 1, _viewControllers.count - (indexOfViewController + 1))];
    [_viewControllers removeObjectsAtIndexes:indexesToRemove];
    [self didChangeValueForKey:@"viewControllers"];
    
    [self _transitionWithSourceController:previousViewController
                    destinationController:self.visibleViewController
                                operation:UINavigationControllerOperationPop
                                 animated:animated
                        completionHandler:nil];
    
    [_navigationBar popToNavigationItem:viewController.navigationItem animated:animated];
    self.toolbar.items = self.visibleViewController.toolbarItems;
}

- (void)popToRootViewControllerAnimated:(BOOL)animated
{
    if([self.viewControllers count] == 1)
        return;
    
    [self willChangeValueForKey:@"viewControllers"];
    UIViewController *previousViewController = self.visibleViewController;
    NSIndexSet *indexesToRemove = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, _viewControllers.count - 1)];
    [_viewControllers enumerateObjectsAtIndexes:indexesToRemove options:0 usingBlock:^(UIViewController *controller, NSUInteger index, BOOL *stop) {
        [controller removeFromParentViewController];
    }];
    [_viewControllers removeObjectsAtIndexes:indexesToRemove];
    [self didChangeValueForKey:@"viewControllers"];
    
    [self _transitionWithSourceController:previousViewController
                    destinationController:self.visibleViewController
                                operation:UINavigationControllerOperationPop
                                 animated:animated
                        completionHandler:nil];
    
    [_navigationBar popToRootNavigationItemAnimated:animated];
    self.toolbar.items = self.visibleViewController.toolbarItems;
}

#pragma mark - Delegate

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate
{
    _delegate = delegate;
    
    _delegateRespondsTo.navigationControllerWillShowViewControllerAnimated = [delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)];
    _delegateRespondsTo.navigationControllerDidShowViewControllerAnimated = [delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)];
    
    _delegateRespondsTo.navigationControllerAnimationControllerForOperationFromViewControllerToViewController = [delegate respondsToSelector:@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)];
    _delegateRespondsTo.navigationControllerInteractionControllerForAnimationController = [delegate respondsToSelector:@selector(navigationController:interactionControllerForAnimationController:)];
}

#pragma mark - Configuring Custom Toolbars

@synthesize toolbar = _toolbar;

- (void)setToolbarHidden:(BOOL)hidden animated:(BOOL)animated
{
    _toolbarHidden = hidden;
    
    if(!hidden)
        _toolbar.hidden = NO;
    
    [UIView animateWithDuration:(animated? UIKitDefaultAnimationDuration : 0.0) animations:^{
        [self layoutViews];
    } completion:^(BOOL finished) {
        if(hidden)
            _toolbar.hidden = YES;
    }];
}

- (void)setToolbarHidden:(BOOL)toolbarHidden
{
    [self setToolbarHidden:toolbarHidden animated:NO];
}

#pragma mark - Transitions

- (void)_replaceViewControllerWithViewController:(UIViewController *)viewController
{
    if(_visibleView) {
        [self.visibleViewController viewWillDisappear:NO];
        [self.visibleViewController removeFromParentViewController];
        
        [_visibleView removeFromSuperview];
        _visibleView = nil;
        
        [self.visibleViewController viewDidDisappear:NO];
    }
    
    _visibleView = viewController.view;
    
    if(_visibleView) {
        [viewController viewWillAppear:NO];
        
        [_visibleView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_visibleView setFrame:self.contentView.bounds];
        [self.contentView addSubview:_visibleView];
        
        [self addChildViewController:viewController];
        
        [viewController viewDidAppear:NO];
    }
}

- (void)_transitionWithSourceController:(UIViewController *)source
                  destinationController:(UIViewController *)destination
                              operation:(UINavigationControllerOperation)operation
                               animated:(BOOL)animated
                      completionHandler:(dispatch_block_t)completionHandler
{
    if(!source && !destination)
        return;
    
    id <UIViewControllerAnimatedTransitioning> transitioner;
    if(_delegateRespondsTo.navigationControllerAnimationControllerForOperationFromViewControllerToViewController) {
        transitioner = [self.delegate navigationController:self animationControllerForOperation:operation fromViewController:source toViewController:destination];
    }
    
    if(!transitioner) {
        switch (operation) {
            case UINavigationControllerOperationNone:
            case UINavigationControllerOperationPush:
                transitioner = [_UINavigationControllerPushTransition new];
                break;
                
            case UINavigationControllerOperationPop:
                transitioner = [_UINavigationControllerPopTransition new];
                break;
        }
    }
    
    dispatch_block_t internalCompletionHandler = ^{
        [source viewDidDisappear:animated];
        [destination viewDidAppear:animated];
        
        [source removeFromParentViewController];
        
        destination.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        if(_delegateRespondsTo.navigationControllerDidShowViewControllerAnimated)
            [self.delegate navigationController:self didShowViewController:destination animated:animated];
        
        _currentAnimationContext = nil;
        
        if(completionHandler)
            completionHandler();
    };
    NSMutableDictionary *controllers = [NSMutableDictionary dictionary];
    if(source)
        controllers[UITransitionContextFromViewControllerKey] = source;
    if(destination)
        controllers[UITransitionContextToViewControllerKey] = destination;
    _currentAnimationContext = [[_UIViewControllerContextConcreteTransitioning alloc] initWithContainerView:_contentView
                                                                                                controllers:controllers
                                                                                                   animated:animated
                                                                                           transitionObject:transitioner
                                                                                          completionHandler:internalCompletionHandler];
    
    if(_delegateRespondsTo.navigationControllerWillShowViewControllerAnimated)
        [self.delegate navigationController:self willShowViewController:destination animated:animated];
    
    [self addChildViewController:destination];
    
    [source viewWillDisappear:animated];
    [destination viewWillAppear:animated];
    
    [transitioner animateTransition:_currentAnimationContext];
}

#pragma mark - Actions

- (IBAction)_popVisibleController:(id)sender
{
    [self popViewControllerAnimated:YES];
}

@end
