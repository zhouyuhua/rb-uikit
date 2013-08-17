//
//  UITableView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/13/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UITableView_Private.h"
#import "UITableViewCell_Private.h"

#import "NSIndexPath+UITableView.h"
#import "UITableViewSection.h"

#import "UITouch.h"
#import "UIEvent.h"

@implementation UITableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if((self = [super initWithFrame:frame])) {
        self.alwaysBounceVertical = YES;
        
        self.style = style;
        
        switch (style) {
            case UITableViewStylePlain:
                self.backgroundColor = [UIColor whiteColor];
                break;
                
            case UITableViewStyleGrouped:
                self.backgroundColor = [UIColor grayColor];
                break;
        }
        
        
        _registeredCellClasses = [NSMutableDictionary dictionary];
        _registeredHeaderFooterClasses = [NSMutableDictionary dictionary];
        
        _reusableCells = [NSMutableDictionary dictionary];
        _cachedCells = [NSMutableDictionary dictionary];
        
        _sections = [NSMutableArray array];
        _allCells = [NSMutableArray array];
        
        _rowHeight = 40.0;
        _sectionHeaderHeight = 20.0;
        _sectionFooterHeight = 0.0;
        
        _separatorColor = [UIColor lightGrayColor];
        _separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame style:UITableViewStylePlain];
}

#pragma mark - Properties

- (void)setDataSource:(id <UITableViewDataSource>)dataSource
{
    _dataSource = dataSource;
    
    if(![dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)])
        [NSException raise:NSInternalInconsistencyException
                    format:@"-tableView:numberOfRowsInSection: unimplemented by data source"];
    
    if(![dataSource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)])
        [NSException raise:NSInternalInconsistencyException
                    format:@"-tableView:cellForRowAtIndexPath: unimplemented by data source"];
    
    _dataSourceRespondsTo.numberOfSectionsInTableView = [dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)];
    
    [self _setNeedsReload];
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    [super setDelegate:delegate];
    
    _delegateRespondsTo.tableViewHeightForRowAtIndexPath = [delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)];
    _delegateRespondsTo.tableViewHeightForHeaderInSection = [delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)];
    _delegateRespondsTo.tableViewHeightForFooterInSection = [delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)];
    
    _delegateRespondsTo.tableViewViewForHeaderInSection = [delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)];
    _delegateRespondsTo.tableViewViewForFooterInSection = [delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)];
    
    _delegateRespondsTo.tableViewWillDisplayCellForRowAtIndexPath = [delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)];
    _delegateRespondsTo.tableViewDidEndDisplayingCellForRowAtIndexPath = [delegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)];
    
    _delegateRespondsTo.tableViewWillSelectRowAtIndexPath = [delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)];
    _delegateRespondsTo.tableViewDidSelectRowAtIndexPath = [delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)];
    
    _delegateRespondsTo.tableViewWillDeselectRowAtIndexPath = [delegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)];
    _delegateRespondsTo.tableViewDidDeselectRowAtIndexPath = [delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)];
    
    [self _setNeedsReload];
}

#pragma mark -

- (void)setRowHeight:(CGFloat)rowHeight
{
    _rowHeight = rowHeight;
    [self _setNeedsReload];
}

- (void)setSectionHeaderHeight:(CGFloat)sectionHeaderHeight
{
    _sectionHeaderHeight = sectionHeaderHeight;
    [self _setNeedsReload];
}

- (void)setSectionFooterHeight:(CGFloat)sectionFooterHeight
{
    _sectionFooterHeight = sectionFooterHeight;
    [self _setNeedsReload];
}

#pragma mark -

- (void)setSeparatorStyle:(UITableViewCellSeparatorStyle)separatorStyle
{
    _separatorStyle = separatorStyle;
    
    [self setNeedsLayout];
}

- (void)setSeparatorColor:(UIColor *)separatorColor
{
    _separatorColor = separatorColor;
    
    [self setNeedsLayout];
}

#pragma mark - Registering Classes

- (void)registerClass:(Class)class forCellReuseIdentifier:(NSString *)reuseIdentifier
{
    NSParameterAssert(class);
    NSParameterAssert(reuseIdentifier);
    
    _registeredCellClasses[reuseIdentifier] = class;
}

- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)reuseIdentifier
{
    UIKitUnimplementedMethod();
}

#pragma mark -

