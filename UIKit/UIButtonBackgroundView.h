//
//  UIButtonBackgroundView.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"
#import "UIGeometry.h"

@class UIImage;

@interface UIButtonBackgroundView : UIView

@property (nonatomic, getter=isHighlighted) BOOL highlighted;

- (CGSize)constrainButtonSize:(CGSize)size withTitle:(NSString *)title image:(UIImage *)image;

@end
