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
        
        int tableViewTitleForHeaderInSection : 1;
        int tableViewTitleForFooterInSection : 1;
        
        int tableViewCommitEditingStyleForRowAtIndexPath : 1;
        int tableViewCanEditRowAtIndexPath : 1;
        
        int tableViewCanMoveRowAtIndexPath : 1;
        int tableViewMoveRowAtIndexPathToIndexPath : 1;
    } _dataSourceRespondsTo;
    
    struct {
        int tableViewHeightForRowAtIndexPath : 1;
        int tableViewHeightForHeaderInSection : 1;
        int tableViewHeightForFooterInSection : 1;
        
        int tableViewViewForHeaderInSection : 1;
        int tableViewViewForFooterInSection : 1;
        
        int tableViewWillDisplayCellForRowAtIndexPath : 1;
        int tableViewDidEndDisplayingCellForRowAtIndexPath : 1;
        int tableViewDidEndDisplayingHeaderViewForSection : 1;
        int tableViewDidEndDisplayingFooterViewForSection : 1;
        
        int tableViewWillSelectRowAtIndexPath : 1;
        int tableViewDidSelectRowAtIndexPath : 1;
        
        int tableViewWillDeselectRowAtIndexPath : 1;
        int tableViewDidDeselectRowAtIndexPath : 1;
        
        int tableViewEditingStyleForRowAtIndexPath : 1;
    } _delegateRespondsTo;
    
    NSMutableDictionary *_registeredCellClasses;
    NSMutableDictionary *_registeredHeaderFooterClasses;
    
    NSMutableDictionary *_reusableCells;
    NSMutableDictionary *_cachedCells;
    
    NSMutableArray *_sections;
    NSMutableArray *_allCells;
    
    NSMutableOrderedSet *_highlightedIndexPaths;
    NSMutableOrderedSet *_selectedIndexPaths;
    
    NSMutableArray *_updateStack;
    
    BOOL _needsReload;
    BOOL _editing;
}

#pragma mark - readwrite

@property (nonatomic, readwrite) UITableViewStyle style;

@end