- (void)registerClass:(Class)class forHeaderFooterViewReuseIdentifier:(NSString *)reuseIdentifier
{
    NSParameterAssert(class);
    NSParameterAssert(reuseIdentifier);
    
    _registeredHeaderFooterClasses[reuseIdentifier] = class;
}

- (void)registerNib:(UINib *)nib forHeaderFooterViewReuseIdentifier:(NSString *)reuseIdentifier
{
    UIKitUnimplementedMethod();
}

#pragma mark - Dequeuing Views

- (id)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier
{
    UIKitUnimplementedMethod();
    return nil;
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    NSParameterAssert(identifier);
    
    UITableViewCell *cell = _reusableCells[identifier];
    if(cell) {
        [_reusableCells removeObjectForKey:identifier];
    }
    
    Class cellClass = _registeredCellClasses[identifier];
    if(cellClass) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    if(!_registeredCellClasses[identifier])
        [NSException raise:NSInternalInconsistencyException format:@"%s called with reuse identifier %@ that has no registered class", __PRETTY_FUNCTION__, identifier];
    
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
    
    cell.frame = [self rectForRowAtIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Reloading Data

- (void)_recycleCell:(UITableViewCell *)cell
{
    NSMutableArray *cellsForIdentifier = _reusableCells[cell.reuseIdentifier];
    if(!cellsForIdentifier) {
        cellsForIdentifier = [NSMutableArray array];
        _reusableCells[cell.reuseIdentifier] = cellsForIdentifier;
    }
    
    if(_delegateRespondsTo.tableViewDidEndDisplayingCellForRowAtIndexPath) {
        [self.delegate tableView:self didEndDisplayingCell:cell forRowAtIndexPath:cell._indexPath];
    }
    
    cell._indexPath = nil;
    
    [cellsForIdentifier addObject:cell];
}

#pragma mark -

- (void)_rebuildSections
{
    NSUInteger numberOfSections = [self numberOfSections];
    for (NSUInteger section = 0; section < numberOfSections; section++) {
        UITableViewSection *sectionInformation = [UITableViewSection new];
        
        sectionInformation.headerHeight = [self _heightForHeaderOfSection:section hasView:_delegateRespondsTo.tableViewViewForHeaderInSection];
        sectionInformation.footerHeight = [self _heightForFooterOfSection:section hasView:_delegateRespondsTo.tableViewViewForFooterInSection];
        sectionInformation.numberOfRows = [self numberOfRowsInSection:section];
        
        for (NSUInteger row = 0, numberOfRows = sectionInformation.numberOfRows; row < numberOfRows; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            sectionInformation.rowHeights[row] = [self _heightForRowAtIndexPath:indexPath];
        }
        
        [_sections addObject:sectionInformation];
    }
}

- (void)_updateContentSize
{
    CGFloat totalHeight = 0.0;
    
    for (UITableViewSection *section in _sections)
        totalHeight += section.totalHeight;
    
    self.contentSize = CGSizeMake(0.0, totalHeight);
}

- (void)_layoutContents
{
    CGRect bounds = UIEdgeInsetsInsetRect(self.bounds, self.contentInset);
    
    CGRect visibleRect = CGRectMake(0.0, self.contentOffset.y,
                                    CGRectGetWidth(bounds), CGRectGetHeight(bounds));
    [_sections enumerateObjectsUsingBlock:^(UITableViewSection *sectionInformation, NSUInteger sectionIndex, BOOL *stop) {
        CGRect headerFrame = [self rectForHeaderInSection:sectionIndex];
        sectionInformation.headerView.frame = headerFrame;
        
        CGRect footerFrame = [self rectForFooterInSection:sectionIndex];
        sectionInformation.footerView.frame = footerFrame;
        
        for (NSUInteger row = 0, numberOfRows = sectionInformation.numberOfRows; row < numberOfRows; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:sectionIndex];
            CGRect rowFrame = [self rectForRowAtIndexPath:indexPath];
            if(CGRectIntersectsRect(rowFrame, visibleRect) && CGRectGetHeight(rowFrame) > 0.0) {
                UITableViewCell *cell = _cachedCells[indexPath];
                if(!cell) {
                    cell = [_dataSource tableView:self cellForRowAtIndexPath:indexPath];
                    if(!cell) {
                        [NSException raise:NSInternalInconsistencyException
                                    format:@"-tableView:cellForRowAtIndexPath: returned nil cell"];
                    }
                } else {
                    [cell prepareForReuse];
                }
                
                cell.frame = rowFrame;
                cell.selected = (_selectedIndexPath && [indexPath isEqual:_selectedIndexPath]);
                cell._indexPath = indexPath;
                [cell _setSeparatorStyle:_separatorStyle color:_separatorColor];
                
                if(_delegateRespondsTo.tableViewWillDisplayCellForRowAtIndexPath)
                    [self.delegate tableView:self willDisplayCell:cell forRowAtIndexPath:indexPath];
                
                [self addSubview:cell];
                [_allCells addObject:cell];
                _cachedCells[indexPath] = cell;
            }
        }
    }];
    
    for (UITableViewCell *cell in _allCells) {
        CGRect cellFrame = cell.frame;
        if(!CGRectIntersectsRect(cellFrame, visibleRect)) {
            [cell removeFromSuperview];
            [self _recycleCell:cell];
        }
    }
}

- (void)layoutSubviews
{
    if(_needsReload) {
        [self reloadData];
    }
    
    [self _layoutContents];
    
    [super layoutSubviews];
}

#pragma mark -

- (void)_setNeedsReload
{
    _needsReload = YES;
    [self setNeedsLayout];
}

- (void)reloadData
{
    for (UITableViewSection *section in _sections) {
        [section.headerView removeFromSuperview];
        [section.footerView removeFromSuperview];
    }
    
    [_allCells makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_allCells removeAllObjects];
    [_sections removeAllObjects];
    [_cachedCells removeAllObjects];
    
    [self _rebuildSections];
    [self _updateContentSize];
    
    _needsReload = NO;
}

#pragma mark - Layout Information

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource tableView:self numberOfRowsInSection:section];
}

