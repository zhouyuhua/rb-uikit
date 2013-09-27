//
//  UINavigationItem.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UINavigationItem_Private.h"
#import "_UINavigationItemView.h"
#import "UIBarButtonItem_Private.h"

@implementation UINavigationItem

- (id)initWithTitle:(NSString *)title
{
    if((self = [super init])) {
        self.title = title;
        
        _allLeftItems = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - Properties

- (_UINavigationItemView *)_itemView
{
    if(!_itemView) {
        _itemView = [[_UINavigationItemView alloc] initWithItem:self];
    }
    
    return _itemView;
}

#pragma mark -

- (void)setTitleView:(UIView *)titleView
{
    [_itemView titleViewWillChange];
    {
        _titleView = titleView;
    }
    [_itemView titleViewDidChange];
}

#pragma mark -

- (void)setHidesBackButton:(BOOL)hidesBackButton animated:(BOOL)animated
{
    [_itemView barButtonItemsWillChange];
    {
        _hidesBackButton = hidesBackButton;
        [self _invalidateAllLeftItems];
    }
    [_itemView barButtonItemsDidChange];
}

#pragma mark -

- (void)setLeftBarButtonItems:(NSArray *)leftBarButtonItems
{
    [self setLeftBarButtonItems:leftBarButtonItems animated:NO];
}

- (void)setLeftBarButtonItems:(NSArray *)items animated:(BOOL)animated
{
    [_itemView barButtonItemsWillChange];
    {
        _leftBarButtonItems = [items copy];
        [self _invalidateAllLeftItems];
    }
    [_itemView barButtonItemsDidChange];
}

- (void)setRightBarButtonItems:(NSArray *)rightBarButtonItems
{
    [self setRightBarButtonItems:rightBarButtonItems animated:NO];
}

- (void)setRightBarButtonItems:(NSArray *)items animated:(BOOL)animated
{
    [_itemView barButtonItemsWillChange];
    {
        _rightBarButtonItems = [items copy];
        [self _invalidateAllLeftItems];
    }
    [_itemView barButtonItemsDidChange];
}

#pragma mark -

- (void)setLeftItemsSupplementBackButton:(BOOL)leftItemsSupplementBackButton
{
    [_itemView barButtonItemsWillChange];
    {
        _leftItemsSupplementBackButton = leftItemsSupplementBackButton;
    }
    [_itemView barButtonItemsDidChange];
}

#pragma mark -

- (void)setBackBarButtonItem:(UIBarButtonItem *)backBarButtonItem
{
    [_itemView barButtonItemsWillChange];
    {
        _backBarButtonItem = backBarButtonItem;
        [self _invalidateAllLeftItems];
    }
    [_itemView barButtonItemsDidChange];
}

- (UIBarButtonItem *)backBarButtonItem
{
    return _backBarButtonItem ?: [[UIBarButtonItem alloc] initWithTitle:nil
                                                                  style:UIBarButtonItemStyle_Private_Back
                                                                 target:nil
                                                                 action:nil];
}

#pragma mark -

- (void)setLeftBarButtonItem:(UIBarButtonItem *)item
{
    [self setLeftBarButtonItem:item animated:YES];
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
{
    if(item)
        [self setLeftBarButtonItems:@[ item ] animated:animated];
    else
        [self setLeftBarButtonItems:@[] animated:animated];
}

- (UIBarButtonItem *)leftBarButtonItem
{
    if(self.leftBarButtonItems.count > 0)
        return self.leftBarButtonItems[0];
    else
        return nil;
}

#pragma mark -

- (void)setRightBarButtonItem:(UIBarButtonItem *)item
{
    [self setRightBarButtonItem:item animated:YES];
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
{
    if(item)
        [self setRightBarButtonItems:@[ item ] animated:animated];
    else
        [self setRightBarButtonItems:@[] animated:animated];
}

- (UIBarButtonItem *)rightBarButtonItem
{
    if(self.rightBarButtonItems.count > 0)
        return self.rightBarButtonItems[0];
    else
        return nil;
}

#pragma mark - Internal

- (void)_invalidateAllLeftItems
{
    _allLeftItems = nil;
}

- (NSArray *)_allLeftItems
{
    if(!_allLeftItems) {
        NSMutableArray *allLeftItems = [self.leftBarButtonItems mutableCopy] ?: [NSMutableArray array];
        if(self._backItem && !self.hidesBackButton) {
            [allLeftItems insertObject:self._backItem atIndex:0];
        }
        _allLeftItems = allLeftItems;
    }
    
    return _allLeftItems;
}

- (NSArray *)_allRightItems
{
    return self.rightBarButtonItems;
}

#pragma mark -

- (void)set_backItem:(UIBarButtonItem *)_backItem
{
    [self._itemView barButtonItemsWillChange];
    {
        __backItem = _backItem;
        [self _invalidateAllLeftItems];
    }
    [self._itemView barButtonItemsDidChange];
}

@end
