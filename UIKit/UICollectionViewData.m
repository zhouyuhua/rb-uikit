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

#import "UICollectionViewData.h"
#import "UICollectionView.h"
#import "NSIndexPath+UICollectionViewAdditions.h"

@interface UICollectionViewData () {
    CGRect _validLayoutRect;
    
    NSInteger _numItems;
    NSInteger _numSections;
    NSInteger *_sectionItemCounts;
    //    id __strong* _globalItems; ///< _globalItems appears to be cached layoutAttributes. But adding that work in opens a can of worms, so deferring until later.
    
    /*
     // At this point, I've no idea how _screenPageDict is structured. Looks like some optimization for layoutAttributesForElementsInRect.
     And why UICGPointKey? Isn't that doable with NSValue?
     
     "<UICGPointKey: 0x11432d40>" = "<NSMutableIndexSet: 0x11432c60>[number of indexes: 9 (in 1 ranges), indexes: (0-8)]";
     "<UICGPointKey: 0xb94bf60>" = "<NSMutableIndexSet: 0x18dea7e0>[number of indexes: 11 (in 2 ranges), indexes: (6-15 17)]";
     
     (lldb) p (CGPoint)[[[[[collectionView valueForKey:@"_collectionViewData"] valueForKey:@"_screenPageDict"] allKeys] objectAtIndex:0] point]
     (CGPoint) $11 = (x=15, y=159)
     (lldb) p (CGPoint)[[[[[collectionView valueForKey:@"_collectionViewData"] valueForKey:@"_screenPageDict"] allKeys] objectAtIndex:1] point]
     (CGPoint) $12 = (x=15, y=1128)
     
     // https://github.com/steipete/iOS6-Runtime-Headers/blob/master/UICGPointKey.h
     
     NSMutableDictionary *_screenPageDict;
     */
    
    // @steipete
    
    CGSize _contentSize;
    struct {
        unsigned int contentSizeIsValid:1;
        unsigned int itemCountsAreValid:1;
        unsigned int layoutIsPrepared:1;
    }_collectionViewDataFlags;
}
@property (nonatomic, unsafe_unretained) UICollectionView *collectionView;
@property (nonatomic, unsafe_unretained) UICollectionViewLayout *layout;
@property (nonatomic, strong) NSArray *cachedLayoutAttributes;

@end

@implementation UICollectionViewData

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout {
    if((self = [super init])) {
        _collectionView = collectionView;
        _layout = layout;
    }
    return self;
}

- (void)dealloc {
    free(_sectionItemCounts);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p numItems:%ld numSections:%ld>", NSStringFromClass(self.class), self, (long)self.numberOfItems, (long)self.numberOfSections];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)invalidate {
    _collectionViewDataFlags.itemCountsAreValid = NO;
    _collectionViewDataFlags.layoutIsPrepared = NO;
    _validLayoutRect = CGRectNull;  // don't set CGRectZero in case of _contentSize=CGSizeZero
}

- (CGRect)collectionViewContentRect {
    return (CGRect){.size=_contentSize};
}

- (void)validateLayoutInRect:(CGRect)rect {
    [self validateItemCounts];
    [self _prepareToLoadData];
    
    // TODO: check if we need to fetch data from layout
    if(!CGRectEqualToRect(_validLayoutRect, rect)) {
        _validLayoutRect = rect;
        // we only want cell layoutAttributes & supplementaryView layoutAttributes
        self.cachedLayoutAttributes = [[self.layout layoutAttributesForElementsInRect:rect] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
            return ([evaluatedObject isKindOfClass:UICollectionViewLayoutAttributes.class] &&
                    ([evaluatedObject isCell] ||
                     [evaluatedObject isSupplementaryView] ||
                     [evaluatedObject isDecorationView]));
        }]];
    }
}

- (NSInteger)numberOfItems {
    [self validateItemCounts];
    return _numItems;
}

