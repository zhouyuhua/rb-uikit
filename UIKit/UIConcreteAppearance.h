//
//  UIConcreteAppearance.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/19/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIAppearance.h"
#import "UIColor.h"

#define UIConcreteAppearanceGeneratePropertyGetter(type, propertyName, ...) - (type)propertyName { return _ ## propertyName ?: ((type)__VA_ARGS__); }

@interface UIConcreteAppearance : NSObject

+ (instancetype)appearanceForClass:(Class)class;

#pragma mark - Properties

@property (nonatomic) UIColor *backgroundColor;

@end
