//
//  RKNavigationBar.m
//  Pinna
//
//  Created by Kevin MacWhinnie on 12/6/12.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UINavigationBar_Private.h"
#import "UINavigationController_Private.h"
#import "_UINavigationItemView.h"
#import "UINavigationItem_Private.h"
#import "UIImageView.h"
#import "UIImage_Private.h"
#import "UINavigationBarAppearance.h"

@implementation UINavigationBar

+ (instancetype)appearance
{
    return (UINavigationBar *)[UINavigationBarAppearance appearanceForClass:[self class]];
}

- (id)initWithFrame:(NSRect)frameRect
{
    if((self = [super initWithFrame:frameRect])) {
        _items = [NSMutableArray array];
        _backgroundImageView = [UIImageView new];
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_backgroundImageView];
        
        UINavigationBar *appearance = self.class.appearance;
        [self setBackgroundImage:[appearance backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        self.shadowImage = appearance.shadowImage;
        
        self.titleTextAttributes = appearance.titleTextAttributes;
        [self setTitleVerticalPositionAdjustment:[appearance titleVerticalPositionAdjustmentForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        
        self.tintColor = appearance.backgroundColor;
    }
    
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _backgroundImageView.frame = self.bounds;
}

#pragma mark - Properties

- (void)setItems:(NSArray *)items animated:(BOOL)animate
{
    [self willChangeValueForKey:@"items"];
    [_items setArray:items];
    [self didChangeValueForKey:@"items"];
    
    if(items.count > 0) {
        if(animate)
            [self replaceVisibleNavigationItemPushingFromRight:items.lastObject];
        else
            [self replaceVisibleNavigationItemWith:items.lastObject];
    }
}

- (void)setItems:(NSArray *)items
{
    [self setItems:items animated:YES];
}

- (NSArray *)items
{
    return [_items copy];
}

- (_UINavigationItemView *)backItem
{
    return _items[_items.count - 2];
}

- (_UINavigationItemView *)topItem
{
    return [_items lastObject];
}

#pragma mark - Appearances

- (void)setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics
{
    if(barMetrics == UIBarMetricsDefault)
        _backgroundImageView.image = backgroundImage;
}

- (UIImage *)backgroundImageForBarMetrics:(UIBarMetrics)barMetrics
{
    if(barMetrics == UIBarMetricsDefault)
        return _backgroundImageView.image;
    
    return nil;
}

#pragma mark -

- (void)setBarTintColor:(NSColor *)barTintColor
{
    _barTintColor = barTintColor;
    self.backgroundColor = barTintColor;
}

#pragma mark -

- (void)setTitleVerticalPositionAdjustment:(CGFloat)adjustment forBarMetrics:(UIBarMetrics)barMetrics
{
    if(barMetrics == UIBarMetricsDefault)
        _titleVerticalPositionAdjustment = adjustment;
}

- (CGFloat)titleVerticalPositionAdjustmentForBarMetrics:(UIBarMetrics)barMetrics
{
    if(barMetrics == UIBarMetricsDefault)
        return _titleVerticalPositionAdjustment;
    
    return 0.0;
}

#pragma mark - Pushing and Popping Items

- (void)pushNavigationItem:(UINavigationItem *)navigationItem animated:(BOOL)animated
{
    NSParameterAssert(navigationItem);
    
    NSAssert(![_items containsObject:navigationItem],
             @"Cannot push navigation item %@ more than once", navigationItem);
    
    [_items addObject:navigationItem];
    
    if(animated)
        [self replaceVisibleNavigationItemPushingFromRight:navigationItem];
    else
        [self replaceVisibleNavigationItemWith:navigationItem];
}

- (void)popNavigationItemAnimated:(BOOL)animated
{
    if([_items count] == 1)
        return;
    
    [_items removeLastObject];
    
    if(animated)
        [self replaceVisibleNavigationItemPushingFromLeft:self.topItem];
    else
        [self replaceVisibleNavigationItemWith:self.topItem];
}

- (void)popToNavigationItem:(UINavigationItem *)navigationItem animated:(BOOL)animated
{
    NSParameterAssert(navigationItem);
    
    NSInteger indexOfNavigationItem = [_items indexOfObject:navigationItem];
    NSAssert(indexOfNavigationItem != NSNotFound,
             @"Cannot pop from navigation item %@ that isn't in stack", navigationItem);
    
    NSIndexSet *indexesToRemove = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexOfNavigationItem + 1, _items.count - (indexOfNavigationItem + 1))];
    [_items removeObjectsAtIndexes:indexesToRemove];
    
    if(animated)
        [self replaceVisibleNavigationItemPushingFromLeft:navigationItem];
    else
        [self replaceVisibleNavigationItemWith:navigationItem];
}

- (void)popToRootNavigationItemAnimated:(BOOL)animated
{
    if([self.items count] == 1)
        return;
    
    UINavigationItem *topNavigationItem = self.topItem;
    
    NSIndexSet *indexesToRemove = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, _items.count - 1)];
    [_items removeObjectsAtIndexes:indexesToRemove];
    
    if(animated)
        [self replaceVisibleNavigationItemPushingFromLeft:topNavigationItem];
    else
        [self replaceVisibleNavigationItemWith:topNavigationItem];
}

