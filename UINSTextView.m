//
//  UINSTextView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/28/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UINSTextView.h"

@implementation UINSTextView

- (void)scrollPoint:(NSPoint)point
{
    self.UIScrollView.contentOffset = point;
    
    [super scrollPoint:point];
}

- (void)scrollRangeToVisible:(NSRange)range
{
    NSRect boundingRect = [self.layoutManager boundingRectForGlyphRange:range inTextContainer:self.textContainer];
    [self.UIScrollView scrollRectToVisible:boundingRect animated:NO];
    
    [super scrollRangeToVisible:range];
}

- (BOOL)scrollRectToVisible:(NSRect)rect
{
    [self.UIScrollView scrollRectToVisible:rect animated:NO];
    
    return [super scrollRectToVisible:rect];
}

#pragma mark - Properties

@synthesize UIScrollView;

@end
