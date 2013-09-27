//
//  UIImageView.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView : UIView

- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage;

#pragma mark - Properties

@property (nonatomic) UIImage *image;
@property (nonatomic) UIImage *highlightedImage;

#pragma mark -

@property (nonatomic, getter=isHighlighted) BOOL highlighted;

@end
