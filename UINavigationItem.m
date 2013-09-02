//
//  UINavigationItem.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UINavigationItem_Private.h"
#import "_UINavigationItemView.h"

@implementation UINavigationItem

- (id)initWithTitle:(NSString *)title
{
    if((self = [super init])) {
        self.title = title;
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
    _titleView = titleView;
    [_itemView titleViewDidChange];
}

#pragma mark -

- (void)setHidesBackButton:(BOOL)hidesBackButton animated:(BOOL)animated
{
    UIKitUnimplementedMethod();
    [_itemView barButtonItemsDidChange];
}

#pragma mark -

- (void)setLeftBarButtonItems:(NSArray *)items animated:(BOOL)animated
{
    _leftBarButtonItems = [items copy];
    [_itemView barButtonItemsDidChange];
}

- (void)setRightBarButtonItems:(NSArray *)items animated:(BOOL)animated
{
    _rightBarButtonItems = [items copy];
    [_itemView barButtonItemsDidChange];
}

#pragma mark -

- (void)setLeftItemsSupplementBackButton:(BOOL)leftItemsSupplementBackButton
{
    _leftItemsSupplementBackButton = leftItemsSupplementBackButton;
    [_itemView barButtonItemsDidChange];
}

#pragma mark -

- (void)setLeftBarButtonItem:(UIBarButtonItem *)item
{
    [self setLeftBarButtonItem:item animated:YES];
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
{
    [self setLeftBarButtonItems:@[ item ] animated:animated];
}

- (UIBarButtonItem *)leftBarButtonItem
{
    return [self.leftBarButtonItems firstObject];
}

#pragma mark -

- (void)setRightBarButtonItem:(UIBarButtonItem *)item
{
    [self setRightBarButtonItem:item animated:YES];
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
{
    [self setRightBarButtonItems:@[ item ] animated:animated];
}

- (UIBarButtonItem *)rightBarButtonItem
{
    return [self.rightBarButtonItems firstObject];
}

@end
