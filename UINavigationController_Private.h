//
//  UINavigationController_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UINavigationController.h"

@interface UINavigationController () {
    NSMutableArray *_viewControllers;
    UIView *_visibleView;
    UINavigationBar *_navigationBar;
}

///The view that holds the contents of the controller's children.
@property (nonatomic) UIView *contentView;

@end
