//
//  UITabBarItem_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UITabBarItem.h"
#import "UIBarButtonItem_Private.h"

@class UITabBar, _UITabBarItemView;

@interface UITabBarItem () {
    _UITabBarItemView *_itemView;
}

///Retyped property.
@property (nonatomic, readonly) _UITabBarItemView *_itemView;

///The system item enum associated with the item. 
@property (nonatomic) UITabBarSystemItem _tabBarSystemItem;

#pragma mark -

///The containing tab bar.
@property (nonatomic, unsafe_unretained) UITabBar *_tabBar;

@property (nonatomic, getter=_isHighlighted, setter=_setHighlighted:) BOOL _highlighted;

@end
