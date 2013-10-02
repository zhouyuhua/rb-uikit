//
//  TestTableViewController.m
//  Test
//
//  Created by Kevin MacWhinnie on 8/15/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "TestTableViewController.h"

static NSString *const kSectionTitle = @"title";
static NSString *const kSectionItems = @"items";

static NSString *const kItemTitle = @"title";
static NSString *const kItemDescription = @"itemDescription";

@interface TestTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;

#pragma mark -

@property (nonatomic) NSArray *sections;

@end

@implementation TestTableViewController

- (id)init
{
    if((self = [super initWithStyle:UITableViewStylePlain])) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 400.0) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 100.0;
        self.tableView.tableHeaderView = [UISearchBar new];
        
        UIView *testFooter = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 20.0)];
        testFooter.backgroundColor = [UIColor redColor];
        self.tableView.tableFooterView = testFooter;
        
        self.refreshControl = [UIRefreshControl new];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Release to Refresh"];
        [self.refreshControl addTarget:self action:@selector(refreshControlPulled:) forControlEvents:UIControlEventValueChanged];
        
        self.view = self.tableView;
        
        self.title = @"Table";
        
        NSArray *prettyColors = @[ @{kItemTitle: @"Blue", kItemDescription: @"like the sky"},
                                   @{kItemTitle: @"Green", kItemDescription: @"like the grass"},
                                   @{kItemTitle: @"Purple", kItemDescription: @"like royalty"},
                                   @{kItemTitle: @"Orange", kItemDescription: @"like the fruit"} ];
        NSArray *otherColors = @[ @{kItemTitle: @"Brown", kItemDescription: @"like the earth"},
                                  @{kItemTitle: @"Gray", kItemDescription: @"like a rainy day"},
                                  @{kItemTitle: @"Yellow", kItemDescription: @"like jaundice"},
                                  @{kItemTitle: @"Black", kItemDescription: @"like the night"},
                                  @{kItemTitle: @"Auburn", kItemDescription: @"like the hair"} ];
        self.sections = @[ @{kSectionTitle: @"Pretty Colors", kSectionItems: prettyColors},
                           @{kSectionTitle: @"Other Colors", kSectionItems: otherColors} ];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Test"
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:self
                                                                                action:@selector(test:)];
    }
    
    return self;
}

#pragma mark - Actions

- (IBAction)test:(id)sender
{
    self.navigationItem.leftBarButtonItems = @[ [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(untest:)],
                                                [[UIBarButtonItem alloc] initWithTitle:@"Beep" style:UIBarButtonItemStyleBordered target:self action:@selector(beep:)] ];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Beep" style:UIBarButtonItemStyleBordered target:self action:@selector(beep:)];
}

- (IBAction)untest:(id)sender
{
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

- (IBAction)beep:(id)sender
{
    NSBeep();
}

- (IBAction)refreshControlPulled:(id)sender
{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing"];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.refreshControl endRefreshing];
        
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    });
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionItems = _sections[section][kSectionItems];
    return sectionItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const Identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier];
    }
    
    NSArray *sectionItems = _sections[indexPath.section][kSectionItems];
    NSDictionary *sectionItem = sectionItems[indexPath.row];
    
    cell.textLabel.text = sectionItem[kItemTitle];
    cell.detailTextLabel.text = sectionItem[kItemDescription];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *sectionInfo = _sections[section];
    return sectionInfo[kSectionTitle];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    UIViewController *stupidTest = [UIViewController new];
    [self.navigationController pushViewController:stupidTest animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
