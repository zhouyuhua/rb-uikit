//
//  UICollectionViewUpdateItem_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/13/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UICollectionViewUpdateItem.h"

@interface UICollectionViewUpdateItem () {
    NSIndexPath *_initialIndexPath;
    NSIndexPath *_finalIndexPath;
    UICollectionUpdateAction _updateAction;
    id _gap;
}

- (NSIndexPath *)indexPath;

- (BOOL)isSectionOperation;

@end
