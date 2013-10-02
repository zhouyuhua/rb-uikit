//
//  TestTextViewController.m
//  Test
//
//  Created by Kevin MacWhinnie on 9/28/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "TestTextViewController.h"

@interface TestTextViewController ()

@property (nonatomic) UITextView *textView;

@end

@implementation TestTextViewController

- (id)init
{
    if((self = [super init])) {
        self.title = @"Text";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [UIMacWindowButtonsView windowButtonsBarItem];
    
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.textView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}

@end
