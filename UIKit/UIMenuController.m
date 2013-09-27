//
//  UIMenuController.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/12/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIMenuController_Private.h"
#import "UIMenuItem.h"

#import "UIView.h"
#import "UIWindow_Private.h"
#import "UIWindowHostNativeView.h"

#import "UIApplication.h"

@implementation UIMenuController

+ (UIMenuController *)sharedMenuController
{
    static UIMenuController *sharedMenuController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMenuController = [UIMenuController new];
    });
    
    return sharedMenuController;
}

- (id)init
{
    if((self = [super init])) {
        self.nativeMenu = [[NSMenu alloc] initWithTitle:@""];
        self.nativeMenu.delegate = self;
        
        self.menuItems = @[ [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Cut", @"") action:@selector(cut:)],
                            [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Copy", @"") action:@selector(copy:)],
                            [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Paste", @"") action:@selector(paste:)] ];
        
        self.actionHandlers = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - Properties

- (void)setMenuVisible:(BOOL)menuVisible
{
    [self setMenuVisible:menuVisible animated:YES];
}

- (void)setMenuVisible:(BOOL)menuVisible animated:(BOOL)animated
{
    if(!self.targetView)
        return;
    
    _menuVisible = menuVisible;
    
    if(menuVisible) {
        UIWindowHostNativeView *hostNativeView = self.targetView.window._hostNativeView;
        
        CGPoint popUpPoint;
        if(CGRectEqualToRect(self.targetRect, CGRectZero)) {
            CGPoint pointInWindow = [hostNativeView.window convertScreenToBase:[NSEvent mouseLocation]];
            popUpPoint = [hostNativeView convertPoint:pointInWindow fromView:nil];
        } else {
            CGRect convertedTargetRect = [self.targetView.window convertRect:self.targetView.bounds fromView:self.targetView];
            popUpPoint = convertedTargetRect.origin;
        }
        [self.nativeMenu popUpMenuPositioningItem:nil
                                       atLocation:popUpPoint
                                           inView:hostNativeView];
    } else {
        [self.nativeMenu cancelTracking];
    }
}

#pragma mark -

- (void)setTargetRect:(CGRect)targetRect inView:(UIView *)targetView
{
    self.targetRect = targetRect;
    self.targetView = targetView;
}

- (CGRect)menuFrame
{
    return (CGRect){ .origin = self.targetRect.origin, .size = self.nativeMenu.size };
}

#pragma mark -

- (void)update
{
    [self.nativeMenu update];
}

#pragma mark - Action Handlers

- (void)pushActionHandler:(id <UIMenuControllerActionHandler>)handler
{
    NSParameterAssert(handler);
    
    [self.actionHandlers addObject:handler];
}

- (id <UIMenuControllerActionHandler>)popActionHandler
{
    id <UIMenuControllerActionHandler> handler = [self.actionHandlers lastObject];
    [self.actionHandlers removeLastObject];
    return handler;
}

#pragma mark - <NSMenuDelegate>

- (NSInteger)numberOfItemsInMenu:(NSMenu *)menu
{
    return self.menuItems.count;
}

- (BOOL)menu:(NSMenu *)menu updateItem:(NSMenuItem *)item atIndex:(NSInteger)index shouldCancel:(BOOL)shouldCancel
{
    UIMenuItem *menuItem = self.menuItems[index];
    
    item.title = menuItem.title;
    item.tag = index;
    item.action = @selector(menuItemClicked:);
    item.target = self;
    
    id <UIMenuControllerActionHandler> topHandler = self.actionHandlers.lastObject;
    if(topHandler) {
        item.enabled = [topHandler menuController:self shouldEnableItem:menuItem];
    } else {
        item.enabled = [[UIApplication sharedApplication] canPerformAction:menuItem.action withSender:menuItem];
    }
    
    return YES;
}

#pragma mark -

- (void)menuWillOpen:(NSMenu *)menu
{
    
}

- (void)menuDidClose:(NSMenu *)menu
{
    [self popActionHandler];
}

#pragma mark -

- (void)menuItemClicked:(NSMenuItem *)item
{
    UIMenuItem *menuItem = self.menuItems[item.tag];
    
    id <UIMenuControllerActionHandler> topHandler = self.actionHandlers.lastObject;
    if(topHandler) {
        [topHandler menuController:self didSelectItem:menuItem];
    } else {
        [[UIApplication sharedApplication] sendAction:menuItem.action to:nil from:menuItem forEvent:nil];
    }
}

@end
