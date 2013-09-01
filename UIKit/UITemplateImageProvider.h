//
//  UITemplateImageProvider.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIImageProvider.h"

#import "UIColor.h"

@class UIImage;

@interface UITemplateImageProvider : UIImageProvider

- (instancetype)initWithOriginalImage:(UIImage *)originalImage;

@property (nonatomic, copy) UIImage *originalImage;

@end
