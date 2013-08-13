//
//  UIMenuController_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/12/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIMenuController.h"

@class UIMenuItem;

@protocol UIMenuControllerActionHandler <NSObject>

- (BOOL)menuController:(UIMenuController *)controller shouldEnableItem:(UIMenuItem *)item;
- (void)menuController:(UIMenuController *)controller didSelectItem:(UIMenuItem *)item;

@end

#pragma mark -

@interface UIMenuController () <NSMenuDelegate>

@property (nonatomic) NSMenu *nativeMenu;

@property (nonatomic) CGRect targetRect;
@property (nonatomic, weak) UIView *targetView;

#pragma mark -

- (void)pushActionHandler:(id <UIMenuControllerActionHandler>)handler;
- (id <UIMenuControllerActionHandler>)popActionHandler;

@property (nonatomic) NSMutableArray *actionHandlers;

@end
