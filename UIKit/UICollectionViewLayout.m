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

#import "UICollectionViewLayout_Private.h"
#import "UICollectionViewUpdateItem_Private.h"

#import "UICollectionView_Internal.h"
#import "UICollectionViewCell_Private.h"

#import "UICollectionViewItemKey.h"
#import "UICollectionViewData.h"
#import "NSIndexPath+UICollectionViewAdditions.h"

@implementation UICollectionViewLayoutAttributes

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Static

+ (instancetype)layoutAttributesForCellWithIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [self new];
    attributes.elementKind = UICollectionElementKindCell;
    attributes.elementCategory = UICollectionViewItemTypeCell;
    attributes.indexPath = indexPath;
    return attributes;
}

+ (instancetype)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind withIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [self new];
    attributes.elementCategory = UICollectionViewItemTypeSupplementaryView;
    attributes.elementKind = elementKind;
    attributes.indexPath = indexPath;
    return attributes;
}

+ (instancetype)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind withIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [self new];
    attributes.elementCategory = UICollectionViewItemTypeDecorationView;
    attributes.elementKind = elementKind;
    attributes.indexPath = indexPath;
    return attributes;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if((self = [super init])) {
        _alpha = 1.f;
        _transform3D = CATransform3DIdentity;
    }
    return self;
}

- (NSUInteger)hash {
    return ([_elementKind hash] * 31) + [_indexPath hash];
}

