//
//  UIRefreshControl_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/14/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIRefreshControl.h"

@class UIActivityIndicatorView, UIScrollView, UILabel;

UIKIT_EXTERN CGFloat const _UIRefreshControlFullHeight;

@interface UIRefreshControl () {
    UIColor *_tintColor;
}

@property (nonatomic) UIActivityIndicatorView *_activityIndicatorView;
@property (nonatomic) UILabel *_titleLabel;

#pragma mar k-

@property (nonatomic, weak) UIScrollView *_scrollView;
- (void)_scrollViewDidPullControl;

#pragma mark - readwrite

@property (nonatomic, readwrite, getter=isRefreshing) BOOL refreshing;

@end
