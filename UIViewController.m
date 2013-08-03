//
//  RKViewController.m
//  Pinna
//
//  Created by Kevin MacWhinnie on 12/6/12.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIViewController.h"
#import "UIViewController_Private.h"
#import "UIResponder_Private.h"
#import "UINavigationController.h"
#import "UINavigationItem.h"

@implementation UIViewController {
    UINavigationItem *_navigationItem;
    NSMutableArray *_childViewControllers;
    UIView *_view;
}

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

#pragma mark - Loading

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
        
        self.view = [UIView new];
        
        [self viewDidLoad];
    }
}

#pragma mark - Navigation Stack Support

- (UINavigationItem *)navigationItem
{
    if(!_navigationItem) {
        _navigationItem = [[UINavigationItem alloc] initWithTitle:NSStringFromClass([self class])];
    }
    
    return _navigationItem;
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
    [childController didMoveToParentViewController:self];
}

- (void)removeFromParentViewController
{
    [self willMoveToParentViewController:nil];
    [self.parentViewController->_childViewControllers removeObject:self];
    [self didMoveToParentViewController:nil];
}

#pragma mark - Properties

- (void)setView:(UIView *)view
{
    _view = view;
    self.nextResponder = view;
    self.isViewLoaded = YES;
}

- (UIView *)view
{
    if(!_view)
        [self loadView];
    
    return _view;
}

#pragma mark - Actions

- (IBAction)popFromNavigationController:(id)sender
{
    if(self.navigationController.visibleViewController == self)
        [self.navigationController popViewControllerAnimated:YES];
}

@end
