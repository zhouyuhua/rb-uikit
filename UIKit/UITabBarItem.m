//
//  UITabBarItem.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/30/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UITabBarItem_Private.h"

#import "_UITabBarItemView.h"
#import "UIImage_Private.h"

static NSString *TitleForTabBarSystemItem(UITabBarSystemItem item)
{
    switch (item) {
        case UITabBarSystemItemMore: {
            return UILocalizedString(@"More", @"");
        }
            
        case UITabBarSystemItemFavorites: {
            return UILocalizedString(@"Favorites", @"");
        }
            
        case UITabBarSystemItemFeatured: {
            return UILocalizedString(@"Featured", @"");
        }
            
        case UITabBarSystemItemTopRated: {
            return UILocalizedString(@"Top Rated", @"");
        }
            
        case UITabBarSystemItemRecents: {
            return UILocalizedString(@"Recents", @"");
        }
            
        case UITabBarSystemItemContacts: {
            return UILocalizedString(@"Contacts", @"");
        }
            
        case UITabBarSystemItemHistory: {
            return UILocalizedString(@"History", @"");
        }
            
        case UITabBarSystemItemBookmarks: {
            return UILocalizedString(@"Bookmarks", @"");
        }
            
        case UITabBarSystemItemSearch: {
            return UILocalizedString(@"Search", @"");
        }
            
        case UITabBarSystemItemDownloads: {
            return UILocalizedString(@"Downloads", @"");
        }
            
        case UITabBarSystemItemMostRecent: {
            return UILocalizedString(@"Most Recent", @"");
        }
            
        case UITabBarSystemItemMostViewed: {
            return UILocalizedString(@"Most Viewed", @"");
        }
    }
}

static UIImage *ImageForTabBarSystemItem(UITabBarSystemItem item)
{
    switch (item) {
        case UITabBarSystemItemMore: {
            return nil;
        }
            
        case UITabBarSystemItemFavorites: {
            return nil;
        }
            
        case UITabBarSystemItemFeatured: {
            return nil;
        }
            
        case UITabBarSystemItemTopRated: {
            return nil;
        }
            
        case UITabBarSystemItemRecents: {
            return nil;
        }
            
        case UITabBarSystemItemContacts: {
            return nil;
        }
            
        case UITabBarSystemItemHistory: {
            return nil;
        }
            
        case UITabBarSystemItemBookmarks: {
            return nil;
        }
            
        case UITabBarSystemItemSearch: {
            return UIKitImageNamed(@"UISearchBarMagnifyingGlass", UIImageResizingModeStretch);
        }
            
        case UITabBarSystemItemDownloads: {
            return nil;
        }
            
        case UITabBarSystemItemMostRecent: {
            return nil;
        }
            
        case UITabBarSystemItemMostViewed: {
            return nil;
        }
    }
}

@implementation UITabBarItem

- (instancetype)initWithTabBarSystemItem:(UITabBarSystemItem)systemItem tag:(NSInteger)tag
{
    if((self = [super init])) {
        self.title = TitleForTabBarSystemItem(systemItem);
        self.image = ImageForTabBarSystemItem(systemItem);
        self.tag = tag;
        self._tabBarSystemItem = systemItem;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag
{
    if((self = [self initWithTitle:title image:image selectedImage:nil])) {
        self.title = title;
        self.image = image;
        self.tag = tag;
        self._tabBarSystemItem = NSIntegerMax;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    if((self = [super init])) {
        self.title = title;
        self.image = image;
        self.selectedImage = selectedImage;
        self._tabBarSystemItem = NSIntegerMax;
    }
    
    return self;
}

#pragma mark - Identity

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p title => %@, image => %@, selectedImage => %@>", NSStringFromClass(self.class), self, self.title, self.image, self.selectedImage];
}

- (BOOL)isEqual:(id)object
{
    if([object isKindOfClass:[UITabBarItem class]]) {
        UITabBarItem *other = object;
        return (other._tabBarSystemItem == self._tabBarSystemItem &&
                [other.title isEqualToString:self.title] &&
                [other.image isEqual:self.image] &&
                [other.selectedImage isEqual:self.selectedImage]);
    }
    
    return NO;
}

#pragma mark - Overrides

- (_UITabBarItemView *)_itemView
{
    if(!_itemView) {
        _itemView = [[_UITabBarItemView alloc] initWithItem:self];
    }
    
    return _itemView;
}

#pragma mark - Properties

- (void)setTitle:(NSString *)title
{
    [_itemView tabBarItemWillChange];
    [super setTitle:title];
    [_itemView tabBarItemDidChange];
}

- (void)setBadgeValue:(NSString *)badgeValue
{
    [_itemView tabBarItemWillChange];
    _badgeValue = [badgeValue copy];
    [_itemView tabBarItemDidChange];
}

#pragma mark -

- (void)setImage:(UIImage *)image
{
    [_itemView tabBarItemWillChange];
    [super setImage:image];
    [_itemView tabBarItemDidChange];
}

- (void)setSelectedImage:(UIImage *)selectedImage
{
    [_itemView tabBarItemWillChange];
    _selectedImage = selectedImage;
    [_itemView tabBarItemDidChange];
}

#pragma mark -

- (void)_setHighlighted:(BOOL)highlighted
{
    self._itemView.highlighted = highlighted;
}

- (BOOL)_isHighlighted
{
    return _itemView.isHighlighted;
}

@end
