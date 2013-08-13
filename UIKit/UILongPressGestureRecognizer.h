//
//  UILongPressGestureRecognizer.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/12/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIGestureRecognizer.h"

@interface UILongPressGestureRecognizer : UIGestureRecognizer

@property (nonatomic) CGFloat allowableMovement;
@property (nonatomic) CFTimeInterval minimumPressDuration;
@property (nonatomic) NSUInteger numberOfTapsRequired;
@property (nonatomic) NSInteger numberOfTouchesRequired;

@end
