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

#import "UICollectionViewDelegate.h"
#import "UICollectionViewLayout.h"

extern NSString *const UICollectionElementKindCell;
extern NSString *const UICollectionElementKindDecorationView;
@class UICollectionViewLayoutAttributes;

NSString *UICollectionViewItemTypeToString(UICollectionViewItemType type); // debug helper

// Used in NSDictionaries
@interface UICollectionViewItemKey : NSObject <NSCopying>

+ (id)collectionItemKeyForLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes;

+ (id)collectionItemKeyForCellWithIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, assign) UICollectionViewItemType type;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSString *identifier;

@end
