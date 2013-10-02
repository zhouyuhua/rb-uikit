//
//  UITabBar.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"
#import "UIBarCommon.h"
#import "UITabBarItem.h"
#import "UIColor.h"
#import "UIAppearance.h"

@protocol UITabBarDelegate;
@class UIImage;

typedef NS_ENUM(NSInteger, UITabBarItemPositioning) {
    UITabBarItemPositioningAutomatic,
    UITabBarItemPositioningFill UIKIT_UNIMPLEMENTED,
    UITabBarItemPositioningCentered,
};

@interface UITabBar : UIView <UIAppearance, UIAppearanceContainer>

#pragma mark - Setting the Delegate

@property (nonatomic, unsafe_unretained) id <UITabBarDelegate> delegate;

#pragma mark - Configuring Tab Bar Items

@property (nonatomic, copy) NSArray *items;
- (void)setItems:(NSArray *)items animated:(BOOL)animate;
@property (nonatomic, unsafe_unretained) UITabBarItem *selectedItem;

#pragma mark - Supporting User Customization of Tab Bars

- (void)beginCustomizingItems:(NSArray *)items;
- (void)endCustomizingAnimated:(BOOL)animate;
- (BOOL)isCustomizing;

#pragma mark - Customizing Tab Bar Appearance

@property (nonatomic) UIBarStyle barStyle UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *barTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UITabBarItemPositioning itemPositioning UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat itemSpacing UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat itemWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *selectedImageTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, getter=isTranslucent) BOOL translucent UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIImage *backgroundImage UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIImage *shadowImage UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIImage *selectionIndicatorImage UI_APPEARANCE_SELECTOR;

@end

@protocol UITabBarDelegate <NSObject>

#pragma mark - Customizing Tab Bars

@optional
- (void)tabBar:(UITabBar *)tabBar willBeginCustomizingItems:(NSArray *)items;
- (void)tabBar:(UITabBar *)tabBar didBeginCustomizingItems:(NSArray *)items;
- (void)tabBar:(UITabBar *)tabBar willEndCustomizingItems:(NSArray *)items changed:(BOOL)changed;
- (void)tabBar:(UITabBar *)tabBar didEndCustomizingItems:(NSArray *)items changed:(BOOL)changed;

@required
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item;

@end
