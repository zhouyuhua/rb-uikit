//
//  UITableViewController.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/13/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UITableViewController.h"

@interface UITableViewController () {
    UITableView *_tableView;
    UITableViewStyle _tableViewStyle;
}

@end

@implementation UITableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if((self = [super init])) {
        _tableViewStyle = style;
    }
    
    return self;
}

#pragma mark -

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(_clearsSelectionOnViewWillAppear) {
        [_tableView deselectRowAtIndexPath:_tableView.indexPathForSelectedRow animated:NO];
    }
}

#pragma mark - Loading

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view = self.tableView;
}

#pragma mark - Properties

- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    if(self.isViewLoaded)
        self.view = _tableView;
}

- (UITableView *)tableView
{
    if(!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:_tableViewStyle];
    }
    
    return _tableView;
}

#pragma mark - <UITableViewDataSource>

//We don't really implement the two methods below, this is primarily to silence the
//compiler complaining about how we don't implement the UITableViewDataSource protocol.

- (BOOL)respondsToSelector:(SEL)selector
{
    if(selector == @selector(tableView:numberOfRowsInSection:) ||
       selector == @selector(tableView:cellForRowAtIndexPath:)) {
        return [self methodForSelector:selector] != [UITableViewController instanceMethodForSelector:selector];
    }
    
    return [super respondsToSelector:selector];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self doesNotRecognizeSelector:_cmd];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
