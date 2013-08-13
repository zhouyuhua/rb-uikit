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

#import "UICollectionViewLayout.h"

extern NSString *const UICollectionElementKindSectionHeader;
extern NSString *const UICollectionElementKindSectionFooter;

typedef NS_ENUM(NSInteger, UICollectionViewScrollDirection) {
    UICollectionViewScrollDirectionVertical,
    UICollectionViewScrollDirectionHorizontal
};

@protocol UICollectionViewDelegateFlowLayout <UICollectionViewDelegate>
@optional

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

@end

@class UIGridLayoutInfo;

@interface UICollectionViewFlowLayout : UICollectionViewLayout

@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic) CGSize itemSize; // for the cases the delegate method is not implemented
@property (nonatomic) UICollectionViewScrollDirection scrollDirection; // default is UICollectionViewScrollDirectionVertical
@property (nonatomic) CGSize headerReferenceSize;
@property (nonatomic) CGSize footerReferenceSize;

@property (nonatomic) UIEdgeInsets sectionInset;

/*
 Row alignment options exits in the official UICollectionView, but hasn't been made public API.

 Here's a snippet to test this on UICollectionView:

 NSMutableDictionary *rowAlign = [[flowLayout valueForKey:@"_rowAlignmentsOptionsDictionary"] mutableCopy];
 rowAlign[@"UIFlowLayoutCommonRowHorizontalAlignmentKey"] = @(1);
 rowAlign[@"UIFlowLayoutLastRowHorizontalAlignmentKey"] = @(3);
 [flowLayout setValue:rowAlign forKey:@"_rowAlignmentsOptionsDictionary"];
 */
@property (nonatomic, strong) NSDictionary *rowAlignmentOptions;

@end

// @steipete addition, private API in UICollectionViewFlowLayout
extern NSString *const UIFlowLayoutCommonRowHorizontalAlignmentKey;
extern NSString *const UIFlowLayoutLastRowHorizontalAlignmentKey;
extern NSString *const UIFlowLayoutRowVerticalAlignmentKey;

typedef NS_ENUM(NSInteger, UIFlowLayoutHorizontalAlignment) {
    UIFlowLayoutHorizontalAlignmentLeft,
    UIFlowLayoutHorizontalAlignmentCentered,
    UIFlowLayoutHorizontalAlignmentRight,
    UIFlowLayoutHorizontalAlignmentJustify // 3; default except for the last row
};
// TODO: settings for UIFlowLayoutRowVerticalAlignmentKey


/*
@interface UICollectionViewFlowLayout (Private)

- (CGSize)synchronizeLayout;

// For items being inserted or deleted, the collection view calls some different methods, which you should override to provide the appropriate layout information.
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForFooterInInsertedSection:(NSInteger)section;
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForHeaderInInsertedSection:(NSInteger)section;
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForInsertedItemAtIndexPath:(NSIndexPath *)indexPath;
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForFooterInDeletedSection:(NSInteger)section;
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForHeaderInDeletedSection:(NSInteger)section;
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDeletedItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)_updateItemsLayout;
- (void)_getSizingInfos;
- (void)_updateDelegateFlags;

- (UICollectionViewLayoutAttributes *)layoutAttributesForFooterInSection:(NSInteger)section;
- (UICollectionViewLayoutAttributes *)layoutAttributesForHeaderInSection:(NSInteger)section;
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath usingData:(id)data;
- (UICollectionViewLayoutAttributes *)layoutAttributesForFooterInSection:(NSInteger)section usingData:(id)data;
- (UICollectionViewLayoutAttributes *)layoutAttributesForHeaderInSection:(NSInteger)section usingData:(id)data;

- (id)indexesForSectionFootersInRect:(CGRect)rect;
- (id)indexesForSectionHeadersInRect:(CGRect)rect;
- (id)indexPathsForItemsInRect:(CGRect)rect usingData:(id)arg2;
- (id)indexesForSectionFootersInRect:(CGRect)rect usingData:(id)arg2;
- (id)indexesForSectionHeadersInRect:(CGRect)arg1 usingData:(id)arg2;
- (CGRect)_frameForItemAtSection:(int)arg1 andRow:(int)arg2 usingData:(id)arg3;
- (CGRect)_frameForFooterInSection:(int)arg1 usingData:(id)arg2;
- (CGRect)_frameForHeaderInSection:(int)arg1 usingData:(id)arg2;
- (void)_invalidateLayout;
- (NSIndexPath *)indexPathForItemAtPoint:(CGPoint)arg1;
- (UICollectionViewLayoutAttributes *)_layoutAttributesForItemsInRect:(CGRect)arg1;
- (CGSize)collectionViewContentSize;
- (void)finalizeCollectionViewUpdates;
- (void)_invalidateButKeepDelegateInfo;
- (void)_invalidateButKeepAllInfo;
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)arg1;
- (id)layoutAttributesForElementsInRect:(CGRect)arg1;
- (void)invalidateLayout;
- (id)layoutAttributesForItemAtIndexPath:(id)arg1;

@end
*/
