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

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UICollectionUpdateAction) {
    UICollectionUpdateActionInsert,
    UICollectionUpdateActionDelete,
    UICollectionUpdateActionReload,
    UICollectionUpdateActionMove,
    UICollectionUpdateActionNone
};

@interface UICollectionViewUpdateItem : NSObject

@property (nonatomic, readonly, strong) NSIndexPath *indexPathBeforeUpdate; // nil for UICollectionUpdateActionInsert
@property (nonatomic, readonly, strong) NSIndexPath *indexPathAfterUpdate;  // nil for UICollectionUpdateActionDelete
@property (nonatomic, readonly, assign) UICollectionUpdateAction updateAction;


- (id)initWithInitialIndexPath:(NSIndexPath *)arg1
        finalIndexPath:(NSIndexPath *)arg2
        updateAction:(UICollectionUpdateAction)arg3;

- (id)initWithAction:(UICollectionUpdateAction)arg1
        forIndexPath:(NSIndexPath *)indexPath;

- (id)initWithOldIndexPath:(NSIndexPath *)arg1 newIndexPath:(NSIndexPath *)arg2;

- (UICollectionUpdateAction)updateAction;

- (NSComparisonResult)compareIndexPaths:(UICollectionViewUpdateItem *)otherItem;

- (NSComparisonResult)inverseCompareIndexPaths:(UICollectionViewUpdateItem *)otherItem;

@end
