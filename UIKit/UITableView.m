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
#import "UITableViewSectionInfo.h"

#import "UITableViewHeaderFooterView.h"
#import "UILabel.h"

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

#pragma mark - Responderness

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canResignFirstResponder
{
    return YES;
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
    
    _delegateRespondsTo.tableViewTitleForHeaderInSection = [delegate respondsToSelector:@selector(tableView:titleForHeaderInSection:)];
    _delegateRespondsTo.tableViewTitleForFooterInSection = [delegate respondsToSelector:@selector(tableView:titleForFooterInSection:)];
    
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
    if(!_registeredHeaderFooterClasses[identifier])
        [NSException raise:NSInternalInconsistencyException
                    format:@"%s called with reuse identifier %@ that has no registered class", __PRETTY_FUNCTION__, identifier];
    
    Class cellClass = _registeredHeaderFooterClasses[identifier];
    if(cellClass) {
        return [[cellClass alloc] initWithReuseIdentifier:identifier];
    } else {
        return nil;
    }
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    NSParameterAssert(identifier);
    
    NSMutableArray *cellsForIdentifier = _reusableCells[identifier];
    UITableViewCell *cell = [cellsForIdentifier firstObject];
    if(cell) {
        [cellsForIdentifier removeObject:cell];
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
        [NSException raise:NSInternalInconsistencyException
                    format:@"%s called with reuse identifier %@ that has no registered class", __PRETTY_FUNCTION__, identifier];
    
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
        UITableViewSectionInfo *sectionInfo = [UITableViewSectionInfo new];
        
        sectionInfo.headerView = [self _headerViewForSection:section];
        if(sectionInfo.headerView) {
            sectionInfo.headerHeight = [self _heightForHeaderOfSection:section hasView:YES];
            [self addSubview:sectionInfo.headerView];
        }
        
        sectionInfo.footerView = [self _footerViewForSection:section];
        if(sectionInfo.footerView) {
            sectionInfo.footerHeight = [self _heightForFooterOfSection:section hasView:YES];
            [self addSubview:sectionInfo.footerView];
        }
        
        sectionInfo.numberOfRows = [self numberOfRowsInSection:section];
        
        for (NSUInteger row = 0, numberOfRows = sectionInfo.numberOfRows; row < numberOfRows; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            sectionInfo.rowHeights[row] = [self _heightForRowAtIndexPath:indexPath];
        }
        
        [_sections addObject:sectionInfo];
        
        //-[UITableView rectForSection:] won't work until after the
        //section info object is placed into the `_sections` array.
        sectionInfo.sectionFrame = [self rectForSection:section];
    }
}

- (void)_updateContentSize
{
    CGFloat totalHeight = 0.0;
    
    for (UITableViewSectionInfo *sectionInfo in _sections)
        totalHeight += sectionInfo.totalHeight;
    
    self.contentSize = CGSizeMake(0.0, totalHeight);
}

