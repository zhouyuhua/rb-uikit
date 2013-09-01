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
        
        self.view = self.tableView;
        
        self.navigationItem.title = @"Colors that I really, really, really like a lot today";
        
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
    }
    
    return self;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