- (NSInteger)numberOfItemsBeforeSection:(NSInteger)section {
    [self validateItemCounts];
    
    NSAssert(section < _numSections, @"request for number of items in section %ld when there are only %ld sections in the collection view", (long)section, _numSections);
    
    NSInteger returnCount = 0;
    for (int i = 0; i < section; i++) {
        returnCount += _sectionItemCounts[i];
    }
    
    return returnCount;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    [self validateItemCounts];
    if(section >= _numSections || section < 0) {
        // In case of inconsistency returns the 'less harmful' amount of items. Throwing an exception here potentially
        // causes exceptions when data is consistent. Deleting sections is one of the parts sensitive to this.
        // All checks via assertions are done on CollectionView animation methods, specially 'endAnimations'.
        return 0;
        //@throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Section %d out of range: 0...%d", section, _numSections] userInfo:nil];
    }
    
    NSInteger numberOfItemsInSection = 0;
    if(_sectionItemCounts) {
        numberOfItemsInSection = _sectionItemCounts[section];
    }
    return numberOfItemsInSection;
}

- (NSInteger)numberOfSections {
    [self validateItemCounts];
    return _numSections;
}

- (CGRect)rectForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectZero;
}

- (NSIndexPath *)indexPathForItemAtGlobalIndex:(NSInteger)index {
    [self validateItemCounts];
    
    NSAssert(index < _numItems, @"request for index path for global index %ld when there are only %ld items in the collection view", (long)index, (long)_numItems);
    
    NSInteger section = 0;
    NSInteger countItems = 0;
    for (section = 0; section < _numSections; section++) {
        NSInteger countIncludingThisSection = countItems + _sectionItemCounts[section];
        if(countIncludingThisSection > index) break;
        countItems = countIncludingThisSection;
    }
    
    NSInteger item = index - countItems;
    
    return [NSIndexPath indexPathForItem:item inSection:section];
}

- (NSUInteger)globalIndexForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger offset = [self numberOfItemsBeforeSection:indexPath.section] + indexPath.item;
    return (NSUInteger)offset;
}

- (BOOL)layoutIsPrepared {
    return _collectionViewDataFlags.layoutIsPrepared;
}

- (void)setLayoutIsPrepared:(BOOL)layoutIsPrepared {
    _collectionViewDataFlags.layoutIsPrepared = layoutIsPrepared;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Fetch Layout Attributes

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    [self validateLayoutInRect:rect];
    return self.cachedLayoutAttributes;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

// ensure item count is valid and loaded
- (void)validateItemCounts {
    if(!_collectionViewDataFlags.itemCountsAreValid) {
        [self updateItemCounts];
    }
}

// query dataSource for new data
- (void)updateItemCounts {
    // query how many sections there will be
    _numSections = 1;
    if([self.collectionView.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        _numSections = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    }
    if(_numSections <= 0) { // early bail-out
        _numItems = 0;
        free(_sectionItemCounts);
        _sectionItemCounts = 0;
        _collectionViewDataFlags.itemCountsAreValid = YES;
        return;
    }
    // allocate space
    if(!_sectionItemCounts) {
        _sectionItemCounts = malloc(_numSections * sizeof(NSInteger));
    } else {
        _sectionItemCounts = realloc(_sectionItemCounts, _numSections * sizeof(NSInteger));
    }
    
    // query cells per section
    _numItems = 0;
    for (NSInteger i = 0; i < _numSections; i++) {
        NSInteger cellCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:i];
        _sectionItemCounts[i] = cellCount;
        _numItems += cellCount;
    }
    
    _collectionViewDataFlags.itemCountsAreValid = YES;
}

- (void)_prepareToLoadData {
    if(!self.layoutIsPrepared) {
        [self.layout prepareLayout];
        _contentSize = self.layout.collectionViewContentSize;
        self.layoutIsPrepared = YES;
    }
}

@end
