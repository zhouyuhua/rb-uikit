//
//  UITableViewSection.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/15/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"

@interface UITableViewSectionInfo : NSObject

@property (nonatomic) NSUInteger numberOfRows;
@property (nonatomic, readonly) CGFloat *rowHeights;

#pragma mark -

@property (nonatomic) CGFloat headerHeight;
@property (nonatomic) UIView *headerView;

#pragma mark -

@property (nonatomic) CGFloat footerHeight;
@property (nonatomic) UIView *footerView;

#pragma mark -

@property (nonatomic) CGRect sectionFrame;
@property (nonatomic, readonly) CGFloat totalHeight;

@end
