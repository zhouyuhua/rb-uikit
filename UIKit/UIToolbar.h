//
//  UIToolbar.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/29/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"
#import "UIAppearance.h"
#import "UIColor.h"
#import "UIBarCommon.h"

@protocol UIToolbarDelegate;
@class UIImage;

@interface UIToolbar : UIView <UIBarPositioning, UIAppearance>

#pragma mark - Configuring Toolbar Items

@property (nonatomic, copy) NSArray *items;
- (void)setItems:(NSArray *)items animated:(BOOL)animated;

#pragma mark - Customizing Appearance

@property (nonatomic) UIBarStyle barStyle UI_APPEARANCE_SELECTOR UIKIT_STUB;
@property (nonatomic) UIColor *barTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, getter=isTranslucent) BOOL translucent;
- (UIImage *)backgroundImageForToolbarPosition:(UIBarPosition)position barMetrics:(UIBarMetrics)metrics UI_APPEARANCE_SELECTOR;
- (void)setBackgroundImage:(UIImage *)image forToolbarPosition:(UIBarPosition)position barMetrics:(UIBarMetrics)metrics UI_APPEARANCE_SELECTOR;
- (UIImage *)shadowImageForToolbarPosition:(UIBarPosition)position UI_APPEARANCE_SELECTOR;
- (void)setShadowImage:(UIImage *)image forToolbarPosition:(UIBarPosition)position UI_APPEARANCE_SELECTOR;

#pragma mark - Managing the Delegate

@property (nonatomic, unsafe_unretained) id <UIToolbarDelegate> delegate;

@end

@protocol UIToolbarDelegate <NSObject, UIBarPositioningDelegate>

@end
