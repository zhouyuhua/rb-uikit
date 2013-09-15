//
//  UIRefreshControl.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/14/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIRefreshControl_Private.h"

#import "UIActivityIndicatorView.h"
#import "UITableView_Private.h"

#import "UILabel.h"
#import "UIFont.h"

CGFloat const _UIRefreshControlFullHeight = 40.0;

@implementation UIRefreshControl

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
        self._activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:self._activityIndicatorView];
        
        self._titleLabel = [UILabel new];
        self._titleLabel.font = [UIFont boldSystemFontOfSize:11.0];
        self._titleLabel.textColor = [UIColor colorWithWhite:0.1 alpha:1.0];
        self._titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:self._titleLabel];
        
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (id)init
{
    return [self initWithFrame:CGRectMake(0.0, 0.0, 320.0, 50.0)];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    
    CGRect activityIndicatorFrame = __activityIndicatorView.frame;
    
    if(_attributedTitle.length > 0) {
        CGRect titleLabelFrame;
        titleLabelFrame.size = [__titleLabel sizeThatFits:CGSizeMake(CGRectGetWidth(bounds) - 20.0 - CGRectGetWidth(activityIndicatorFrame),
                                                                     CGRectGetHeight(bounds))];
        titleLabelFrame.origin.x = round(CGRectGetMidX(bounds) - CGRectGetWidth(titleLabelFrame) / 2.0);
        titleLabelFrame.origin.y = round(CGRectGetMidY(bounds) - CGRectGetHeight(titleLabelFrame) / 2.0);
        __titleLabel.frame = titleLabelFrame;
        
        activityIndicatorFrame.origin.x = CGRectGetMinX(titleLabelFrame) - CGRectGetWidth(activityIndicatorFrame) - 10.0;
        activityIndicatorFrame.origin.y = round(CGRectGetMidY(bounds) - CGRectGetHeight(activityIndicatorFrame) / 2.0);
    } else {
        activityIndicatorFrame.origin.x = round(CGRectGetMidX(bounds) - CGRectGetWidth(activityIndicatorFrame) / 2.0);
        activityIndicatorFrame.origin.y = round(CGRectGetMidY(bounds) - CGRectGetHeight(activityIndicatorFrame) / 2.0);
    }
    
    __activityIndicatorView.frame = activityIndicatorFrame;
}

#pragma mark - Appearance

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
}

- (UIColor *)tintColor
{
    return _tintColor;
}

#pragma mark -

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle
{
    _attributedTitle = [attributedTitle copy];
    
    self._titleLabel.attributedText = attributedTitle;
    
    [self setNeedsLayout];
}

#pragma mark - Managing the Refresh Status

- (void)beginRefreshing
{
    self.refreshing = YES;
    [self._activityIndicatorView startAnimating];
}

- (void)endRefreshing
{
    self.refreshing = NO;
    [self._activityIndicatorView stopAnimating];
    
    [self._tableView _refreshControlDidEndRefreshing];
}

#pragma mark - Internal Callbacks

- (void)_tableViewDidPullControl
{
    [self beginRefreshing];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
