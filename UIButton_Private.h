//
//  UIButton_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

enum : NSInteger {
    UIButtonType_Private_BarButton = 100,
    UIButtonType_Private_BackBarButton = 101,
};

@interface UIButton ()

@property (nonatomic) UIView *backgroundView;

#pragma mark - readwrite

@property (nonatomic, readwrite) UIImageView *imageView;
@property (nonatomic, readwrite) UILabel *titleLabel;

#pragma mark -

@property (nonatomic, readwrite) UIButtonType buttonType;

@end
