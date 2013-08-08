//
//  UIAnimator.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/7/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"

UIKIT_EXTERN CGFloat UIAnimatorQuadradicEaseOut(CGFloat timeWithinDuration, CGFloat start, CGFloat change, CGFloat duration);
UIKIT_EXTERN CGFloat UIAnimatorLinear(CGFloat timeWithinDuration, CGFloat start, CGFloat change, CGFloat duration);

typedef CGFloat (*UIAnimationFunction)(CGFloat timeWithinDuration, CGFloat start, CGFloat change, CGFloat duration);

@interface UIAnimator : NSObject

@property (nonatomic) NSInteger framesPerSecond;
@property (nonatomic, copy) dispatch_block_t completionHandler;

- (BOOL)animateSingleFrame;
- (void)run;
- (void)stop;

@end
