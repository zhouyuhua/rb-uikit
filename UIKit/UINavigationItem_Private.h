//
//  UINavigationItem_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UINavigationItem.h"

@class _UINavigationItemView;

@interface UINavigationItem () {
    _UINavigationItemView *_itemView;
    NSArray *_allLeftItems;
    
    UIBarButtonItem *_backBarButtonItem;
}

@property (nonatomic, readonly) _UINavigationItemView *_itemView;

- (void)_invalidateAllLeftItems;
@property (nonatomic, readonly) NSArray *_allLeftItems;
@property (nonatomic, readonly) NSArray *_allRightItems;

@property (nonatomic) UIBarButtonItem *_backItem;

@end
