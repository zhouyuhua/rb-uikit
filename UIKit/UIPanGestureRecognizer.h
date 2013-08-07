//
//  UIPanGestureRecognizer.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/6/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIGestureRecognizer.h"

@interface UIPanGestureRecognizer : UIGestureRecognizer

@property (nonatomic) NSUInteger maximumNumberOfTouches; //Ignored, always 1
@property (nonatomic) NSUInteger minimumNumberOfTouches; //Ignored, always 1

- (CGPoint)velocityInView:(UIView *)view;

- (void)setTranslation:(CGPoint)translation inView:(UIView *)view;
- (CGPoint)translationInView:(UIView *)view;

@end