#pragma mark - Changing Frame Views

- (void)replaceVisibleNavigationItemWith:(UINavigationItem *)item
{
    if(_topItem) {
        [_topItem._itemView removeFromSuperview];
        _topItem = nil;
    }
    
    _topItem = item;
    
    if(_topItem) {
        _topItem._itemView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _topItem._itemView.frame = self.bounds;
        [self addSubview:_topItem._itemView];
    }
}

- (void)replaceVisibleNavigationItemPushingFromLeft:(UINavigationItem *)newItem
{
    if(!_topItem) {
        [self replaceVisibleNavigationItemWith:newItem];
        return;
    }
    
    UIView *newView = newItem._itemView;
    
    NSRect initialNewViewFrame = self.bounds;
    initialNewViewFrame.origin.x = -NSWidth(initialNewViewFrame);
    newView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    newView.frame = initialNewViewFrame;
    [self addSubview:newItem._itemView];
    
    UIView *oldView = _topItem._itemView;
    NSRect oldViewTargetFrame = oldView.frame;
    oldViewTargetFrame.origin.x = NSMaxX(oldViewTargetFrame);
    
    NSRect newViewTargetFrame = initialNewViewFrame;
    newViewTargetFrame.origin.x = 0;
    
    _topItem = newItem;
    [UIView animateWithDuration:UIKitDefaultAnimationDuration animations:^{
        [oldView setAlpha:0.0];
        [oldView setFrame:oldViewTargetFrame];
        [newView setFrame:newViewTargetFrame];
    } completion:^(BOOL finished) {
        [oldView removeFromSuperview];
        [oldView setAlpha:1.0];
    }];
}

- (void)replaceVisibleNavigationItemPushingFromRight:(UINavigationItem *)newItem
{
    if(!_topItem) {
        [self replaceVisibleNavigationItemWith:newItem];
        return;
    }
    
    UIView *newView = newItem._itemView;
    
    NSRect initialNewViewFrame = self.bounds;
    initialNewViewFrame.origin.x = NSWidth(initialNewViewFrame);
    [newView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [newView setFrame:initialNewViewFrame];
    [self addSubview:newView];
    
    UIView *oldView = _topItem._itemView;
    NSRect oldViewTargetFrame = oldView.frame;
    oldViewTargetFrame.origin.x = -NSWidth(oldViewTargetFrame);
    
    NSRect newViewTargetFrame = initialNewViewFrame;
    newViewTargetFrame.origin.x = 0;
    
    _topItem = newItem;
    [UIView animateWithDuration:UIKitDefaultAnimationDuration animations:^{
        [oldView setAlpha:0.0];
        [oldView setFrame:oldViewTargetFrame];
        [newView setFrame:newViewTargetFrame];
    } completion:^(BOOL finished) {
        [oldView removeFromSuperview];
        [oldView setAlpha:1.0];
    }];
}

@end
