//
//  UIConcreteAppearance.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/19/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIConcreteAppearance.h"
#import <objc/message.h>

static const char *kClassAppearanceKey = "Class/appearance";

@implementation UIConcreteAppearance

+ (instancetype)appearanceForClass:(Class)class
{
    UIConcreteAppearance *appearance = objc_getAssociatedObject(class, kClassAppearanceKey);
    if(!appearance) {
        appearance = [self new];
        objc_setAssociatedObject(class, kClassAppearanceKey, appearance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return appearance;
}

UIConcreteAppearanceGeneratePropertyGetter(UIColor *, backgroundColor, [UIColor clearColor])

@end
