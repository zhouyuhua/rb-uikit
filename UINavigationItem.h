//
//  UINavigationItem.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"
#import "UIBarButtonItem.h"

@interface UINavigationItem : NSObject

- (id)initWithTitle:(NSString *)title;

#pragma mark - Properties

@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, retain) UIView *titleView;

#pragma mark -

@property (nonatomic, copy) NSString *prompt;

#pragma mark -

@property (nonatomic, assign) BOOL hidesBackButton;
- (void)setHidesBackButton:(BOOL)hidesBackButton animated:(BOOL)animated;

#pragma mark -

@property (nonatomic, copy) NSArray *leftBarButtonItems;
@property (nonatomic, copy) NSArray *rightBarButtonItems;
- (void)setLeftBarButtonItems:(NSArray *)items animated:(BOOL)animated;
- (void)setRightBarButtonItems:(NSArray *)items animated:(BOOL)animated;

#pragma mark -

@property (nonatomic) BOOL leftItemsSupplementBackButton;

#pragma mark -

@property (nonatomic, retain) UIBarButtonItem *leftBarButtonItem;
- (void)setLeftBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated;

@property (nonatomic, retain) UIBarButtonItem *rightBarButtonItem;
- (void)setRightBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated;

@end
