//
//  UIRefreshControl.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/14/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIControl.h"
#import "UIColor.h"

@interface UIRefreshControl : UIControl

#pragma mark - Appearance

@property (nonatomic) UIColor *tintColor;
@property (nonatomic, copy) NSAttributedString *attributedTitle;

#pragma mark - Managing the Refresh Status

- (void)beginRefreshing;
- (void)endRefreshing;

@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;

@end