- (NSInteger)numberOfSections
{
    if(self.dataSource) {
        if(_dataSourceRespondsTo.numberOfSectionsInTableView)
            return [_dataSource numberOfSectionsInTableView:self];
        else
            return 1;
    } else {
        return 0;
    }
}

#pragma mark -

- (CGRect)rectForSection:(NSInteger)section
{
    UITableViewSection *sectionInformation = _sections[section];
    CGFloat offset = [self _offsetForSection:section];
    return [self _rectForOffset:offset height:sectionInformation.totalHeight];
}

- (CGRect)rectForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewSection *sectionInformation = _sections[indexPath.section];
    CGFloat offset = [self _offsetForSection:indexPath.section];
    offset += sectionInformation.headerHeight;
    
    CGFloat *rowHeights = sectionInformation.rowHeights;
    for (NSUInteger index = 0, row = indexPath.row; index < row; index++) {
        offset += rowHeights[row];
    }
    
    return [self _rectForOffset:offset height:rowHeights[indexPath.row]];
}

- (CGRect)rectForHeaderInSection:(NSInteger)section
{
    UITableViewSection *sectionInformation = _sections[section];
    CGFloat offset = [self _offsetForSection:section];
    return [self _rectForOffset:offset height:sectionInformation.headerHeight];
}

- (CGRect)rectForFooterInSection:(NSInteger)section
{
    UITableViewSection *sectionInformation = _sections[section];
    CGFloat offset = [self _offsetForSection:section];
    return [self _rectForOffset:offset height:sectionInformation.totalHeight - sectionInformation.footerHeight];
}

#pragma mark -

- (CGFloat)_offsetForSection:(NSInteger)section
{
    CGFloat offset = 0.0;
    
    for (NSUInteger row = 0; row < section; row++) {
        UITableViewSection *sectionInformation = _sections[row];
        offset += sectionInformation.totalHeight;
    }
    
    return offset;
}

- (CGRect)_rectForOffset:(CGFloat)offset height:(CGFloat)height
{
    UIEdgeInsets contentInset = self.contentInset;
    CGRect bounds = UIEdgeInsetsInsetRect(self.bounds, contentInset);
    return CGRectMake(0.0, contentInset.top + offset, CGRectGetWidth(bounds), height);
}

#pragma mark -

- (CGFloat)_heightForHeaderOfSection:(NSUInteger)section hasView:(BOOL)hasView
{
    if(_delegateRespondsTo.tableViewHeightForHeaderInSection)
        return [self.delegate tableView:self heightForHeaderInSection:section];
    else
        return hasView? _sectionHeaderHeight : 0.0;
}

