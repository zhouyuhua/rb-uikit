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

#import "UICollectionViewFlowLayout.h"
#import "UICollectionView.h"
#import "UIGridLayoutItem.h"
#import "UIGridLayoutInfo.h"
#import "UIGridLayoutRow.h"
#import "UIGridLayoutSection.h"
#import "NSIndexPath+UICollectionViewAdditions.h"
#import <objc/runtime.h>

NSString *const UICollectionElementKindSectionHeader = @"UICollectionElementKindSectionHeader";
NSString *const UICollectionElementKindSectionFooter = @"UICollectionElementKindSectionFooter";

// this is not exposed in UICollectionViewFlowLayout
NSString *const UIFlowLayoutCommonRowHorizontalAlignmentKey = @"UIFlowLayoutCommonRowHorizontalAlignmentKey";
NSString *const UIFlowLayoutLastRowHorizontalAlignmentKey = @"UIFlowLayoutLastRowHorizontalAlignmentKey";
NSString *const UIFlowLayoutRowVerticalAlignmentKey = @"UIFlowLayoutRowVerticalAlignmentKey";

@implementation UICollectionViewFlowLayout {
    // class needs to have same iVar layout as UICollectionViewLayout
    struct {
        unsigned int delegateSizeForItem : 1;
        unsigned int delegateReferenceSizeForHeader : 1;
        unsigned int delegateReferenceSizeForFooter : 1;
        unsigned int delegateInsetForSection : 1;
        unsigned int delegateInteritemSpacingForSection : 1;
        unsigned int delegateLineSpacingForSection : 1;
        unsigned int delegateAlignmentOptions : 1;
        unsigned int keepDelegateInfoWhileInvalidating : 1;
        unsigned int keepAllDataWhileInvalidating : 1;
        unsigned int layoutDataIsValid : 1;
        unsigned int delegateInfoIsValid : 1;
    }_gridLayoutFlags;
    CGFloat _interitemSpacing;
    CGFloat _lineSpacing;
    CGSize _itemSize;
    CGSize _headerReferenceSize;
    CGSize _footerReferenceSize;
    UIEdgeInsets _sectionInset;
    UIGridLayoutInfo *_data;
    CGSize _currentLayoutSize;
    NSMutableDictionary *_insertedItemsAttributesDict;
    NSMutableDictionary *_insertedSectionHeadersAttributesDict;
    NSMutableDictionary *_insertedSectionFootersAttributesDict;
    NSMutableDictionary *_deletedItemsAttributesDict;
    NSMutableDictionary *_deletedSectionHeadersAttributesDict;
    NSMutableDictionary *_deletedSectionFootersAttributesDict;
    UICollectionViewScrollDirection _scrollDirection;
    NSDictionary *_rowAlignmentsOptionsDictionary;
    CGRect _visibleBounds;
}

@synthesize rowAlignmentOptions = _rowAlignmentsOptionsDictionary;
@synthesize minimumLineSpacing = _lineSpacing;
@synthesize minimumInteritemSpacing = _interitemSpacing;

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (void)commonInit {
    _itemSize = CGSizeMake(50.f, 50.f);
    _lineSpacing = 10.f;
    _interitemSpacing = 10.f;
    _sectionInset = UIEdgeInsetsZero;
    _scrollDirection = UICollectionViewScrollDirectionVertical;
    _headerReferenceSize = CGSizeZero;
    _footerReferenceSize = CGSizeZero;
}

