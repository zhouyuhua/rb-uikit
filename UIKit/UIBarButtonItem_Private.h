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

///The UIButton that supplies the content of this bar button item. Lazily initialized.
@property (nonatomic, readonly) UIButton *underlyingButton;

///Returns either the custom view of the bar button
/// item, or the underlying button property.
- (UIView *)view;

@end