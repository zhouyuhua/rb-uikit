//
//  UIBarItem.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIGeometry.h"
#import "UIImage.h"
#import "UIControl.h"

@interface UIBarItem : NSObject

@property (nonatomic, getter=isEnabled) BOOL enabled;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImage *landscapeImagePhone;
@property (nonatomic) UIEdgeInsets imageInsets;
@property (nonatomic) UIEdgeInsets landscapeImagePhoneInsets;
@property (nonatomic) NSInteger tag;

- (void)setTitleTextAttributes:(NSDictionary *)attributes forState:(UIControlState)state;
- (NSDictionary *)titleTextAttributesForState:(UIControlState)state;

@end
