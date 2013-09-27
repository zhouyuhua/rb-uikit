//
//  UIGraphics_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/26/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#ifndef UIKit_UIGraphics_Private_h
#define UIKit_UIGraphics_Private_h

#import "UIGraphics.h"

///Pushes a new drawing scale onto the stack.
UIKIT_EXTERN void _UIGraphicsPushScale(CGFloat scale);

///Pops the top most drawing scale from the stack.
UIKIT_EXTERN void _UIGraphicsPopScale(void);

///Returns the top most scale from the stack.
///
///Returns the main screen's scale if the stack is empty.
UIKIT_EXTERN CGFloat _UIGraphicsGetCurrentScale(void);

#endif
