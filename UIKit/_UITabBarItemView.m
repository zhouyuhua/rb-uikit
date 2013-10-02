//
//  _UITabBarItemView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "_UITabBarItemView.h"

#import "UITabBarItem_Private.h"
#import "UITabBar.h"

#import "UIImageView.h"
#import "UILabel.h"

#import "UIFont.h"

static CGSize const kImageViewSize = {30.0, 30.0};
static CGFloat const kInsetX = 5.0, kInsetY = 5.0;

@implementation _UITabBarItemView

- (instancetype)initWithItem:(UITabBarItem *)item
{
    if((self = [super init])) {
        self.item = item;
        
        self.imageView = [UIImageView new];
        self.imageView.userInteractionEnabled = NO;
        [self addSubview:self.imageView];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.userInteractionEnabled = NO;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:11.0];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        [self updateViews];
        
        self.highlighted = NO;
    }
    
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    CGRect contentBounds = CGRectInset(bounds, kInsetX, kInsetY);
    
    CGRect imageViewFrame = CGRectZero;
    imageViewFrame.size = kImageViewSize;
    imageViewFrame.origin.x = round(CGRectGetMidX(contentBounds) - CGRectGetWidth(imageViewFrame) / 2.0);
    imageViewFrame.origin.y = CGRectGetMinY(contentBounds);
    _imageView.frame = imageViewFrame;
    
    CGRect titleLabelFrame = CGRectZero;
    titleLabelFrame.size.width = CGRectGetWidth(contentBounds);
    titleLabelFrame.size.height = [_titleLabel sizeThatFits:CGSizeZero].height;
    titleLabelFrame.origin.x = CGRectGetMinX(contentBounds);
    titleLabelFrame.origin.y = CGRectGetMaxY(contentBounds) - CGRectGetHeight(titleLabelFrame);
    _titleLabel.frame = titleLabelFrame;
}

#pragma mark - Properties

- (void)setHighlighted:(BOOL)highlighted
{
    _highlighted = highlighted;
    
    if(_highlighted) {
        self.tintColor = self.item._tabBar.selectedImageTintColor;
    } else {
        self.tintColor = [UIColor blackColor];
    }
}

#pragma mark - Observing Changes

- (void)tintColorDidChange
{
    [super tintColorDidChange];
    
    _titleLabel.textColor = self.tintColor;
}

- (void)updateViews
{
    UIImage *image;
    if(_highlighted)
        image = _item.selectedImage ?: _item.image;
    
    if(image.renderingMode != UIImageRenderingModeAlwaysOriginal)
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    _imageView.image = image;
    _titleLabel.text = _item.title;
    _badgeLabel.text = _item.badgeValue;
    
    _titleLabel.textColor = self.tintColor;
}

#pragma mark -

- (void)tabBarItemWillChange
{
    
}

- (void)tabBarItemDidChange
{
    [self updateViews];
    [self setNeedsLayout];
}

@end
