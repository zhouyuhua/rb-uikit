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
}

@property (nonatomic, readonly) _UINavigationItemView *_itemView;



@end
