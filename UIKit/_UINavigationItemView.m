//
//  RKNavigationItem.m
//  Pinna
//
//  Created by Kevin MacWhinnie on 12/6/12.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "_UINavigationItemView.h"

#import "UIViewController_Private.h"
#import "UINavigationController_Private.h"

#import "UILabel.h"
#import "UIImageView.h"

#import "UIBarButtonItem_Private.h"
#import "UINavigationBar_Private.h"
#import "UINavigationItem_Private.h"

#define OUTER_EDGE_PADDING  8.0
#define INTER_ITEM_PADDING  5.0

@interface _UINavigationItemView () {
    UILabel *_titleLabel;
}

@property (nonatomic) CGFloat titleVerticalPositionAdjustment;

#pragma mark - readwrite

@property (nonatomic, readwrite, unsafe_unretained) UINavigationItem *navigationItem;

@end

@implementation _UINavigationItemView

- (void)dealloc
{
    [_navigationItem removeObserver:self forKeyPath:@"title"];
}

- (id)initWithFrame:(CGRect)frame
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithItem:(UINavigationItem *)item
{
    if((self = [super initWithFrame:CGRectZero])) {
        self.navigationItem = item;
        
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        _titleLabel.text = _navigationItem.title;
        [_navigationItem addObserver:self forKeyPath:@"title" options:kNilOptions context:NULL];
        
        [self addSubview:_titleLabel];
        
        [self titleViewDidChange];
        [self barButtonItemsDidChange];
    }
    
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect contentFrame = self.bounds;
    
    CGRect leftButtonFrame = CGRectMake(OUTER_EDGE_PADDING, 0.0, 0.0, 0.0);
    for (UIBarButtonItem *item in _navigationItem._allLeftItems) {
        UIView *buttonView = item.view;
        
        leftButtonFrame.size = [buttonView sizeThatFits:contentFrame.size];
        leftButtonFrame.origin.y = round(CGRectGetMidY(contentFrame) - CGRectGetHeight(leftButtonFrame) / 2.0);
        
        buttonView.frame = leftButtonFrame;
        
        leftButtonFrame.origin.x += CGRectGetWidth(leftButtonFrame) + INTER_ITEM_PADDING;
        
        contentFrame.origin.x += CGRectGetWidth(leftButtonFrame) + INTER_ITEM_PADDING;
        contentFrame.size.width -= CGRectGetWidth(leftButtonFrame) + INTER_ITEM_PADDING;
    }
    
    CGRect rightButtonFrame = CGRectMake(CGRectGetMaxX(contentFrame) - OUTER_EDGE_PADDING, 0.0, 0.0, 0.0);
    for (UIBarButtonItem *item in _navigationItem._allRightItems) {
        UIView *buttonView = item.view;
        
        rightButtonFrame.size = [buttonView sizeThatFits:contentFrame.size];
        rightButtonFrame.origin.y = round(CGRectGetMidY(contentFrame) - CGRectGetHeight(rightButtonFrame) / 2.0);
        rightButtonFrame.origin.x -= CGRectGetWidth(rightButtonFrame);
        
        buttonView.frame = rightButtonFrame;
        
        rightButtonFrame.origin.x -= INTER_ITEM_PADDING;
        
        contentFrame.size.width -= CGRectGetWidth(rightButtonFrame) + INTER_ITEM_PADDING;
    }
    
    if(_navigationItem.titleView) {
        CGRect titleViewFrame = _navigationItem.titleView.frame;
        titleViewFrame.origin.y = round(CGRectGetMidY(self.bounds) - CGRectGetHeight(titleViewFrame) / 2.0) + _titleVerticalPositionAdjustment;
        titleViewFrame.origin.x = round(CGRectGetMidX(self.bounds) - CGRectGetWidth(titleViewFrame) / 2.0);
        
        if(CGRectGetMinX(titleViewFrame) < CGRectGetMinX(contentFrame)) {
            titleViewFrame.origin.x = CGRectGetMinX(contentFrame) + INTER_ITEM_PADDING;
        }
        
        _navigationItem.titleView.frame = titleViewFrame;
        
        _titleLabel.frame = CGRectZero;
    } else {
        CGRect titleLabelFrame;
        titleLabelFrame.size = [_titleLabel sizeThatFits:contentFrame.size];
        titleLabelFrame.origin.y = round(CGRectGetMidY(self.bounds) - CGRectGetHeight(titleLabelFrame) / 2.0) + _titleVerticalPositionAdjustment;
        titleLabelFrame.origin.x = round(CGRectGetMidX(self.bounds) - CGRectGetWidth(titleLabelFrame) / 2.0);
        
        if(CGRectGetMinX(titleLabelFrame) < CGRectGetMinX(contentFrame)) {
            titleLabelFrame.origin.x = CGRectGetMinX(contentFrame) + OUTER_EDGE_PADDING;
        }
        
        if(CGRectGetMaxX(titleLabelFrame) >= (CGRectGetMaxX(contentFrame) - OUTER_EDGE_PADDING)) {
            titleLabelFrame.size.width = CGRectGetWidth(contentFrame) - (INTER_ITEM_PADDING * 2 + OUTER_EDGE_PADDING);
        }
        
        _titleLabel.frame = titleLabelFrame;
    }
}

#pragma mark - Appearance

- (UINavigationBar *)navigationBar
{
    return (UINavigationBar *)self.superview;
}

- (void)willMoveToSuperview:(UINavigationBar *)newNavigationBar
{
    NSDictionary *titleAttributes = newNavigationBar.titleTextAttributes;
    
    _titleLabel.textColor = titleAttributes[NSForegroundColorAttributeName] ?: [UIColor colorWithWhite:0.0 alpha:0.8];
    NSShadow *textShadow = titleAttributes[NSShadowAttributeName];
    if(textShadow) {
        _titleLabel.shadowColor = textShadow.shadowColor;
        _titleLabel.shadowOffset = textShadow.shadowOffset;
    } else {
        _titleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.3];
        _titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    }
    
    self.titleVerticalPositionAdjustment = [newNavigationBar titleVerticalPositionAdjustmentForBarMetrics:UIBarMetricsDefault];
}

#pragma mark - Responding to Changes

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(object == _navigationItem && [keyPath isEqualToString:@"title"]) {
        _titleLabel.text = _navigationItem.title;
        [self setNeedsLayout];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark -

- (void)titleViewWillChange
{
    [_navigationItem.titleView removeFromSuperview];
    
    [self setNeedsLayout];
}

- (void)titleViewDidChange
{
    if(_navigationItem.titleView) {
        [self addSubview:_navigationItem.titleView];
    }
    
    [self setNeedsLayout];
}

#pragma mark -

- (void)barButtonItemsWillChange
{
    for (UIBarButtonItem *leftItem in _navigationItem._allLeftItems) {
        [leftItem.view removeFromSuperview];
    }
    
    for (UIBarButtonItem *rightItem in _navigationItem._allRightItems) {
        [rightItem.view removeFromSuperview];
    }
}

- (void)barButtonItemsDidChange
{
    for (UIBarButtonItem *leftItem in _navigationItem._allLeftItems) {
        [self addSubview:leftItem.view];
    }
    
    for (UIBarButtonItem *rightItem in _navigationItem._allRightItems) {
        [self addSubview:rightItem.view];
    }
    
    [self setNeedsLayout];
}

@end
