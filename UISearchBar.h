//
//  UISearchBar.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"
#import "UIAppearance.h"
#import "UIBarCommon.h"
#import "UITextInputTraits.h"
#import "UIControl.h"

@protocol UISearchBarDelegate;

typedef NS_ENUM(NSInteger, UISearchBarIcon) {
    UISearchBarIconSearch,
    UISearchBarIconClear,
    UISearchBarIconBookmark,
    UISearchBarIconResultsList,
};

@interface UISearchBar : UIView <UITextInputTraits>

@property (nonatomic) UIBarStyle barStyle;
@property (nonatomic, assign) id <UISearchBarDelegate> delegate;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *prompt;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic) BOOL showsBookmarkButton;
@property (nonatomic) BOOL showsCancelButton;
@property (nonatomic) BOOL showsSearchResultsButton;
@property (nonatomic, getter=isSearchResultsButtonSelected) BOOL searchResultsButtonSelected;
- (void)setShowsCancelButton:(BOOL)showsCancelButton animated:(BOOL)animated;

@property (nonatomic, retain) UIColor *tintColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign, getter=isTranslucent) BOOL translucent;

@property (nonatomic, readwrite, retain) UIView *inputAccessoryView;

@property (nonatomic, retain) UIImage *backgroundImage UI_APPEARANCE_SELECTOR;
@property (nonatomic, retain) UIImage *scopeBarBackgroundImage UI_APPEARANCE_SELECTOR;

- (void)setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics;
- (UIImage *)backgroundImageForBarMetrics:(UIBarMetrics)barMetrics;

- (void)setSearchFieldBackgroundImage:(UIImage *)backgroundImage forState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (UIImage *)searchFieldBackgroundImageForState:(UIControlState)state UI_APPEARANCE_SELECTOR;

- (void)setImage:(UIImage *)iconImage forSearchBarIcon:(UISearchBarIcon)icon state:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (UIImage *)imageForSearchBarIcon:(UISearchBarIcon)icon state:(UIControlState)state UI_APPEARANCE_SELECTOR;

- (void)setScopeBarButtonBackgroundImage:(UIImage *)backgroundImage forState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (UIImage *)scopeBarButtonBackgroundImageForState:(UIControlState)state UI_APPEARANCE_SELECTOR;

- (void)setScopeBarButtonDividerImage:(UIImage *)dividerImage forLeftSegmentState:(UIControlState)leftState rightSegmentState:(UIControlState)rightState UI_APPEARANCE_SELECTOR;
- (UIImage *)scopeBarButtonDividerImageForLeftSegmentState:(UIControlState)leftState rightSegmentState:(UIControlState)rightState UI_APPEARANCE_SELECTOR;

- (void)setScopeBarButtonTitleTextAttributes:(NSDictionary *)attributes forState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (NSDictionary *)scopeBarButtonTitleTextAttributesForState:(UIControlState)state UI_APPEARANCE_SELECTOR;

@property(nonatomic) UIOffset searchFieldBackgroundPositionAdjustment UI_APPEARANCE_SELECTOR;

@property(nonatomic) UIOffset searchTextPositionAdjustment UI_APPEARANCE_SELECTOR;

- (void)setPositionAdjustment:(UIOffset)adjustment forSearchBarIcon:(UISearchBarIcon)icon UI_APPEARANCE_SELECTOR;
- (UIOffset)positionAdjustmentForSearchBarIcon:(UISearchBarIcon)icon UI_APPEARANCE_SELECTOR;

@end

#pragma mark -

@protocol UISearchBarDelegate <NSObject>

@optional

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar;
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar;
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar;
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar;

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope;

@end
