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

#import <UIKit/UIKit.h>

@class UIGridLayoutSection, UIGridLayoutItem;

@interface UIGridLayoutRow : NSObject

@property (nonatomic, unsafe_unretained) UIGridLayoutSection *section;
@property (nonatomic, strong, readonly) NSArray *items;
@property (nonatomic, assign) CGSize rowSize;
@property (nonatomic, assign) CGRect rowFrame;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL complete;
@property (nonatomic, assign) BOOL fixedItemSize;

// @steipete addition for row-fastPath
@property (nonatomic, assign) NSInteger itemCount;

//- (UIGridLayoutRow *)copyFromSection:(UIGridLayoutSection *)section; // ???

// Add new item to items array.
- (void)addItem:(UIGridLayoutItem *)item;

// Layout current row (if invalid)
- (void)layoutRow;

// @steipete: Helper to save code in UICollectionViewFlowLayout.
// Returns the item rects when fixedItemSize is enabled.
- (NSArray *)itemRects;

//  Set current row frame invalid.
- (void)invalidate;

// Copy a snapshot of the current row data
- (UIGridLayoutRow *)snapshot;

@end
