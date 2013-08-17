//
//  UITableViewCell_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/13/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UITableViewCell.h"
#import "UITableView.h"

@interface UITableViewCell ()

@property (nonatomic) NSIndexPath *_indexPath;
@property (nonatomic) UIView *_separatorView;

- (void)_setSeparatorStyle:(UITableViewCellSeparatorStyle)separatorStyle color:(UIColor *)color;

#pragma mark - readwrite

@property (nonatomic, readwrite) UITableViewCellStyle style;
@property (nonatomic, readwrite, copy) NSString *reuseIdentifier;

#pragma mark -

@property (nonatomic, readwrite) UIView *contentView;

#pragma mark -

@property (nonatomic, readwrite) UILabel *textLabel;
@property (nonatomic, readwrite) UILabel *detailTextLabel;
@property (nonatomic, readwrite) UIImageView *imageView;

@end