- (BOOL)isEqual:(id)other {
    if([other isKindOfClass:self.class]) {
        UICollectionViewLayoutAttributes *otherLayoutAttributes = (UICollectionViewLayoutAttributes *)other;
        if(_elementCategory == otherLayoutAttributes.elementCategory && [_elementKind isEqual:otherLayoutAttributes.elementKind] && [_indexPath isEqual:otherLayoutAttributes.indexPath]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p frame:%@ indexPath:%@ elementKind:%@>", NSStringFromClass(self.class), self, NSStringFromCGRect(self.frame), self.indexPath, self.elementKind];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (UICollectionViewItemType)representedElementCategory {
    return _elementCategory;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (NSString *)representedElementKind {
    return self.elementKind;
}

- (BOOL)isDecorationView {
    return self.representedElementCategory == UICollectionViewItemTypeDecorationView;
}

- (BOOL)isSupplementaryView {
    return self.representedElementCategory == UICollectionViewItemTypeSupplementaryView;
}

- (BOOL)isCell {
    return self.representedElementCategory == UICollectionViewItemTypeCell;
}

- (void)setSize:(CGSize)size {
    _size = size;
    _frame = (CGRect){_frame.origin, _size};
}

- (void)setCenter:(CGPoint)center {
    _center = center;
    _frame = (CGRect){{_center.x - _frame.size.width / 2, _center.y - _frame.size.height / 2}, _frame.size};
}

- (void)setFrame:(CGRect)frame {
    _frame = frame;
    _size = _frame.size;
    _center = (CGPoint){CGRectGetMidX(_frame), CGRectGetMidY(_frame)};
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    UICollectionViewLayoutAttributes *layoutAttributes = [self.class new];
    layoutAttributes.indexPath = self.indexPath;
    layoutAttributes.elementKind = self.elementKind;
    layoutAttributes.elementCategory = self.elementCategory;
    layoutAttributes.frame = self.frame;
    layoutAttributes.center = self.center;
    layoutAttributes.size = self.size;
    layoutAttributes.transform3D = self.transform3D;
    layoutAttributes.alpha = self.alpha;
    layoutAttributes.zIndex = self.zIndex;
    layoutAttributes.hidden = self.isHidden;
    return layoutAttributes;
}

@end


@implementation UICollectionViewLayout
///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if((self = [super init])) {
        _decorationViewClassDict = [NSMutableDictionary new];
        _decorationViewExternalObjectsTables = [NSMutableDictionary new];
        _initialAnimationLayoutAttributesDict = [NSMutableDictionary new];
        _finalAnimationLayoutAttributesDict = [NSMutableDictionary new];
        _insertedSectionsSet = [NSMutableIndexSet new];
        _deletedSectionsSet = [NSMutableIndexSet new];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setCollectionView:(UICollectionView *)collectionView {
    if(collectionView != _collectionView) {
        _collectionView = collectionView;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Invalidating the Layout

- (void)invalidateLayout {
    [[_collectionView collectionViewData] invalidate];
    [_collectionView setNeedsLayout];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    // not sure about his..
    if((self.collectionView.bounds.size.width != newBounds.size.width) || (self.collectionView.bounds.size.height != newBounds.size.height)) {
        return YES;
    }
    return NO;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Providing Layout Attributes

+ (Class)layoutAttributesClass {
    return UICollectionViewLayoutAttributes.class;
}

- (void)prepareLayout {
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

// return a point at which to rest after scrolling - for layouts that want snap-to-point scrolling behavior
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    return proposedContentOffset;
}

- (CGSize)collectionViewContentSize {
    return CGSizeZero;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Responding to Collection View Updates

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
    NSDictionary *update = [_collectionView currentUpdate];
    
    for (UICollectionReusableView *view in [[_collectionView visibleViewsDict] objectEnumerator]) {
        UICollectionViewLayoutAttributes *attr = [view.layoutAttributes copy];
        if(attr) {
            if(attr.isCell) {
                NSInteger index = [update[@"oldModel"] globalIndexForItemAtIndexPath:[attr indexPath]];
                if(index != NSNotFound) {
                    [attr setIndexPath:[attr indexPath]];
                }
            }
            _initialAnimationLayoutAttributesDict[[UICollectionViewItemKey collectionItemKeyForLayoutAttributes:attr]] = attr;
        }
    }
    
    UICollectionViewData *collectionViewData = [_collectionView collectionViewData];
    
    CGRect bounds = [_collectionView visibleBoundRects];
    
    for (UICollectionViewLayoutAttributes *attr in [collectionViewData layoutAttributesForElementsInRect:bounds]) {
        if(attr.isCell) {
            NSInteger index = [collectionViewData globalIndexForItemAtIndexPath:attr.indexPath];
            
            index = [update[@"newToOldIndexMap"][index] intValue];
            if(index != NSNotFound) {
                UICollectionViewLayoutAttributes *finalAttrs = [attr copy];
                [finalAttrs setIndexPath:[update[@"oldModel"] indexPathForItemAtGlobalIndex:index]];
                [finalAttrs setAlpha:0];
                _finalAnimationLayoutAttributesDict[[UICollectionViewItemKey collectionItemKeyForLayoutAttributes:finalAttrs]] = finalAttrs;
            }
        }
    }
    
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        UICollectionUpdateAction action = updateItem.updateAction;
        
        if([updateItem isSectionOperation]) {
            if(action == UICollectionUpdateActionReload) {
                [_deletedSectionsSet addIndex:[[updateItem indexPathBeforeUpdate] section]];
                [_insertedSectionsSet addIndex:[updateItem indexPathAfterUpdate].section];
            }
            else {
                NSMutableIndexSet *indexSet = action == UICollectionUpdateActionInsert ? _insertedSectionsSet : _deletedSectionsSet;
                [indexSet addIndex:[updateItem indexPath].section];
            }
        }
        else {
            if(action == UICollectionUpdateActionDelete) {
                UICollectionViewItemKey *key = [UICollectionViewItemKey collectionItemKeyForCellWithIndexPath:
                                                [updateItem indexPathBeforeUpdate]];
                
                UICollectionViewLayoutAttributes *attrs = [_finalAnimationLayoutAttributesDict[key] copy];
                
                if(attrs) {
                    [attrs setAlpha:0];
                    _finalAnimationLayoutAttributesDict[key] = attrs;
                }
            }
            else if(action == UICollectionUpdateActionReload || action == UICollectionUpdateActionInsert) {
                UICollectionViewItemKey *key = [UICollectionViewItemKey collectionItemKeyForCellWithIndexPath:
                                                [updateItem indexPathAfterUpdate]];
                UICollectionViewLayoutAttributes *attrs = [_initialAnimationLayoutAttributesDict[key] copy];
                
                if(attrs) {
                    [attrs setAlpha:0];
                    _initialAnimationLayoutAttributesDict[key] = attrs;
                }
            }
        }
    }
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attrs = _initialAnimationLayoutAttributesDict[[UICollectionViewItemKey collectionItemKeyForCellWithIndexPath:itemIndexPath]];
    
    if([_insertedSectionsSet containsIndex:[itemIndexPath section]]) {
        attrs = [attrs copy];
        [attrs setAlpha:0];
    }
    return attrs;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attrs = _finalAnimationLayoutAttributesDict[[UICollectionViewItemKey collectionItemKeyForCellWithIndexPath:itemIndexPath]];
    
    if([_deletedSectionsSet containsIndex:[itemIndexPath section]]) {
        attrs = [attrs copy];
        [attrs setAlpha:0];
    }
    return attrs;
    
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForInsertedSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
    UICollectionViewLayoutAttributes *attrs = _initialAnimationLayoutAttributesDict[[UICollectionViewItemKey collectionItemKeyForCellWithIndexPath:elementIndexPath]];
    
    if([_insertedSectionsSet containsIndex:[elementIndexPath section]]) {
        attrs = [attrs copy];
        [attrs setAlpha:0];
    }
    return attrs;
    
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDeletedSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
    return nil;
}

- (void)finalizeCollectionViewUpdates {
    [_initialAnimationLayoutAttributesDict removeAllObjects];
    [_finalAnimationLayoutAttributesDict removeAllObjects];
    [_deletedSectionsSet removeAllIndexes];
    [_insertedSectionsSet removeAllIndexes];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Registering Decoration Views

- (void)registerClass:(Class)viewClass forDecorationViewOfKind:(NSString *)kind {
    _decorationViewClassDict[kind] = viewClass;
}

- (void)registerNib:(UINib *)nib forDecorationViewOfKind:(NSString *)kind {
    UIKitUnimplementedMethod();
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)setCollectionViewBoundsSize:(CGSize)size {
    _collectionViewBoundsSize = size;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)coder {
    if((self = [self init])) {
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {}

@end
