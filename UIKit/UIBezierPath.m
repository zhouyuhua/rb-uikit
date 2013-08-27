//
//  UIBezierPath.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/27/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIBezierPath.h"
#import <objc/runtime.h>

__attribute__((constructor))
static void RegisterRuntimeUIBezierPath(void)
{
    Class runtimeUIBezierPath = objc_allocateClassPair([NSBezierPath class], "UIBezierPath", 0);
    objc_registerClassPair(runtimeUIBezierPath);
}
