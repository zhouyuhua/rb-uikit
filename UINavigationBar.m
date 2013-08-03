//
//  RKNavigationBar.m
//  Pinna
//
//  Created by Kevin MacWhinnie on 12/6/12.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UINavigationBar.h"
#import "UIImageView.h"
#import "UIImage_Private.h"
#import "UINavigationBarAppearance.h"

@implementation UINavigationBar {
    UINavigationItem *_topItem;
    NSMutableArray *_items;
    
    UIImageView *_backgroundImageView;
    CGFloat _titleVerticalPositionAdjustment;
}

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
    _topItem.frame = self.bounds;
}

#pragma mark - Properties

- (void)setItems:(NSArray *)items animated:(BOOL)animate
{
    UIKitUnimplementedMethod();
}

- (void)setItems:(NSArray *)items
{
    [self setItems:items animated:YES];
}

- (NSArray *)items
{
    return [_items copy];
}

- (UINavigationItem *)backItem
{
    return _items[_items.count - 2];
}

- (UINavigationItem *)topItem
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

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    self.backgroundColor = tintColor;
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

- (void)replaceVisibleNavigationItemWith:(UINavigationItem *)view
{
    if(_topItem) {
        [_topItem removeFromSuperview];
        _topItem = nil;
    }
    
    _topItem = view;
    
    if(_topItem) {
        [_topItem setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_topItem setFrame:self.bounds];
        [self addSubview:_topItem];
    }
}

- (void)replaceVisibleNavigationItemPushingFromLeft:(UINavigationItem *)newView
{
    if(!_topItem) {
        [self replaceVisibleNavigationItemWith:newView];
        return;
    }
    
    NSRect initialNewViewFrame = self.bounds;
    initialNewViewFrame.origin.x = -NSWidth(initialNewViewFrame);
    [newView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [newView setFrame:initialNewViewFrame];
    [self addSubview:newView];
    
    UIView *oldView = _topItem;
    NSRect oldViewTargetFrame = oldView.frame;
    oldViewTargetFrame.origin.x = NSMaxX(oldViewTargetFrame);
    
    NSRect newViewTargetFrame = initialNewViewFrame;
    newViewTargetFrame.origin.x = 0;
    
    _topItem = newView;
    [UIView animateWithDuration:0.2 animations:^{
        [oldView setAlpha:0.0];
        [oldView setFrame:oldViewTargetFrame];
        [newView setFrame:newViewTargetFrame];
    } completion:^(BOOL finished) {
        [oldView removeFromSuperview];
        [oldView setAlpha:1.0];
    }];
}

- (void)replaceVisibleNavigationItemPushingFromRight:(UINavigationItem *)newView
{
    if(!_topItem) {
        [self replaceVisibleNavigationItemWith:newView];
        return;
    }
    
    NSRect initialNewViewFrame = self.bounds;
    initialNewViewFrame.origin.x = NSWidth(initialNewViewFrame);
    [newView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [newView setFrame:initialNewViewFrame];
    [self addSubview:newView];
    
    UIView *oldView = _topItem;
    NSRect oldViewTargetFrame = oldView.frame;
    oldViewTargetFrame.origin.x = -NSWidth(oldViewTargetFrame);
    
    NSRect newViewTargetFrame = initialNewViewFrame;
    newViewTargetFrame.origin.x = 0;
    
    _topItem = newView;
    [UIView animateWithDuration:0.2 animations:^{
        [oldView setAlpha:0.0];
        [oldView setFrame:oldViewTargetFrame];
        [newView setFrame:newViewTargetFrame];
    } completion:^(BOOL finished) {
        [oldView removeFromSuperview];
        [oldView setAlpha:1.0];
    }];
}

@end
