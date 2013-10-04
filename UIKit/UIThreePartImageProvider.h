//
//  UIThreePartImageProvider.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/20/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIImageProvider.h"
#import "UIImage.h"

@interface UIThreePartImageProvider : UIImageProvider

- (instancetype)initWithProvider:(UIImageProvider *)provider
                         leftCap:(CGFloat)leftCap
                        rightCap:(CGFloat)rightCap
                      isVertical:(BOOL)isVertical
                    resizingMode:(UIImageResizingMode)resizingMode;

@end
