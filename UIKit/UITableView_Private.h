//
//  UITableView_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/13/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UITableView.h"

@interface UITableView () {
    NSMutableDictionary *_registeredCellClasses;
    NSMutableDictionary *_registeredHeaderFooterClasses;
    
    NSMutableDictionary *_reusableCells;
}

#pragma mark - readwrite

@property (nonatomic, readwrite) UITableViewStyle style;

@end
