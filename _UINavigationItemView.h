//
//  RKNavigationItem.h
//  Pinna
//
//  Created by Kevin MacWhinnie on 12/6/12.
//  Copyright (c) 2013 Roundabout Software,  LLC. All rights reserved.
//

#import "UIView.h"
#import "UINavigationItem.h"

@class UIBarButtonItem;

@interface _UINavigationItemView : UIView

- (instancetype)initWithItem:(UINavigationItem *)item;

#pragma mark - Properties

@property (nonatomic, readonly, unsafe_unretained) UINavigationItem *navigationItem;

#pragma mark - Responding to Changes

- (void)titleViewDidChange;
- (void)barButtonItemsDidChange;

@end
