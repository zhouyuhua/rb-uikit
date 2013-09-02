//
//  UIViewController_Private.h
//  Pinna
//
//  Created by Kevin MacWhinnie on 12/6/12.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIViewController.h"

@interface UIViewController ()

///Whether or not the controller is a root view controller in a window.
@property (nonatomic, getter=_isRootViewController) BOOL _rootViewController;

#pragma mark - readwrite

@property (nonatomic, readwrite) BOOL isViewLoaded;
@property (nonatomic, readwrite, weak) UINavigationController *navigationController;
@property (nonatomic, readwrite) UIViewController *parentViewController;

@end
