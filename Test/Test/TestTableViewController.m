//
//  TestTableViewController.m
//  Test
//
//  Created by Kevin MacWhinnie on 8/15/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "TestTableViewController.h"

@interface TestTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;

#pragma mark -

@property (nonatomic) NSArray *colors;

@property (nonatomic) NSArray *descriptions;

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
        
        self.navigationItem.title = @"Colors";
        
        self.colors = @[ @"Blue",
                         @"Green",
                         @"Brown",
                         @"Yellow",
                         @"Purple",
                         @"Gray",
                         @"Magenta",
                         @"black",
                         @"Orange" ];
        
        self.descriptions = @[ @"like the sky",
                               @"like the grass",
                               @"like the earth",
                               @"like jaundice",
                               @"like a sweater",
                               @"like a rainy day",
                               @"like royalty",
                               @"like the night",
                               @"like the fruit" ];
    }
    
    return self;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.colors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    cell.textLabel.text = self.colors[indexPath.row];
    cell.detailTextLabel.text = self.descriptions[indexPath.row];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Test";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
