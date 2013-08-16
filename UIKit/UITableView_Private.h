//
//  UITableView_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/13/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UITableView.h"

@interface UITableView () {
    struct {
        int numberOfSectionsInTableView : 1;
    } _dataSourceRespondsTo;
    
    struct {
        int tableViewHeightForRowAtIndexPath : 1;
        int tableViewHeightForHeaderInSection : 1;
        int tableViewHeightForFooterInSection : 1;
        
        int tableViewViewForHeaderInSection : 1;
        int tableViewViewForFooterInSection : 1;
        
        int tableViewWillDisplayCellForRowAtIndexPath : 1;
        int tableViewDidEndDisplayingCellForRowAtIndexPath : 1;
        
        int tableViewDidSelectRowAtIndexPath : 1;
        int tableViewDidDeselectRowAtIndexPath : 1;
    } _delegateRespondsTo;
    
    NSMutableDictionary *_registeredCellClasses;
    NSMutableDictionary *_registeredHeaderFooterClasses;
    
    NSMutableDictionary *_reusableCells;
    NSMutableDictionary *_cachedCells;
    
    NSMutableArray *_sections;
    NSMutableArray *_allCells;
    
    NSIndexPath *_selectedIndexPath;
    
    BOOL _needsReload;
}

#pragma mark - readwrite

@property (nonatomic, readwrite) UITableViewStyle style;

@end
