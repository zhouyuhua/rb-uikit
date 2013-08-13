//
//  UIMenuController.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/12/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIView;

typedef NS_ENUM(NSUInteger, UIMenuControllerArrowDirection) {
    UIMenuControllerArrowDefault,
    UIMenuControllerArrowUp,
    UIMenuControllerArrowDown,
    UIMenuControllerArrowLeft,
    UIMenuControllerArrowRight,
};

@interface UIMenuController : NSObject

+ (UIMenuController *)sharedMenuController;

@property (nonatomic, getter=isMenuVisible) BOOL menuVisible;
- (void)setMenuVisible:(BOOL)menuVisible animated:(BOOL)animated;

- (void)setTargetRect:(CGRect)targetRect inView:(UIView *)targetView;
@property (nonatomic, readonly) CGRect menuFrame;
@property UIMenuControllerArrowDirection arrowDirection;

- (void)update;

@property (copy) NSArray *menuItems;

@end
