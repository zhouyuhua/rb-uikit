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

#import "UICollectionViewCommon.h"
#import "UIViewController.h"

@class UICollectionViewLayout, UICollectionViewController;

/// Simple controller-wrapper around UICollectionView.
@interface UICollectionViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

/// Designated initializer.
- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout;

/// Internally used collection view. If not set, created during loadView.
@property (nonatomic, strong) UICollectionView *collectionView;

/// Defaults to YES, and if YES, any selection is cleared in viewWillAppear:
@property (nonatomic, assign) BOOL clearsSelectionOnViewWillAppear;

@end
