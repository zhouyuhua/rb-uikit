//
//  UIMotionEffect.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/17/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIGeometry.h"

/*
 The following classes do absolutely nothing, but do not raise any exceptions
 and fully implement NSCopying and NSCoding. So client code can continue to
 operate as expected even though there is no such thing as Mac motion.
 */

@interface UIMotionEffect : NSObject <NSCopying, NSCoding>

- (NSDictionary *)keyPathsAndRelativeValuesForViewerOffset:(UIOffset)viewerOffset;

@end

#pragma mark -

@interface UIMotionEffectGroup : UIMotionEffect

@property (nonatomic, copy) NSArray *motionEffects;

@end

#pragma mark -

typedef NS_ENUM(NSUInteger, UIInterpolatingMotionEffectType) {
    UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis,
    UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis
};

@interface UIInterpolatingMotionEffect : UIMotionEffect

- (instancetype)initWithKeyPath:(NSString *)keyPath type:(UIInterpolatingMotionEffectType)type;

@property (nonatomic, readonly) NSString *keyPath;
@property (nonatomic, readonly) UIInterpolatingMotionEffectType type;

@property (nonatomic) id maximumRelativeValue;
@property (nonatomic) id minimumRelativeValue;

@end
