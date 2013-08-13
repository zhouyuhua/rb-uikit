/*
 Copyright (c) 2012-2013 Peter Steinberger <steipete@gmail.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "UIGridLayoutInfo.h"
#import "UIGridLayoutSection.h"
#import "UIGridLayoutItem.h"
#import "NSIndexPath+UICollectionViewAdditions.h"

@interface UIGridLayoutInfo () {
    NSMutableArray *_sections;
    CGRect _visibleBounds;
    CGSize _layoutSize;
    BOOL _isValid;
}
@property (nonatomic, strong) NSMutableArray *sections;
@end

@implementation UIGridLayoutInfo

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if((self = [super init])) {
        _sections = [NSMutableArray new];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p dimension:%.1f horizontal:%d contentSize:%@ sections:%@>", NSStringFromClass(self.class), self, self.dimension, self.horizontal, NSStringFromCGSize(self.contentSize), self.sections];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (UIGridLayoutInfo *)snapshot {
    UIGridLayoutInfo *layoutInfo = [self.class new];
    layoutInfo.sections = self.sections;
    layoutInfo.rowAlignmentOptions = self.rowAlignmentOptions;
    layoutInfo.usesFloatingHeaderFooter = self.usesFloatingHeaderFooter;
    layoutInfo.dimension = self.dimension;
    layoutInfo.horizontal = self.horizontal;
    layoutInfo.leftToRight = self.leftToRight;
    layoutInfo.contentSize = self.contentSize;
    return layoutInfo;
}

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIGridLayoutSection *section = self.sections[indexPath.section];
    CGRect itemFrame;
    if(section.fixedItemSize) {
        itemFrame = (CGRect){.size=section.itemSize};
    } else {
        itemFrame = [section.items[indexPath.item] itemFrame];
    }
    return itemFrame;
}

- (id)addSection {
    UIGridLayoutSection *section = [UIGridLayoutSection new];
    section.rowAlignmentOptions = self.rowAlignmentOptions;
    section.layoutInfo = self;
    [_sections addObject:section];
    [self invalidate:NO];
    return section;
}

- (void)invalidate:(BOOL)arg {
    _isValid = NO;
}

@end
