//
//  AppDelegate.m
//  Test
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () <UIAlertViewDelegate>

@property (nonatomic) UIWindow *window;
@property (nonatomic) UINavigationController *navigationController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 500.0)];
    
    UIViewController *testController = [UIViewController new];
    testController.navigationItem.title = @"Navigation Test";
    testController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Test"
                                                                                       style:UIBarButtonItemStyleBordered
                                                                                      target:self
                                                                                      action:@selector(alert:)];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:testController];
    self.window.rootViewController = self.navigationController;
    
//    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 50.0, 100.0, 100.0)];
//    testLabel.textAlignment = NSTextAlignmentCenter;
//    testLabel.shadowOffset = CGSizeMake(0.0, 1.0);
//    testLabel.shadowColor = [UIColor yellowColor];
//    testLabel.text = @"aren't I beautiful?";
//    testLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    [testLabel sizeToFit];
//    [testController.view addSubview:testLabel];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    button.frame = CGRectMake(50.0, 120.0, 100.0, 44.0);
//    [button setTitle:@"Test Title" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(testPush:) forControlEvents:UIControlEventTouchUpInside];
//    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//    [testController.view addSubview:button];
//    
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 50.0)];
//    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    searchBar.placeholder = @"Search";
//    [testController.view addSubview:searchBar];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:testController.view.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    CGRect frame = scrollView.bounds;
    for (UIColor *backgroundColor in @[ [UIColor blueColor], [UIColor yellowColor], [UIColor greenColor] ]) {
        UIView *subview = [[UIView alloc] initWithFrame:frame];
        subview.backgroundColor = backgroundColor;
        [scrollView addSubview:subview];
        frame.origin.y += CGRectGetHeight(frame);
    }
    
    scrollView.contentSize = CGSizeMake(CGRectGetWidth(frame), CGRectGetHeight(frame) * 3);
    scrollView.alwaysBounceVertical = YES;
    
    [testController.view addSubview:scrollView];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - Actions

- (IBAction)testPush:(UIButton *)sender
{
    UIView *testView = [UIView new];
    testView.backgroundColor = [UIColor yellowColor];
    
    UIViewController *controller = [UIViewController new];
    controller.view = testView;
    controller.navigationItem.title = @"Really long title is really long";
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)alert:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"This is a test"
                                                    message:@"This is only a test"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", @"Jazzy", nil];
    [alert show];
}

@end
