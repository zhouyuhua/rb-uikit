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

#import "UICollectionViewItemKey.h"

NSString *const UICollectionElementKindCell = @"UICollectionElementKindCell";

@implementation UICollectionViewItemKey

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Static

+ (id)collectionItemKeyForCellWithIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewItemKey *key = [self.class new];
    key.indexPath = indexPath;
    key.type = UICollectionViewItemTypeCell;
    key.identifier = UICollectionElementKindCell;
    return key;
}

+ (id)collectionItemKeyForLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    UICollectionViewItemKey *key = [self.class new];
    key.indexPath = layoutAttributes.indexPath;
    UICollectionViewItemType const itemType = layoutAttributes.representedElementCategory;
    key.type = itemType;
    key.identifier = layoutAttributes.representedElementKind;
    return key;
}

NSString *UICollectionViewItemTypeToString(UICollectionViewItemType type) {
    switch (type) {
        case UICollectionViewItemTypeCell: return @"Cell";
        case UICollectionViewItemTypeDecorationView: return @"Decoration";
        case UICollectionViewItemTypeSupplementaryView: return @"Supplementary";
        default: return @"<INVALID>";
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p Type = %@ Identifier=%@ IndexPath = %@>", NSStringFromClass(self.class),
            self, UICollectionViewItemTypeToString(self.type), _identifier, self.indexPath];
}

- (NSUInteger)hash {
    return (([_indexPath hash] + _type) * 31) + [_identifier hash];
}

- (BOOL)isEqual:(id)other {
    if([other isKindOfClass:self.class]) {
        UICollectionViewItemKey *otherKeyItem = (UICollectionViewItemKey *)other;
        // identifier might be nil?
        if(_type == otherKeyItem.type && [_indexPath isEqual:otherKeyItem.indexPath] && ([_identifier isEqualToString:otherKeyItem.identifier] || _identifier == otherKeyItem.identifier)) {
            return YES;
        }
    }
    return NO;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    UICollectionViewItemKey *itemKey = [self.class new];
    itemKey.indexPath = self.indexPath;
    itemKey.type = self.type;
    itemKey.identifier = self.identifier;
    return itemKey;
}

@end
