//
//  UIViewController_Private.h
//  Pinna
//
//  Created by Kevin MacWhinnie on 12/6/12.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIViewController.h"

@interface UIViewController ()

@property (nonatomic, readwrite) BOOL isViewLoaded;
@property (nonatomic, readwrite, weak) UINavigationController *navigationController;
@property (nonatomic, readwrite) UIViewController *parentViewController;

@end
