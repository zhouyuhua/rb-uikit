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
#import "TestWebViewController.h"
#import "TestTextViewController.h"

@interface AppDelegate () <UIAlertViewDelegate>

@property (nonatomic) UIWindow *window;
@property (nonatomic) UITabBarController *tabBarController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.tabBarController = [UITabBarController new];
    self.tabBarController.viewControllers = @[ [[UINavigationController alloc] initWithRootViewController:[TestTextViewController new]],
                                               [[UINavigationController alloc] initWithRootViewController:[TestWebViewController new]],
                                               [[UINavigationController alloc] initWithRootViewController:[TestTableViewController new]],
                                               [[UINavigationController alloc] initWithRootViewController:[TestCollectionViewController new]],
                                               [[UINavigationController alloc] initWithRootViewController:[TestController new]] ];
    self.tabBarController.selectedIndex = 0;
    self.window.rootViewController = self.tabBarController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
