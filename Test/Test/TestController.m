//
//  TestController.m
//  Test
//
//  Created by Kevin MacWhinnie on 8/12/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "TestController.h"

@interface TestController () <UIAlertViewDelegate>

@end

@implementation TestController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 50.0, 100.0, 100.0)];
    testLabel.textAlignment = NSTextAlignmentCenter;
    testLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    testLabel.shadowColor = [UIColor yellowColor];
    testLabel.text = @"aren't I beautiful?";
    [testLabel sizeToFit];
    [self.view addSubview:testLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(50.0, 120.0, 100.0, 44.0);
    [button setTitle:@"Test Title" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(testPush:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    [self.view addSubview:button];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), 50.0)];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    searchBar.placeholder = @"Search";
    [self.view addSubview:searchBar];
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
