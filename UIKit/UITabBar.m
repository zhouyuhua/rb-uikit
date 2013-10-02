//
//  UITabBar.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UITabBar.h"

#import "UITabBarItem_Private.h"
#import "_UITabBarItemView.h"

#import "UIImage_Private.h"
#import "UIImageView.h"

static CGFloat const kPreferredHeight = 50.0;

@interface UITabBar () {
    UIImageView *_backgroundImageView;
    UIImageView *_shadowImageView;
    
    UIImageView *_selectionImageView;
}

@end

#pragma mark -

@implementation UITabBar

+ (instancetype)appearance
{
    return nil;
}

+ (instancetype)appearanceWhenContainedIn:(Class<UIAppearanceContainer>)ContainerClass, ...
{
    return nil;
}

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
        self.itemSpacing = 5.0;
        self.itemWidth = 52.0;
        
        self.barTintColor = [UIColor whiteColor];
        self.backgroundImage = UIKitImageNamed(@"UITabBarBackground", UIImageResizingModeStretch);
        self.shadowImage = UIKitImageNamed(@"UITabBarShadow", UIImageResizingModeStretch);
        
        self.clipsToBounds = NO;
        
        _backgroundImageView = [[UIImageView alloc] initWithImage:self.backgroundImage];
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_backgroundImageView];
        
        _shadowImageView = [[UIImageView alloc] initWithImage:self.shadowImage];
        _shadowImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_shadowImageView];
        
        _selectionImageView = [[UIImageView alloc] initWithImage:self.selectionIndicatorImage];
        [self addSubview:_selectionImageView];
    }
    
    return self;
}

#pragma mark - Layout

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width ?: 320.0, kPreferredHeight);
}

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    _backgroundImageView.frame = bounds;
    
    
    CGRect shadowFrame = _shadowImageView.frame;
    shadowFrame.size.width = CGRectGetWidth(bounds);
    shadowFrame.origin.y = -CGRectGetHeight(shadowFrame);
    _shadowImageView.frame = shadowFrame;
    
    
    CGRect contentBounds = CGRectInset(bounds, _itemSpacing, 0.0);
    
    CGFloat totalAreaOfItems = (_itemWidth + _itemSpacing) * _items.count;
    CGFloat initialXPosition = (totalAreaOfItems >= CGRectGetWidth(contentBounds))? CGRectGetMinX(contentBounds) : round(CGRectGetMidX(contentBounds) - totalAreaOfItems / 2.0);
    NSUInteger numberOfVisibleItems = CGRectGetWidth(contentBounds) / (_itemWidth + _itemSpacing);
    
    __block CGRect itemFrame = CGRectMake(initialXPosition,
                                          CGRectGetMinY(contentBounds),
                                          _itemWidth,
                                          CGRectGetHeight(contentBounds));
    __block CGRect selectionFrame = CGRectZero;
    
    [_items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger index, BOOL *stop) {
        _UITabBarItemView *itemView = item._itemView;
        if(index >= numberOfVisibleItems) {
            itemView.hidden = YES;
        } else {
            if(item == _selectedItem)
                selectionFrame = itemFrame;
            
            itemView.frame = itemFrame;
            itemFrame.origin.x += _itemWidth + _itemSpacing;
            
            itemView.hidden = NO;
        }
    }];
    
    _selectionImageView.frame = selectionFrame;
}

#pragma mark - Configuring Tab Bar Items

- (void)setItems:(NSArray *)items
{
    [self setItems:items animated:NO];
}

- (void)setItems:(NSArray *)items animated:(BOOL)animate
{
    if(items == _items)
        return;
    
    for (UITabBarItem *item in _items) {
        [item._itemView removeFromSuperview];
        item._tabBar = nil;
        item._highlighted = NO;
    }
    
    _items = [items copy];
    
    [_items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger index, BOOL *stop) {
        item._tabBar = self;
        item._highlighted = NO;
        [self addSubview:item._itemView];
    }];
}

#pragma mark -

- (void)setSelectedItem:(UITabBarItem *)selectedItem
{
    if(selectedItem == _selectedItem)
        return;
    
    _selectedItem._highlighted = NO;
    
    _selectedItem = selectedItem;
    
    _selectedItem._highlighted = YES;
}

#pragma mark - Supporting User Customization of Tab Bars

- (void)beginCustomizingItems:(NSArray *)items
{
    
}

- (void)endCustomizingAnimated:(BOOL)animate
{
    
}

- (BOOL)isCustomizing
{
    return NO;
}

#pragma mark - Customizing Appearances

- (void)setBarTintColor:(UIColor *)barTintColor
{
    _barTintColor = barTintColor;
    
    self.backgroundColor = barTintColor;
}

#pragma mark -

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    _backgroundImageView.image = backgroundImage;
}

- (void)setShadowImage:(UIImage *)shadowImage
{
    _shadowImage = shadowImage;
    
    _shadowImageView.image = shadowImage;
    [_shadowImageView sizeToFit];
    
    [self setNeedsLayout];
}

- (void)setSelectionIndicatorImage:(UIImage *)selectionIndicatorImage
{
    _selectionIndicatorImage = selectionIndicatorImage;
    _selectionImageView.image = selectionIndicatorImage;
}

#pragma mark -

- (void)setItemPositioning:(UITabBarItemPositioning)itemPositioning
{
    //Do nothing.
}

- (UITabBarItemPositioning)itemPositioning
{
    return UITabBarItemPositioningCentered;
}

#pragma mark - Event Handling

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    UIView *view = [self hitTest:touchLocation withEvent:event];
    if(view == self)
        return;
    
    _UITabBarItemView *itemView = (_UITabBarItemView *)view;
    if(itemView.item == _selectedItem)
        return;
    
    self.selectedItem = itemView.item;
    
    [self.delegate tabBar:self didSelectItem:self.selectedItem];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    UIView *view = [self hitTest:touchLocation withEvent:event];
    if(view == self)
        return;
    
    _UITabBarItemView *itemView = (_UITabBarItemView *)view;
    if(itemView.item == _selectedItem)
        return;
    
    self.selectedItem = itemView.item;
    
    [self.delegate tabBar:self didSelectItem:self.selectedItem];
}

@end
