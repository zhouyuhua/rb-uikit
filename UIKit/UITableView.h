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

typedef NS_ENUM(NSInteger, UITableViewCellEditingStyle) {
    UITableViewCellEditingStyleNone,
    UITableViewCellEditingStyleDelete,
    UITableViewCellEditingStyleInsert
};

typedef NS_ENUM(NSUInteger, UITableViewRowAnimation) {
    UITableViewRowAnimationFade,
    UITableViewRowAnimationRight,
    UITableViewRowAnimationLeft,
    UITableViewRowAnimationTop,
    UITableViewRowAnimationBottom,
    UITableViewRowAnimationNone,
    UITableViewRowAnimationMiddle,
    UITableViewRowAnimationAutomatic = 100
};

@protocol UITableViewDataSource <NSObject>

@required

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

#pragma mark -

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView UIKIT_UNIMPLEMENTED;
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index UIKIT_UNIMPLEMENTED;

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;

#pragma mark - Inserting or Deleting Table Rows

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath UIKIT_UNIMPLEMENTED;
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath UIKIT_UNIMPLEMENTED;

#pragma mark - Reordering Table Rows

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath UIKIT_UNIMPLEMENTED;
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)from toIndexPath:(NSIndexPath *)to UIKIT_UNIMPLEMENTED;

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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section;
- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section;

#pragma mark -

- (void)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark -

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath UIKIT_UNIMPLEMENTED;

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
- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)rowAnimation;
- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)rowAnimation;
- (void)reloadSectionIndexTitles;

#pragma mark - Inserting, Deleting, and Moving Rows and Sections

- (void)beginUpdates;
- (void)endUpdates;
- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)rowAnimation;
- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)rowAnimation;
- (void)moveRowAtIndexPath:(NSIndexPath *)from toIndexPath:(NSIndexPath *)to;
- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)rowAnimation;
- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)rowAnimation;
- (void)moveSection:(NSInteger)from toSection:(NSInteger)to;

#pragma mark - Layout Information

- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (NSInteger)numberOfSections;

#pragma mark -

- (CGRect)rectForSection:(NSInteger)section;
- (CGRect)rectForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGRect)rectForFooterInSection:(NSInteger)section;
- (CGRect)rectForHeaderInSection:(NSInteger)section;

#pragma mark - Scrolling the Table View

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animate UIKIT_UNIMPLEMENTED;
- (void)scrollToNearestSelectedRowAtScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animate UIKIT_UNIMPLEMENTED;

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

/*
 Our implementation of UITableView does not support an explicit editing mode.
 A user may at any time delete or reorder the table view through the keyboard
 and drag and drop. Using these properties/methods will result in a one time
 runtime warning being printed to the log.
 */
@property (nonatomic, getter=isEditing) BOOL editing;
- (void)setEditing:(BOOL)editing animated:(BOOL)animate;

#pragma marl - Configuring the Table Index

@property (nonatomic) NSInteger sectionIndexMinimumDisplayRowCount UIKIT_UNIMPLEMENTED;
@property (nonatomic) UIColor *sectionIndexColor UIKIT_UNIMPLEMENTED;
@property (nonatomic) UIColor *sectionIndexBackgroundColor UIKIT_UNIMPLEMENTED;
@property (nonatomic) UIColor *sectionIndexTrackingBackgroundColor UIKIT_UNIMPLEMENTED;

@end
