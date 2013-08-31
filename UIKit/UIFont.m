//
//  UIFont.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/27/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIFont.h"
#import <objc/runtime.h>

__attribute__((constructor))
static void RegisterRuntimeUIFont(void)
{
    Class runtimeUIFont = objc_allocateClassPair([NSFont class], "UIFont", 0);
    objc_registerClassPair(runtimeUIFont);
}

@implementation NSFont (UIFont)

+ (NSLayoutManager *)_sharedCalculationLayoutManager
{
    NSLayoutManager *sharedCalculationLayoutManager = [NSThread currentThread].threadDictionary[@"UIKit/UIFont/sharedCalculationLayoutManager"];
    if(!sharedCalculationLayoutManager) {
        sharedCalculationLayoutManager = [NSLayoutManager new];
        [NSThread currentThread].threadDictionary[@"UIKit/UIFont/sharedCalculationLayoutManager"] = sharedCalculationLayoutManager;
    }
    
    return sharedCalculationLayoutManager;
}

- (CGFloat)lineHeight
{
    return [self.class._sharedCalculationLayoutManager defaultLineHeightForFont:self];
}

- (UIFont *)fontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:self.familyName size:size];
}

@end
