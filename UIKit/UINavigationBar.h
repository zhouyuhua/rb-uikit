//
//  RKNavigationBar.h
//  Pinna
//
//  Created by Kevin MacWhinnie on 12/6/12.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"
#import "UINavigationItem.h"
#import "UIBarCommon.h"
#import "UIAppearance.h"

@protocol UINavigationBarDelegate;

@interface UINavigationBar : UIView <UIAppearance, UIAppearanceContainer>

#pragma mark - Properties

@property (nonatomic, assign) id <UINavigationBarDelegate> delegate;

#pragma mark -

@property (nonatomic, copy) NSArray *items;
- (void)setItems:(NSArray *)items animated:(BOOL)animate;

@property (nonatomic, readonly) UINavigationItem *backItem;
@property (nonatomic, readonly) UINavigationItem *topItem;

#pragma mark - Appearances

@property (nonatomic) UIBarStyle barStyle UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign, getter=isTranslucent) BOOL translucent;
@property (nonatomic) UIColor *barTintColor UI_APPEARANCE_SELECTOR;

#pragma mark -

- (void)setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics UI_APPEARANCE_SELECTOR;
- (UIImage *)backgroundImageForBarMetrics:(UIBarMetrics)barMetrics UI_APPEARANCE_SELECTOR;

@property (nonatomic, retain) UIImage *shadowImage UI_APPEARANCE_SELECTOR;

#pragma mark -

@property (nonatomic, copy) NSDictionary *titleTextAttributes UI_APPEARANCE_SELECTOR;

- (void)setTitleVerticalPositionAdjustment:(CGFloat)adjustment forBarMetrics:(UIBarMetrics)barMetrics UI_APPEARANCE_SELECTOR;
- (CGFloat)titleVerticalPositionAdjustmentForBarMetrics:(UIBarMetrics)barMetrics UI_APPEARANCE_SELECTOR;

#pragma mark - Pushing and Popping Items

- (void)pushNavigationItem:(UINavigationItem *)navigationItem animated:(BOOL)animated;
- (void)popNavigationItemAnimated:(BOOL)animated;
- (void)popToNavigationItem:(UINavigationItem *)navigationItem animated:(BOOL)animated;
- (void)popToRootNavigationItemAnimated:(BOOL)animated;

@end
