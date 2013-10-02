//
//  UINSWindow.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/22/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

///The UINSWindow class encapsulates a variation of NSWindow that hosts UIWindows.
///
///It does not provide any window chrome of its own outside of the resizing hot spots
///around the edges. It does, however, provide movement though, through any mouse move
///events not handled by the hosted UIWindow's view stack.
///
///Under normal circumstances, there should never be a need to subclass UINSWindow,
///however it is exposed for good measure.
///
/// \seealso(UIWindow+Mac)
@interface UINSWindow : NSWindow

///Modifies the style mask if it does not refer to a borderless window.
- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)aStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)flag;

@end
