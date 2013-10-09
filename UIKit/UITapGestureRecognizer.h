//
//  UITapGestureRecognizer.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/8/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIGestureRecognizer.h"

@interface UITapGestureRecognizer : UIGestureRecognizer

#pragma mark - Configuring the Gesture

@property (nonatomic) NSUInteger numberOfTapsRequired;
@property (nonatomic) NSUInteger numberOfTouchesRequired;

@end
