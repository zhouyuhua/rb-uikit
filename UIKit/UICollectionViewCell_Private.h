//
//  UICollectionViewCell_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/13/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UICollectionViewCell.h"

@interface UICollectionReusableView () {
    UICollectionViewLayoutAttributes *_layoutAttributes;
    NSString *_reuseIdentifier;
    __unsafe_unretained UICollectionView *_collectionView;
    struct {
        unsigned int inUpdateAnimation : 1;
    }_reusableViewFlags;
}
@property (nonatomic, copy) NSString *reuseIdentifier;
@property (nonatomic, unsafe_unretained) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewLayoutAttributes *layoutAttributes;
@end
