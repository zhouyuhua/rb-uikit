//
//  UITabBarItem.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/30/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIBarButtonItem.h"
#import "UIAppearance.h"

@class UIImage;

typedef enum {
    UITabBarSystemItemMore,
    UITabBarSystemItemFavorites,
    UITabBarSystemItemFeatured,
    UITabBarSystemItemTopRated,
    UITabBarSystemItemRecents,
    UITabBarSystemItemContacts,
    UITabBarSystemItemHistory,
    UITabBarSystemItemBookmarks,
    UITabBarSystemItemSearch,
    UITabBarSystemItemDownloads,
    UITabBarSystemItemMostRecent,
    UITabBarSystemItemMostViewed,
} UITabBarSystemItem;

@interface UITabBarItem : UIBarButtonItem

#pragma mark - Initializing an Item

- (instancetype)initWithTabBarSystemItem:(UITabBarSystemItem)systemItem tag:(NSInteger)tag;
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag;
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage;

#pragma mark - Getting and Setting Properties

@property (nonatomic, copy) NSString *badgeValue;
@property (nonatomic) UIImage *selectedImage;

#pragma mark - Customizing Appearance

@property (nonatomic) CGFloat titlePositionAdjustment UI_APPEARANCE_SELECTOR;

@end
