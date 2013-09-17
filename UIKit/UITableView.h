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

@class UITableView, UINib;

typedef NS_ENUM(NSUInteger, UITableViewStyle) {
    UITableViewStylePlain,
    UITableViewStyleGrouped,
};

typedef NS_ENUM(NSUInteger, UITableViewScrollPosition) {
    UITableViewScrollPositionNone,
    UITableViewScrollPositionTop,
    UITableViewScrollPositionMiddle,
    UITableViewScrollPositionBottom
};

typedef NS_ENUM(NSUInteger, UITableViewCellSeparatorStyle) {
    UITableViewCellSeparatorStyleNone,
    UITableViewCellSeparatorStyleSingleLine,
    UITableViewCellSeparatorStyleSingleLineEtched
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

#pragma mark -

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;

#pragma mark -

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;

#pragma mark -

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section;
- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section;

#pragma mark -

- (void)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark -

@interface UITableView : UIScrollView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

#pragma mark - Properties

@property (nonatomic, readonly) UITableViewStyle style;

#pragma mark -

@property (nonatomic) UIView *tableHeaderView;
@property (nonatomic) UIView *tableFooterView;

#pragma mark -

@property (nonatomic) CGFloat rowHeight;
@property (nonatomic) CGFloat sectionHeaderHeight;
@property (nonatomic) CGFloat sectionFooterHeight;

#pragma mark -

@property (nonatomic) UITableViewCellSeparatorStyle separatorStyle;
@property (nonatomic) UIColor *separatorColor;
@property (nonatomic) UIView *backgroundView;

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

#pragma mark - Scrolling the Table View

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animate;
- (void)scrollToNearestSelectedRowAtScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animate;

#pragma mark - Accessing Rows and Sections

- (NSArray *)visibleCells;
- (NSArray *)indexPathsForRowsInRect:(CGRect)rect;
- (NSIndexPath *)indexPathForRowAtPoint:(CGPoint)point;
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Managing Selection

- (NSIndexPath *)indexPathForSelectedRow;
- (NSArray *)indexPathsForSelectedRows;

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

@property (nonatomic) BOOL allowsSelection;
@property (nonatomic) BOOL allowsMultipleSelection;
@property (nonatomic) BOOL allowsSelectionDuringEditing;
@property (nonatomic) BOOL allowsMultipleSelectionDuringEditing;

#pragma mark - Managing the Editing of Table Cells

@property (nonatomic, getter=isEditing) BOOL editing;
- (void)setEditing:(BOOL)editing animated:(BOOL)animate;

@end
