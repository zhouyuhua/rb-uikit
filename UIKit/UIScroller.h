//
//  UIScroller.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/6/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"

typedef NS_ENUM(NSUInteger, UIScrollerOrientation) {
    UIScrollerOrientationVertical,
    UIScrollerOrientationHorizontal,
};

@interface UIScroller : UIView

- (instancetype)initWithOrientation:(UIScrollerOrientation)orientation;

@property (nonatomic) UIScrollerOrientation orientation;

@property (nonatomic) CGSize contentSize;
@property (nonatomic) CGPoint contentOffset;

@end

UIKIT_EXTERN CGFloat const UIScrollerTrackArea;
UIKIT_EXTERN CGFloat const UIScrollerMinimumKnobArea;
