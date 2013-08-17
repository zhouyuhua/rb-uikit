//
//  UITableViewHeaderFooterView.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/13/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"

@class UILabel;

@interface UITableViewHeaderFooterView : UIView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (void)prepareForReuse;

#pragma mark - Properties

@property (nonatomic, readonly, copy) NSString *reuseIdentifier;

@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic) UIView *backgroundView;

@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, readonly) UILabel *detailTextLabel;

@end
