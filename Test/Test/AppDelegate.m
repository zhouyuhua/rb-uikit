//
//  AppDelegate.m
//  Test
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "AppDelegate.h"

#import "TestController.h"
#import "TestCollectionViewController.h"
#import "TestTableViewController.h"

@interface AppDelegate () <UIAlertViewDelegate>

@property (nonatomic) UIWindow *window;
@property (nonatomic) UINavigationController *navigationController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:[TestController new]];
    self.window.rootViewController = self.navigationController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
