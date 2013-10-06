//
//  UIBarButtonItem_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIBarButtonItem.h"

@class UIButton;

enum : NSInteger {
    UIBarButtonItemStyle_Private_Back = 101,
};

@interface UIBarButtonItem ()

@property (nonatomic) UIBarButtonSystemItem _systemItem;

#pragma mark -

///The container of the bar button item.
@property (nonatomic, unsafe_unretained) Class _appearanceContainer;

///The UIButton that supplies the content of this bar button item. Lazily initialized.
@property (nonatomic, readonly) UIButton *_underlyingButton;

///Either the custom view of the bar button item, or the underlying button property.
@property (nonatomic, readonly) UIView *_itemView;

@end