- (id)init {
    if((self = [super init])) {
        [self commonInit];
        
        // set default values for row alignment.
        _rowAlignmentsOptionsDictionary = @{
                                            UIFlowLayoutCommonRowHorizontalAlignmentKey : @(UIFlowLayoutHorizontalAlignmentJustify),
                                            UIFlowLayoutLastRowHorizontalAlignmentKey : @(UIFlowLayoutHorizontalAlignmentJustify),
                                            // TODO: those values are some enum. find out what that is.
                                            UIFlowLayoutRowVerticalAlignmentKey : @(1),
                                            };
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    UIKitUnimplementedMethod();
    
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    UIKitUnimplementedMethod();
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UICollectionViewLayout

static char kUICachedItemRectsKey;

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    // Apple calls _layoutAttributesForItemsInRect
    if(!_data) [self prepareLayout];
    
    NSMutableArray *layoutAttributesArray = [NSMutableArray array];
    for (UIGridLayoutSection *section in _data.sections) {
        if(CGRectIntersectsRect(section.frame, rect)) {
            
            // if we have fixed size, calculate item frames only once.
            // this also uses the default UIFlowLayoutCommonRowHorizontalAlignmentKey alignment
            // for the last row. (we want this effect!)
            NSMutableDictionary *rectCache = objc_getAssociatedObject(self, &kUICachedItemRectsKey);
            NSUInteger sectionIndex = [_data.sections indexOfObjectIdenticalTo:section];
            
            CGRect normalizedHeaderFrame = section.headerFrame;
            normalizedHeaderFrame.origin.x += section.frame.origin.x;
            normalizedHeaderFrame.origin.y += section.frame.origin.y;
            if(!CGRectIsEmpty(normalizedHeaderFrame) && CGRectIntersectsRect(normalizedHeaderFrame, rect)) {
                UICollectionViewLayoutAttributes *layoutAttributes = [[self.class layoutAttributesClass] layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:sectionIndex]];
                layoutAttributes.frame = normalizedHeaderFrame;
                [layoutAttributesArray addObject:layoutAttributes];
            }
            
            NSArray *itemRects = rectCache[@(sectionIndex)];
            if(!itemRects && section.fixedItemSize && section.rows.count) {
                itemRects = [(section.rows)[0] itemRects];
                if(itemRects) rectCache[@(sectionIndex)] = itemRects;
            }
            
            for (UIGridLayoutRow *row in section.rows) {
                CGRect normalizedRowFrame = row.rowFrame;
                normalizedRowFrame.origin.x += section.frame.origin.x;
                normalizedRowFrame.origin.y += section.frame.origin.y;
                if(CGRectIntersectsRect(normalizedRowFrame, rect)) {
                    // TODO be more fine-grained for items
                    
                    for (NSInteger itemIndex = 0; itemIndex < row.itemCount; itemIndex++) {
                        UICollectionViewLayoutAttributes *layoutAttributes;
                        NSUInteger sectionItemIndex;
                        CGRect itemFrame;
                        if(row.fixedItemSize) {
                            itemFrame = [itemRects[itemIndex] rectValue];
                            sectionItemIndex = row.index * section.itemsByRowCount + itemIndex;
                        } else {
                            UIGridLayoutItem *item = row.items[itemIndex];
                            sectionItemIndex = [section.items indexOfObjectIdenticalTo:item];
                            itemFrame = item.itemFrame;
                        }
                        layoutAttributes = [[self.class layoutAttributesClass] layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:sectionItemIndex inSection:sectionIndex]];
                        layoutAttributes.frame = CGRectMake(normalizedRowFrame.origin.x + itemFrame.origin.x, normalizedRowFrame.origin.y + itemFrame.origin.y, itemFrame.size.width, itemFrame.size.height);
                        [layoutAttributesArray addObject:layoutAttributes];
                    }
                }
            }
            
            CGRect normalizedFooterFrame = section.footerFrame;
            normalizedFooterFrame.origin.x += section.frame.origin.x;
            normalizedFooterFrame.origin.y += section.frame.origin.y;
            if(!CGRectIsEmpty(normalizedFooterFrame) && CGRectIntersectsRect(normalizedFooterFrame, rect)) {
                UICollectionViewLayoutAttributes *layoutAttributes = [[self.class layoutAttributesClass] layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:sectionIndex]];
                layoutAttributes.frame = normalizedFooterFrame;
                [layoutAttributesArray addObject:layoutAttributes];
            }
        }
    }
    return layoutAttributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(!_data) [self prepareLayout];
    
    UIGridLayoutSection *section = _data.sections[indexPath.section];
    UIGridLayoutRow *row = nil;
    CGRect itemFrame = CGRectZero;
    
    if(section.fixedItemSize && indexPath.item / section.itemsByRowCount < (NSInteger)section.rows.count) {
        row = section.rows[indexPath.item / section.itemsByRowCount];
        NSUInteger itemIndex = indexPath.item % section.itemsByRowCount;
        NSArray *itemRects = [row itemRects];
        itemFrame = [itemRects[itemIndex] rectValue];
    } else if(indexPath.item < (NSInteger)section.items.count) {
        UIGridLayoutItem *item = section.items[indexPath.item];
        row = item.rowObject;
        itemFrame = item.itemFrame;
    }
    
    UICollectionViewLayoutAttributes *layoutAttributes = [[self.class layoutAttributesClass] layoutAttributesForCellWithIndexPath:indexPath];
    
    // calculate item rect
    CGRect normalizedRowFrame = row.rowFrame;
    normalizedRowFrame.origin.x += section.frame.origin.x;
    normalizedRowFrame.origin.y += section.frame.origin.y;
    layoutAttributes.frame = CGRectMake(normalizedRowFrame.origin.x + itemFrame.origin.x, normalizedRowFrame.origin.y + itemFrame.origin.y, itemFrame.size.width, itemFrame.size.height);
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if(!_data) [self prepareLayout];
    
    NSUInteger sectionIndex = indexPath.section;
    UICollectionViewLayoutAttributes *layoutAttributes = nil;
    
    if(sectionIndex < _data.sections.count) {
        UIGridLayoutSection *section = _data.sections[sectionIndex];
        
        CGRect normalizedFrame = CGRectZero;
        if([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            normalizedFrame = section.headerFrame;
        }
        else if([kind isEqualToString:UICollectionElementKindSectionFooter]) {
            normalizedFrame = section.footerFrame;
        }
        
        if(!CGRectIsEmpty(normalizedFrame)) {
            normalizedFrame.origin.x += section.frame.origin.x;
            normalizedFrame.origin.y += section.frame.origin.y;
            
            layoutAttributes = [[self.class layoutAttributesClass] layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:[NSIndexPath indexPathForItem:0 inSection:sectionIndex]];
            layoutAttributes.frame = normalizedFrame;
        }
    }
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewWithReuseIdentifier:(NSString *)identifier atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGSize)collectionViewContentSize {
    if(!_data) [self prepareLayout];
    
    return _data.contentSize;
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset {
    if(!UIEdgeInsetsEqualToEdgeInsets(sectionInset, _sectionInset)) {
        _sectionInset = sectionInset;
        [self invalidateLayout];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Invalidating the Layout

- (void)invalidateLayout {
    [super invalidateLayout];
    objc_setAssociatedObject(self, &kUICachedItemRectsKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    _data = nil;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    // we need to recalculate on width changes
    if((_visibleBounds.size.width != newBounds.size.width && self.scrollDirection == UICollectionViewScrollDirectionVertical) || (_visibleBounds.size.height != newBounds.size.height && self.scrollDirection == UICollectionViewScrollDirectionHorizontal)) {
        _visibleBounds = self.collectionView.bounds;
        return YES;
    }
    return NO;
}

// return a point at which to rest after scrolling - for layouts that want snap-to-point scrolling behavior
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    return proposedContentOffset;
}

- (void)prepareLayout {
    // custom ivars
    objc_setAssociatedObject(self, &kUICachedItemRectsKey, [NSMutableDictionary dictionary], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    _data = [UIGridLayoutInfo new]; // clear old layout data
    _data.horizontal = self.scrollDirection == UICollectionViewScrollDirectionHorizontal;
    _visibleBounds = self.collectionView.bounds;
    CGSize collectionViewSize = _visibleBounds.size;
    _data.dimension = _data.horizontal ? collectionViewSize.height : collectionViewSize.width;
    _data.rowAlignmentOptions = _rowAlignmentsOptionsDictionary;
    [self fetchItemsInfo];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)fetchItemsInfo {
    [self getSizingInfos];
    [self updateItemsLayout];
}

// get size of all items (if delegate is implemented)
- (void)getSizingInfos {
    NSAssert(_data.sections.count == 0, @"Grid layout is already populated?");
    
    id<UICollectionViewDelegateFlowLayout> flowDataSource = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    
    BOOL implementsSizeDelegate = [flowDataSource respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)];
    BOOL implementsHeaderReferenceDelegate = [flowDataSource respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)];
    BOOL implementsFooterReferenceDelegate = [flowDataSource respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)];
    
    NSUInteger numberOfSections = [self.collectionView numberOfSections];
    for (NSUInteger section = 0; section < numberOfSections; section++) {
        UIGridLayoutSection *layoutSection = [_data addSection];
        layoutSection.verticalInterstice = _data.horizontal ? self.minimumInteritemSpacing : self.minimumLineSpacing;
        layoutSection.horizontalInterstice = !_data.horizontal ? self.minimumInteritemSpacing : self.minimumLineSpacing;
        
        if([flowDataSource respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            layoutSection.sectionMargins = [flowDataSource collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
        } else {
            layoutSection.sectionMargins = self.sectionInset;
        }
        
        if([flowDataSource respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
            CGFloat minimumLineSpacing = [flowDataSource collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
            if(_data.horizontal) {
                layoutSection.horizontalInterstice = minimumLineSpacing;
            } else {
                layoutSection.verticalInterstice = minimumLineSpacing;
            }
        }
        
        if([flowDataSource respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
            CGFloat minimumInterimSpacing = [flowDataSource collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
            if(_data.horizontal) {
                layoutSection.verticalInterstice = minimumInterimSpacing;
            } else {
                layoutSection.horizontalInterstice = minimumInterimSpacing;
            }
        }
        
        CGSize headerReferenceSize;
        if(implementsHeaderReferenceDelegate) {
            headerReferenceSize = [flowDataSource collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
        } else {
            headerReferenceSize = self.headerReferenceSize;
        }
        layoutSection.headerDimension = _data.horizontal ? headerReferenceSize.width : headerReferenceSize.height;
        
        CGSize footerReferenceSize;
        if(implementsFooterReferenceDelegate) {
            footerReferenceSize = [flowDataSource collectionView:self.collectionView layout:self referenceSizeForFooterInSection:section];
        } else {
            footerReferenceSize = self.footerReferenceSize;
        }
        layoutSection.footerDimension = _data.horizontal ? footerReferenceSize.width : footerReferenceSize.height;
        
        NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        
        // if delegate implements size delegate, query it for all items
        if(implementsSizeDelegate) {
            for (NSUInteger item = 0; item < numberOfItems; item++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
                CGSize itemSize = implementsSizeDelegate ? [flowDataSource collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath] : self.itemSize;
                
                UIGridLayoutItem *layoutItem = [layoutSection addItem];
                layoutItem.itemFrame = (CGRect){.size=itemSize};
            }
            // if not, go the fast path
        } else {
            layoutSection.fixedItemSize = YES;
            layoutSection.itemSize = self.itemSize;
            layoutSection.itemsCount = numberOfItems;
        }
    }
}

- (void)updateItemsLayout {
    CGSize contentSize = CGSizeZero;
    for (UIGridLayoutSection *section in _data.sections) {
        [section computeLayout];
        
        // update section offset to make frame absolute (section only calculates relative)
        CGRect sectionFrame = section.frame;
        if(_data.horizontal) {
            sectionFrame.origin.x += contentSize.width;
            contentSize.width += section.frame.size.width + section.frame.origin.x;
            contentSize.height = fmaxf(contentSize.height, sectionFrame.size.height + section.frame.origin.y + section.sectionMargins.top + section.sectionMargins.bottom);
        } else {
            sectionFrame.origin.y += contentSize.height;
            contentSize.height += sectionFrame.size.height + section.frame.origin.y;
            contentSize.width = fmaxf(contentSize.width, sectionFrame.size.width + section.frame.origin.x + section.sectionMargins.left + section.sectionMargins.right);
        }
        section.frame = sectionFrame;
    }
    _data.contentSize = contentSize;
}

@end
