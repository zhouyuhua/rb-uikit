//
//  _UITabBarItemView.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"

@class UITabBarItem, UIImageView, UILabel;

@interface _UITabBarItemView : UIView

- (instancetype)initWithItem:(UITabBarItem *)item;

#pragma mark - Properties

@property (nonatomic, unsafe_unretained) UITabBarItem *item;

#pragma mark -

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *badgeLabel;

#pragma mark -

@property (nonatomic, getter=isHighlighted) BOOL highlighted;

#pragma mark - Observing Changes

- (void)tabBarItemWillChange;
- (void)tabBarItemDidChange;

@end
