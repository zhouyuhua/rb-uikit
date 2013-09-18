//
//  UIMotionEffect.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/17/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIMotionEffect.h"

@implementation UIMotionEffect

#pragma mark - <NSCoding>

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [self init];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
}

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    return [self.class new];
}

#pragma mark - Primitive Methods

- (NSDictionary *)keyPathsAndRelativeValuesForViewerOffset:(UIOffset)viewerOffset
{
    return nil;
}

@end

#pragma mark -

@implementation UIMotionEffectGroup

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        self.motionEffects = [decoder decodeObjectForKey:@"motionEffects"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:self.motionEffects forKey:@"motionEffects"];
}

- (id)copyWithZone:(NSZone *)zone
{
    UIMotionEffectGroup *group = [super copyWithZone:zone];
    group.motionEffects = self.motionEffects;
    return group;
}

@end

#pragma mark -

@interface UIInterpolatingMotionEffect ()

@property (nonatomic, readwrite) NSString *keyPath;
@property (nonatomic, readwrite) UIInterpolatingMotionEffectType type;

@end

@implementation UIInterpolatingMotionEffect

- (instancetype)initWithKeyPath:(NSString *)keyPath type:(UIInterpolatingMotionEffectType)type
{
    if((self = [super init])) {
        self.keyPath = keyPath;
        self.type = type;
    }
    
    return self;
}

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - <NSCoding>

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        self.keyPath = [decoder decodeObjectForKey:@"keyPath"];
        self.type = [decoder decodeIntegerForKey:@"type"];
        self.minimumRelativeValue = [decoder decodeObjectForKey:@"minimumRelativeValue"];
        self.maximumRelativeValue = [decoder decodeObjectForKey:@"maximumRelativeValue"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:self.keyPath forKey:@"keyPath"];
    [encoder encodeInteger:self.type forKey:@"type"];
    [encoder encodeObject:self.minimumRelativeValue forKey:@"minimumRelativeValue"];
    [encoder encodeObject:self.maximumRelativeValue forKey:@"maximumRelativeValue"];
}

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    UIInterpolatingMotionEffect *effect = [super copyWithZone:zone];
    effect.keyPath = self.keyPath;
    effect.type = self.type;
    effect.minimumRelativeValue = self.minimumRelativeValue;
    effect.maximumRelativeValue = self.maximumRelativeValue;
    return effect;
}

@end
