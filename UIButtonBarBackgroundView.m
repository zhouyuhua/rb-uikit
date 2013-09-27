//
//  UIButtonBarBackgroundView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIButtonBarBackgroundView.h"
#import "UIImage_Private.h"

///The _UIButtonBarBackgroundPlaceholderView class is a small kludge that
///enables us to draw NSButtonCell contents in the right orientation.
@interface _UIButtonBarBackgroundPlaceholderView : NSView

@end

@implementation _UIButtonBarBackgroundPlaceholderView

///All UIViews are flipped.
- (BOOL)isFlipped
{
    return YES;
}

@end

#pragma mark -

@implementation UIButtonBarBackgroundView {
    NSButtonCell *_backgroundCell;
    _UIButtonBarBackgroundPlaceholderView *_placeholderView;
}

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
        self.contentMode = UIViewContentModeRedraw;
        
        _backgroundCell = [[NSButtonCell alloc] initTextCell:@""];
        [_backgroundCell setBezelStyle:NSTexturedRoundedBezelStyle];
        [_backgroundCell setControlSize:NSRegularControlSize];
        
        _placeholderView = [_UIButtonBarBackgroundPlaceholderView new];
    }
    
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    [_backgroundCell setHighlighted:highlighted];
}

- (void)drawRect:(CGRect)rect
{
    _placeholderView.frame = rect;
    [_backgroundCell drawBezelWithFrame:rect inView:_placeholderView];
}

- (CGSize)constrainButtonSize:(CGSize)size withTitle:(NSString *)title image:(UIImage *)image
{
    size.height = 23.0;
    if(title || image)
        size.width += 20.0;
    
    return size;
}

- (void)tintColorDidChange
{
    [super tintColorDidChange];
    
    [_backgroundCell setEnabled:(self.tintAdjustmentMode == UIViewTintAdjustmentModeNormal)];
    [self setNeedsDisplay];
}

@end