- (void)_layoutContents
{
    CGRect visibleRect = [self _visibleBounds];
    [_sections enumerateObjectsUsingBlock:^(UITableViewSectionInfo *sectionInfo, NSUInteger section, BOOL *stop) {
        CGRect headerFrame = [self rectForHeaderInSection:section];
        sectionInfo.headerView.frame = headerFrame;
        
        CGRect footerFrame = [self rectForFooterInSection:section];
        sectionInfo.footerView.frame = footerFrame;
        
        for (NSUInteger row = 0, numberOfRows = sectionInfo.numberOfRows; row < numberOfRows; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
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
            
            [self bringSubviewToFront:sectionInfo.headerView];
            [self bringSubviewToFront:sectionInfo.footerView];
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
    for (UITableViewSectionInfo *sectionInfo in _sections) {
        [sectionInfo.headerView removeFromSuperview];
        [sectionInfo.footerView removeFromSuperview];
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
    UITableViewSectionInfo *sectionInfo = _sections[section];
    CGFloat offset = [self _offsetForSection:section];
    return [self _rectForOffset:offset height:sectionInfo.totalHeight];
}

- (CGRect)rectForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewSectionInfo *sectionInfo = _sections[indexPath.section];
    CGFloat offset = [self _offsetForSection:indexPath.section];
    offset += sectionInfo.headerHeight;
    
    CGFloat *rowHeights = sectionInfo.rowHeights;
    for (NSUInteger index = 0, row = indexPath.row; index < row; index++) {
        offset += rowHeights[row];
    }
    
    return [self _rectForOffset:offset height:rowHeights[indexPath.row]];
}

- (CGRect)rectForHeaderInSection:(NSInteger)section
{
    UITableViewSectionInfo *sectionInfo = _sections[section];
    CGFloat offset = [self _offsetForSection:section];
    CGRect headerFrame = [self _rectForOffset:offset height:sectionInfo.headerHeight];
    if([self _sectionWithStickyHeader] == section) {
        headerFrame.origin.y = self.contentOffset.y;
    }
    
    return headerFrame;
}

- (CGRect)rectForFooterInSection:(NSInteger)section
{
    UITableViewSectionInfo *sectionInfo = _sections[section];
    CGFloat offset = [self _offsetForSection:section];
    return [self _rectForOffset:offset height:sectionInfo.totalHeight - sectionInfo.footerHeight];
}

#pragma mark -

- (CGRect)_visibleBounds
{
    CGRect bounds = UIEdgeInsetsInsetRect(self.bounds, self.contentInset);
    
    return CGRectMake(CGRectGetMinX(bounds), self.contentOffset.y, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
}

- (NSInteger)_sectionWithStickyHeader
{
    if(self.contentOffset.y < 0.0 || _style != UITableViewStylePlain)
        return NSNotFound;
    
    CGRect visibleBounds = [self _visibleBounds];
    for (NSUInteger section = 0, count = self.numberOfSections; section < count; section++) {
        UITableViewSectionInfo *sectionInfo = _sections[section];
        if(CGRectIntersectsRect(visibleBounds, sectionInfo.sectionFrame))
            return section;
    }
    
    return NSNotFound;
}

- (CGFloat)_offsetForSection:(NSInteger)section
{
    CGFloat offset = 0.0;
    
    for (NSUInteger row = 0; row < section; row++) {
        UITableViewSectionInfo *sectionInfo = _sections[row];
        offset += sectionInfo.totalHeight;
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
    [_sections enumerateObjectsUsingBlock:^(UITableViewSectionInfo *sectionInfo, NSUInteger section, BOOL *stop) {
        CGFloat offset = [self _offsetForSection:section];
        offset += sectionInfo.headerHeight;
        for (NSUInteger row = 0, numberOfRows = sectionInfo.numberOfRows; row < numberOfRows; row++) {
            CGFloat rowHeight = sectionInfo.rowHeights[row];
            if((point.y >= offset) && (point.y - offset) < rowHeight) {
                indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                
                *stop = YES;
                return;
            }
            
            offset += sectionInfo.rowHeights[row];
        }
        offset += sectionInfo.footerHeight;
    }];
    
    return indexPath;
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(indexPath);
    
    return _cachedCells[indexPath];
}

#pragma mark -

- (UIView *)_headerViewForSection:(NSInteger)section
{
    UIView *headerView = nil;
    if(_delegateRespondsTo.tableViewViewForHeaderInSection)
        headerView = [self.delegate tableView:self viewForHeaderInSection:section];
    
    if(!headerView && _delegateRespondsTo.tableViewTitleForHeaderInSection) {
        NSString *title = [self.delegate tableView:self titleForHeaderInSection:section];
        if(title) {
            UITableViewHeaderFooterView *headerFooterView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"<Autogenerated Header>"];
            headerFooterView.textLabel.text = title;
            
            headerView = headerFooterView;
        }
    }
    
    return headerView;
}

- (UIView *)_footerViewForSection:(NSInteger)section
{
    UIView *footerView = nil;
    if(_delegateRespondsTo.tableViewViewForFooterInSection)
        footerView = [self.delegate tableView:self viewForFooterInSection:section];
    
    return footerView;
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

#pragma mark - Actions

- (NSIndexPath *)indexPathPrecedingIndexPath:(NSIndexPath *)indexPath
{
    if(!indexPath)
        return [NSIndexPath indexPathForRow:0 inSection:0];
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    if(row == 0) {
        if(section > 0) {
            section--;
            row = [self numberOfRowsInSection:section] - 1;
        } else {
            return nil;
        }
    } else {
        row--;
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (NSIndexPath *)indexPathFollowingIndexPath:(NSIndexPath *)indexPath
{
    if(!indexPath)
        return [NSIndexPath indexPathForRow:0 inSection:0];
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row + 1;
    if(row >= [self numberOfRowsInSection:section]) {
        section++;
        row = 0;
        
        if(section >= [self numberOfSections] || [self numberOfRowsInSection:section] == 0)
            return nil;
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (IBAction)selectNextRow:(id)sender
{
    [self selectRowAtIndexPath:[self indexPathFollowingIndexPath:self.indexPathForSelectedRow] animated:NO scrollPosition:UITableViewScrollPositionTop];
}

- (IBAction)selectPreviousRow:(id)sender
{
    [self selectRowAtIndexPath:[self indexPathPrecedingIndexPath:self.indexPathForSelectedRow] animated:NO scrollPosition:UITableViewScrollPositionTop];
}

- (IBAction)deselectAll:(id)sender
{
    if(self.indexPathForSelectedRow != nil) {
        [self deselectRowAtIndexPath:self.indexPathForSelectedRow animated:NO];
    } else {
        NSBeep();
    }
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
    [self becomeFirstResponder];
    
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

#pragma mark -

- (void)keyDown:(UIKeyEvent *)event
{
    switch (event.keyCode) {
        case UIKeyUpArrow: {
            [self selectPreviousRow:nil];
            
            break;
        }
            
        case UIKeyDownArrow: {
            [self selectNextRow:nil];
            
            break;
        }
            
        case UIKeyRightArrow:
        case UIKeyEnter: {
            if(self.indexPathForSelectedRow && _delegateRespondsTo.tableViewDidSelectRowAtIndexPath) {
                [self.delegate tableView:self didSelectRowAtIndexPath:self.indexPathForSelectedRow];
            }
            
            break;
        }
            
        case UIKeyEscape: {
            [self deselectAll:nil];
            
            break;
        }
            
        default: {
            [super keyDown:event];
            
            break;
        }
    }
}

@end
