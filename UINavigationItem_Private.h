//
//  UINavigationItem_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UINavigationItem.h"

@class UILabel, UIImageView, UINavigationBar;

@interface UINavigationItem () {
    UILabel *_titleLabel;
    UIImageView *_logoImageView;
}

@property (nonatomic) CGFloat titleVerticalPositionAdjustment;

@end
