//
//  RKNavigationItem.m
//  Pinna
//
//  Created by Kevin MacWhinnie on 12/6/12.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UINavigationItem.h"
#import "UILabel.h"
#import "UIBarButtonItem_Private.h"
#import "UINavigationBar.h"

@interface UINavigationItem ()

@property (nonatomic) CGFloat titleVerticalPositionAdjustment;

@end

@implementation UINavigationItem {
    UILabel *_titleLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [self addSubview:_titleLabel];
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title
{
    if((self = [self initWithFrame:NSMakeRect(0.0, 0.0, 320.0, 40.0)])) {
        self.title = title;
    }
    
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect contentFrame = self.bounds;
    
    CGRect leftButtonFrame = CGRectMake(5.0, 0.0, 0.0, 0.0);
    for (UIBarButtonItem *item in _leftBarButtonItems) {
        UIView *buttonView = item.view;
        
        leftButtonFrame.size = [buttonView sizeThatFits:contentFrame.size];
        leftButtonFrame.origin.y = round(CGRectGetMidY(contentFrame) - CGRectGetHeight(leftButtonFrame) / 2.0);
        
        buttonView.frame = leftButtonFrame;
        
        leftButtonFrame.origin.x += CGRectGetWidth(leftButtonFrame);
        
        contentFrame.origin.x += CGRectGetWidth(leftButtonFrame) + 10.0;
        contentFrame.size.width -= CGRectGetWidth(leftButtonFrame) + 10.0;
    }
    
    CGRect rightButtonFrame = CGRectMake(CGRectGetMaxX(contentFrame) - 10.0, 0.0, 0.0, 0.0);
    for (UIBarButtonItem *item in _rightBarButtonItems) {
        UIView *buttonView = item.view;
        
        rightButtonFrame.size = [buttonView sizeThatFits:contentFrame.size];
        rightButtonFrame.origin.y = round(CGRectGetMidY(contentFrame) - CGRectGetHeight(rightButtonFrame) / 2.0);
        rightButtonFrame.origin.x -= CGRectGetWidth(rightButtonFrame);
        
        buttonView.frame = rightButtonFrame;
        
        rightButtonFrame.origin.x -= 5.0;
        
        contentFrame.size.width -= CGRectGetWidth(rightButtonFrame) + 10.0;
    }
    
    CGRect titleLabelFrame;
    titleLabelFrame.size = [_titleLabel sizeThatFits:self.bounds.size];
    titleLabelFrame.origin.y = round(CGRectGetMidY(self.bounds) - CGRectGetHeight(titleLabelFrame) / 2.0) + _titleVerticalPositionAdjustment;
    titleLabelFrame.origin.x = round(CGRectGetMidX(self.bounds) - CGRectGetWidth(titleLabelFrame) / 2.0);
    
    if(CGRectGetMinX(titleLabelFrame) < CGRectGetMinX(contentFrame)) {
        titleLabelFrame.origin.x = CGRectGetMinX(contentFrame) + 5.0;
    }
    
    if(CGRectGetMaxX(titleLabelFrame) >= (CGRectGetMaxX(contentFrame) - 5.0)) {
        titleLabelFrame.size.width = CGRectGetWidth(contentFrame) - 15.0;
    }
    
    _titleLabel.frame = titleLabelFrame;
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

#pragma mark - Properties

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    _titleLabel.text = title;
    
    [self setNeedsLayout];
}

- (void)setBackBarButtonItem:(UIBarButtonItem *)backBarButtonItem
{
    _backBarButtonItem = backBarButtonItem;
    
    //TODO: This is wrong.
    self.leftBarButtonItem = backBarButtonItem;
}

- (void)setTitleView:(UIView *)titleView
{
    _titleView = titleView;
}

#pragma mark -

- (void)setHidesBackButton:(BOOL)hidesBackButton animated:(BOOL)animated
{
    UIKitUnimplementedMethod();
}

#pragma mark -

- (void)setLeftBarButtonItems:(NSArray *)items animated:(BOOL)animated
{
    for (UIBarButtonItem *item in _leftBarButtonItems)
        [item.view removeFromSuperview];
    
    _leftBarButtonItems = [items copy];
    
    for (UIBarButtonItem *item in items)
        [self addSubview:item.view];
    
    [self setNeedsLayout];
}

- (void)setRightBarButtonItems:(NSArray *)items animated:(BOOL)animated
{
    for (UIBarButtonItem *item in _rightBarButtonItems)
        [item.view removeFromSuperview];
    
    _rightBarButtonItems = [items copy];
    
    for (UIBarButtonItem *item in items)
        [self addSubview:item.view];
    
    [self setNeedsLayout];
}

#pragma mark -

- (void)setLeftItemsSupplementBackButton:(BOOL)leftItemsSupplementBackButton
{
    _leftItemsSupplementBackButton = leftItemsSupplementBackButton;
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
