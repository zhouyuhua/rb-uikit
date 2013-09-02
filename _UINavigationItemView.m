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

@interface _UINavigationItemView () {
    UILabel *_titleLabel;
    UIImageView *_logoImageView;
}

@property (nonatomic) CGFloat titleVerticalPositionAdjustment;

#pragma mark - readwrite

@property (nonatomic, readwrite, unsafe_unretained) UINavigationItem *navigationItem;

@end

@implementation _UINavigationItemView

- (void)dealloc
{
    [_titleLabel unbind:@"text"];
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
        
        [_titleLabel bind:@"text" toObject:_navigationItem withKeyPath:@"title" options:nil];
        
        [self addSubview:_titleLabel];
    }
    
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect contentFrame = self.bounds;
    
    CGRect leftButtonFrame = CGRectMake(5.0, 0.0, 0.0, 0.0);
    for (UIBarButtonItem *item in _navigationItem.leftBarButtonItems) {
        UIView *buttonView = item.view;
        
        leftButtonFrame.size = [buttonView sizeThatFits:contentFrame.size];
        leftButtonFrame.origin.y = round(CGRectGetMidY(contentFrame) - CGRectGetHeight(leftButtonFrame) / 2.0);
        
        buttonView.frame = leftButtonFrame;
        
        leftButtonFrame.origin.x += CGRectGetWidth(leftButtonFrame);
        
        contentFrame.origin.x += CGRectGetWidth(leftButtonFrame) + 10.0;
        contentFrame.size.width -= CGRectGetWidth(leftButtonFrame) + 10.0;
    }
    
    CGRect rightButtonFrame = CGRectMake(CGRectGetMaxX(contentFrame) - 10.0, 0.0, 0.0, 0.0);
    for (UIBarButtonItem *item in _navigationItem.rightBarButtonItems) {
        UIView *buttonView = item.view;
        
        rightButtonFrame.size = [buttonView sizeThatFits:contentFrame.size];
        rightButtonFrame.origin.y = round(CGRectGetMidY(contentFrame) - CGRectGetHeight(rightButtonFrame) / 2.0);
        rightButtonFrame.origin.x -= CGRectGetWidth(rightButtonFrame);
        
        buttonView.frame = rightButtonFrame;
        
        rightButtonFrame.origin.x -= 5.0;
        
        contentFrame.size.width -= CGRectGetWidth(rightButtonFrame) + 10.0;
    }
    
    if(_logoImageView) {
        CGRect logoImageViewFrame = _logoImageView.frame;
        logoImageViewFrame.origin.y = round(CGRectGetMidY(contentFrame) - CGRectGetHeight(logoImageViewFrame) / 2.0) + _titleVerticalPositionAdjustment;
        logoImageViewFrame.origin.x = round(CGRectGetMidX(contentFrame) - CGRectGetWidth(logoImageViewFrame) / 2.0);
        _logoImageView.frame = logoImageViewFrame;
    } else {
        CGRect titleLabelFrame;
        titleLabelFrame.size = [_titleLabel sizeThatFits:contentFrame.size];
        titleLabelFrame.origin.y = round(CGRectGetMidY(contentFrame) - CGRectGetHeight(titleLabelFrame) / 2.0) + _titleVerticalPositionAdjustment;
        titleLabelFrame.origin.x = round(CGRectGetMidX(contentFrame) - CGRectGetWidth(titleLabelFrame) / 2.0);
        
        if(CGRectGetMinX(titleLabelFrame) < CGRectGetMinX(contentFrame)) {
            titleLabelFrame.origin.x = CGRectGetMinX(contentFrame) + 5.0;
        }
        
        if(CGRectGetMaxX(titleLabelFrame) >= (CGRectGetMaxX(contentFrame) - 5.0)) {
            titleLabelFrame.size.width = CGRectGetWidth(contentFrame) - 15.0;
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

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if(self.navigationBar._navigationController._rootViewController) {
        NSString *navigationControllerBarLogoImageName = [UIKitConfigurationManager sharedConfigurationManager].navigationControllerBarLogoImageName;
        if(navigationControllerBarLogoImageName) {
            _titleLabel.hidden = YES;
            
            _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:navigationControllerBarLogoImageName]];
            [self addSubview:_logoImageView];
        } else {
            _titleLabel.hidden = NO;
            [_logoImageView removeFromSuperview];
        }
    } else {
        _titleLabel.hidden = NO;
        [_logoImageView removeFromSuperview];
    }
}

#pragma mark - Responding to Changes

- (void)titleViewDidChange
{
    [self setNeedsLayout];
}

- (void)barButtonItemsDidChange
{
    [self setNeedsLayout];
}

@end
