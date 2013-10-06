//
//  UIToolbar.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/29/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIToolbar.h"
#import "UIBarButtonItem_Private.h"
#import "UIImage_Private.h"
#import "UIImageView.h"

#import "UIConcreteAppearance.h"

#define OUTER_EDGE_PADDING  8.0
#define INTER_ITEM_PADDING  8.0

@interface UIToolbar () {
    UIImageView *_backgroundView;
    NSUInteger _numberOfFlexibleSpaces;
}

@end

@implementation UIToolbar

UI_CONCRETE_APPEARANCE_GENERATE(UIToolbar);

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
        self.barTintColor = [UIColor clearColor];
        self.translucent = YES;
        
        _backgroundView = [UIImageView new];
        _backgroundView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_backgroundView];
        
        [self setBackgroundImage:UIKitImageNamed(@"UIToolBarBackgroundImage", UIImageResizingModeStretch)
              forToolbarPosition:UIBarPositionAny 
                      barMetrics:UIBarMetricsDefault];
    }
    
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    CGRect contentBounds = CGRectInset(bounds, OUTER_EDGE_PADDING, 0.0);
    
    _backgroundView.frame = bounds;
    
    CGFloat flexibleSpaceWidth = CGRectGetWidth(contentBounds) / _numberOfFlexibleSpaces + INTER_ITEM_PADDING * 2.0;
    for (UIBarButtonItem *item in _items)
        flexibleSpaceWidth -= CGRectGetWidth(item._itemView.bounds) + INTER_ITEM_PADDING;
    
    if(flexibleSpaceWidth < 0.0)
        flexibleSpaceWidth = 0.0;
    
    CGRect itemFrame = CGRectMake(CGRectGetMinX(contentBounds), 0.0, 0.0, 0.0);
    for (UIBarButtonItem *item in _items) {
        if(item._systemItem == UIBarButtonSystemItemFlexibleSpace) {
            itemFrame.origin.x += flexibleSpaceWidth;
            continue;
        }
        
        UIView *itemView = item._itemView;
        itemFrame.size = itemView.bounds.size;
        itemFrame.origin.y = round(CGRectGetMidY(contentBounds) - CGRectGetHeight(itemFrame) / 2.0);
        itemView.frame = itemFrame;
        
        itemFrame.origin.x += CGRectGetWidth(itemFrame) + INTER_ITEM_PADDING;
    }
}

#pragma mark - Configuring Toolbar Items

- (void)setItems:(NSArray *)items
{
    [self setItems:items animated:NO];
}

- (void)setItems:(NSArray *)items animated:(BOOL)animated
{
    for (UIBarButtonItem *item in _items) {
        [item._itemView removeFromSuperview];
        item._appearanceContainer = Nil;
    }
    
    _items = [items copy];
    _numberOfFlexibleSpaces = 0;
    
    for (UIBarButtonItem *item in _items) {
        if(item._systemItem == UIBarButtonSystemItemFlexibleSpace) {
            _numberOfFlexibleSpaces++;
        } else {
            [self addSubview:item._itemView];
            item._appearanceContainer = [UIToolbar class];
        }
    }
    
    [self setNeedsLayout];
}

#pragma mark - Customizing Appearance

- (void)tintColorDidChange
{
    [super tintColorDidChange];
    
    if(!UIConcreteAppearanceHasValueFor(UIConcreteAppearanceForInstance(self), @selector(backgroundImageForBarMetrics:))) {
        if(self.tintAdjustmentMode == UIViewTintAdjustmentModeNormal) {
            [self setBackgroundImage:UIKitImageNamed(@"UIToolBarBackgroundImage", UIImageResizingModeStretch)
                  forToolbarPosition:UIBarPositionAny
                          barMetrics:UIBarMetricsDefault];
        } else {
            [self setBackgroundImage:UIKitImageNamed(@"UIToolBarBackgroundImage_Inactive", UIImageResizingModeStretch)
                  forToolbarPosition:UIBarPositionAny
                          barMetrics:UIBarMetricsDefault];
        }
    }
}

#pragma mark -

- (void)setBarStyle:(UIBarStyle)barStyle
{
    //Do nothing.
}

- (UIBarStyle)barStyle
{
    return UIBarStyleDefault;
}

- (void)setBarTintColor:(UIColor *)barTintColor
{
    _barTintColor = barTintColor;
    self.backgroundColor = barTintColor;
}

#pragma mark -

- (UIImage *)backgroundImageForToolbarPosition:(UIBarPosition)position barMetrics:(UIBarMetrics)metrics
{
    if(metrics == UIBarMetricsDefault)
        return _backgroundView.image;
    
    return nil;
}

- (void)setBackgroundImage:(UIImage *)image forToolbarPosition:(UIBarPosition)position barMetrics:(UIBarMetrics)metrics
{
    if(metrics == UIBarMetricsDefault)
        _backgroundView.image = image;
}

#pragma mark -

- (UIImage *)shadowImageForToolbarPosition:(UIBarPosition)position
{
    UIKitUnimplementedMethod();
    return nil;
}

- (void)setShadowImage:(UIImage *)image forToolbarPosition:(UIBarPosition)position
{
    UIKitUnimplementedMethod();
}

#pragma mark - <UIBarPositioning>

- (UIBarPosition)barPosition
{
    return UIBarPositionBottom;
}

@end
