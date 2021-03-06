//
//  UITableViewController.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/13/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIViewController.h"
#import "UITableView.h"

@class UIRefreshControl;

@interface UITableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithStyle:(UITableViewStyle)style;

#pragma mark - Properties

@property (nonatomic) UITableView *tableView;
@property (nonatomic) BOOL clearsSelectionOnViewWillAppear;
@property (nonatomic) UIRefreshControl *refreshControl;

@end
