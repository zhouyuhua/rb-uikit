//
//  UIKitDefines.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#ifndef UIKit_UIKitDefines_h
#define UIKit_UIKitDefines_h

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#if __cplusplus
#	define UIKIT_EXTERN     extern "C"
#else
#	define UIKIT_EXTERN     extern
#endif /* __cplusplus */

#define UIKIT_INLINE        static inline

#define UIKIT_UNIMPLEMENTED
#define UIKIT_STUB
#define UIKIT_FLAG_IS_SET(mask, flag) ((mask & flag) == flag)

#define UILocalizedString(key, comment) key

UIKIT_INLINE void UIKitInvalidParameter(NSString *parameterName, NSString *message)
{
    [NSException raise:NSInvalidArgumentException format:@"Parameter %@ unsatisfied: %@", parameterName, message];
}

UIKIT_INLINE void UIKitUnimplementedMethod()
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Unimplemented method"
                                 userInfo:nil];
}

UIKIT_INLINE void UIKitWarnUnimplementedMethod(const char *prettyFunction, NSString *functionSubset)
{
    if(functionSubset)
        NSLog(@"*** Warning, %s (%@) is unimplemented", prettyFunction, functionSubset);
    else
        NSLog(@"*** Warning, %s is unimplemented", prettyFunction);
}

#define UIKitAnimationDuration      0.25
#define UIKitAnimationDurationFast  0.15

//For compatibility
enum {
    NSTextAlignmentLeft = NSLeftTextAlignment,
    NSTextAlignmentRight = NSRightTextAlignment,
    NSTextAlignmentCenter = NSCenterTextAlignment,
    NSTextAlignmentJustified = NSJustifiedTextAlignment,
    NSTextAlignmentNatural = NSNaturalTextAlignment
};

#import "UIKitConfigurationManager.h"

#endif
