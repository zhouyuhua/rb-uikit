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

UIKIT_INLINE void UIKitUnimplementedMethod()
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Unimplemented method"
                                 userInfo:nil];
}

//For compatibility
enum {
    NSTextAlignmentLeft = NSLeftTextAlignment,
    NSTextAlignmentRight = NSRightTextAlignment,
    NSTextAlignmentCenter = NSCenterTextAlignment,
    NSTextAlignmentJustified = NSJustifiedTextAlignment,
    NSTextAlignmentNatural = NSNaturalTextAlignment
};

#endif