- (CGFloat)_heightForFooterOfSection:(NSUInteger)section hasView:(BOOL)hasView
{
    if(_delegateRespondsTo.tableViewHeightForFooterInSection)
        return [self.delegate tableView:self heightForFooterInSection:section];
    else
        return hasView? _sectionFooterHeight : 0.0;
}

- (CGFloat)_heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_delegateRespondsTo.tableViewHeightForRowAtIndexPath)
        return [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
    else
        return _rowHeight;
}

#pragma mark - Accessing Rows and Sections

- (NSArray *)visibleCells
{
    return _cachedCells.allValues;
}

- (NSIndexPath *)indexPathForRowAtPoint:(CGPoint)point
{
    __block NSIndexPath *indexPath = nil;
    [_sections enumerateObjectsUsingBlock:^(UITableViewSection *section, NSUInteger sectionIndex, BOOL *stop) {
        CGFloat offset = [self _offsetForSection:sectionIndex];
        for (NSUInteger row = 0, numberOfRows = section.numberOfRows; row < numberOfRows; row++) {
            CGFloat rowHeight = section.rowHeights[row];
            if((point.y >= offset) && (point.y - offset) < rowHeight) {
                indexPath = [NSIndexPath indexPathForRow:row inSection:sectionIndex];
                
                *stop = YES;
                return;
            }
            
            offset += section.rowHeights[row];
        }
    }];
    
    return indexPath;
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(indexPath);
    
    return _cachedCells[indexPath];
}

#pragma mark - Managing Selection

- (NSIndexPath *)indexPathForSelectedRow
{
    return _selectedIndexPath;
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    if(!indexPath)
        return;
    
    //TODO: Scroll position
    
    if(_selectedIndexPath) {
        UITableViewCell *cell = [self cellForRowAtIndexPath:_selectedIndexPath];
        [cell setSelected:NO animated:animated];
    }
    
    _selectedIndexPath = indexPath;
    
    UITableViewCell *cell = [self cellForRowAtIndexPath:_selectedIndexPath];
    [cell setSelected:YES animated:animated];
}

- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    if(!indexPath)
        return;
    
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:animated];
    
    if([_selectedIndexPath isEqual:indexPath])
        _selectedIndexPath = nil;
}

#pragma mark - Event Handling

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_selectedIndexPath && _delegateRespondsTo.tableViewWillSelectRowAtIndexPath) {
        [self.delegate tableView:self willSelectRowAtIndexPath:_selectedIndexPath];
    }
    
    [self selectRowAtIndexPath:_highlightedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    _highlightedIndexPath = nil;
    
    if(_selectedIndexPath && _delegateRespondsTo.tableViewDidSelectRowAtIndexPath) {
        [self.delegate tableView:self didSelectRowAtIndexPath:_selectedIndexPath];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint locationOfTouch = [touch locationInView:self];
    
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:locationOfTouch];
    
    if(_highlightedIndexPath) {
        UITableViewCell *oldCell = [self cellForRowAtIndexPath:_highlightedIndexPath];
        [oldCell setHighlighted:NO animated:NO];
    }
    
    if(indexPath) {
        UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
        [cell setHighlighted:YES animated:NO];
    }
    
    _highlightedIndexPath = indexPath;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_selectedIndexPath && _delegateRespondsTo.tableViewWillDeselectRowAtIndexPath) {
        [self.delegate tableView:self willDeselectRowAtIndexPath:_selectedIndexPath];
    }
    
    [self deselectRowAtIndexPath:_selectedIndexPath animated:NO];
    
    UITouch *touch = [touches anyObject];
    CGPoint locationOfTouch = [touch locationInView:self];
    
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:locationOfTouch];
    if(indexPath) {
        if(_highlightedIndexPath) {
            UITableViewCell *oldCell = [self cellForRowAtIndexPath:_highlightedIndexPath];
            [oldCell setHighlighted:NO animated:NO];
        }
        
        UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
        [cell setHighlighted:YES animated:NO];
    }
    
    _highlightedIndexPath = indexPath;
    
    if(_selectedIndexPath && _delegateRespondsTo.tableViewDidDeselectRowAtIndexPath) {
        [self.delegate tableView:self didDeselectRowAtIndexPath:_selectedIndexPath];
    }
}

@end
