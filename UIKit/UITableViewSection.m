//
//  UITableViewSection.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/15/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UITableViewSection.h"

@implementation UITableViewSection

- (void)dealloc
{
    if(_rowHeights)
        free(_rowHeights);
}

#pragma mark - Properties

- (void)setNumberOfRows:(NSUInteger)numberOfRows
{
    _numberOfRows = numberOfRows;
    
    if(_rowHeights) {
        free(_rowHeights);
        _rowHeights = NULL;
    }
    
    _rowHeights = calloc(numberOfRows, sizeof(CGFloat));
}

#pragma mark -

- (CGFloat)totalHeight
{
    CGFloat totalheight = 0.0;
    totalheight += _headerHeight;
    totalheight += _footerHeight;
    
    for (NSUInteger row = 0; row < _numberOfRows; row++) {
        totalheight += _rowHeights[row];
    }
    
    return totalheight;
}

@end
