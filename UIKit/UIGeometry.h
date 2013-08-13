//
//  UIGeometry.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#ifndef UIKit_UIGeometry_h
#define UIKit_UIGeometry_h

typedef struct UIEdgeInsets {
    CGFloat top, left, bottom, right;
} UIEdgeInsets;

typedef struct UIOffset {
    CGFloat horizontal, vertical;
} UIOffset;

UIKIT_INLINE UIEdgeInsets UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
{
    UIEdgeInsets insets = {top, left, bottom, right};
    return insets;
}

UIKIT_INLINE CGRect UIEdgeInsetsInsetRect(CGRect rect, UIEdgeInsets insets)
{
    rect.origin.x += insets.left;
    rect.origin.y += insets.top;
    rect.size.width  -= (insets.left + insets.right);
    rect.size.height -= (insets.top  + insets.bottom);
    return rect;
}

UIKIT_INLINE UIOffset UIOffsetMake(CGFloat horizontal, CGFloat vertical)
{
    UIOffset offset = {horizontal, vertical};
    return offset;
}

UIKIT_INLINE BOOL UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsets insets1, UIEdgeInsets insets2)
{
    return insets1.left == insets2.left && insets1.top == insets2.top && insets1.right == insets2.right && insets1.bottom == insets2.bottom;
}

UIKIT_INLINE BOOL UIOffsetEqualToOffset(UIOffset offset1, UIOffset offset2)
{
    return offset1.horizontal == offset2.horizontal && offset1.vertical == offset2.vertical;
}

#define UIEdgeInsetsZero ((UIEdgeInsets){ 0.0, 0.0, 0.0, 0.0 })
#define UIOffsetZero     ((UIOffset){ 0.0, 0.0 })

#pragma mark - Compatibility

#define NSStringFromCGPoint(p)  NSStringFromPoint(p)
#define NSStringToCGPoint(p)    NSStringToPoint(p)

#pragma mark -

#define NSStringFromCGSize(p)   NSStringFromSize(p)
#define NSStringToCGSize(p)     NSStringToSize(p)

#pragma mark -

#define NSStringFromCGRect(p)   NSStringFromRect(p)
#define NSStringToCGRect(p)     NSStringToRect(p)

#endif
