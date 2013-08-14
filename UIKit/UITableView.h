//
//  UITableView.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/13/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIScrollView.h"

#import "UITableViewCell.h"
#import "UITableViewHeaderFooterView.h"
#import "UITableViewController.h"

@class UITableView, UINib;

typedef NS_ENUM(NSUInteger, UITableViewStyle) {
    UITableViewStylePlain,
    UITableViewStyleGrouped,
};

@protocol UITableViewDataSource <NSObject>

@required

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

@end

#pragma mark -

@protocol UITableViewDelegate <NSObject, UIScrollViewDelegate>

@optional

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark -

@interface UITableView : UIScrollView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

#pragma mark - Properties

@property (nonatomic, readonly) UITableViewStyle style;

#pragma mark -

@property (nonatomic, unsafe_unretained) id <UITableViewDataSource> dataSource;
@property (nonatomic, unsafe_unretained) id <UITableViewDelegate> delegate;

#pragma mark - Registering Classes

- (void)registerClass:(Class)class forCellReuseIdentifier:(NSString *)reuseIdentifier;
- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)reuseIdentifier;

#pragma mark -

- (void)registerClass:(Class)class forHeaderFooterViewReuseIdentifier:(NSString *)reuseIdentifier;
- (void)registerNib:(UINib *)nib forHeaderFooterViewReuseIdentifier:(NSString *)reuseIdentifier;

#pragma mark - Dequeuing Views

- (id)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier;

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Reloading Data

- (void)reloadData;

#pragma mark - Layout Information

- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (NSInteger)numberOfSections;

#pragma mark -

- (CGRect)rectForSection:(NSInteger)section;
- (CGRect)rectForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGRect)rectForFooterInSection:(NSInteger)section;
- (CGRect)rectForHeaderInSection:(NSInteger)section;

@end
