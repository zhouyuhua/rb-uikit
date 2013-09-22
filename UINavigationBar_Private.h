//
//  UINavigationBar_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UINavigationBar.h"

@class UIImageView, UINavigationController;

@interface UINavigationBar () {
    UINavigationItem *_topItem;
    NSMutableArray *_items;
    
    UIImageView *_backgroundImageView;
    CGFloat _titleVerticalPositionAdjustment;
    
    UIImageView *_shadowImageView;
}

///The navigation controller of the bar.
@property (nonatomic, unsafe_unretained) UINavigationController *_navigationController;

@end
