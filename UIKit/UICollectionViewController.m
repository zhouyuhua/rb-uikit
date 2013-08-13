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

#import "UICollectionViewController.h"
#import "UICollectionView.h"

#import "UIScreen.h"

@interface UICollectionViewController () {
    UICollectionViewLayout *_layout;
    UICollectionView *_collectionView;
    struct {
        unsigned int clearsSelectionOnViewWillAppear : 1;
        unsigned int appearsFirstTime : 1; // UI exension!
    }_collectionViewControllerFlags;
}
@property (nonatomic, strong) UICollectionViewLayout *layout;
@end

@implementation UICollectionViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if(self) {
        self.layout = [UICollectionViewFlowLayout new];
        self.clearsSelectionOnViewWillAppear = YES;
        _collectionViewControllerFlags.appearsFirstTime = YES;
    }
    return self;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    if((self = [super init])) {
        self.layout = layout;
        self.clearsSelectionOnViewWillAppear = YES;
        _collectionViewControllerFlags.appearsFirstTime = YES;
    }
    return self;
}

- (id)init
{
    return [self initWithCollectionViewLayout:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (void)loadView {
    [super loadView];
    
    if(_collectionView.delegate == nil) _collectionView.delegate = self;
    if(_collectionView.dataSource == nil) _collectionView.dataSource = self;
    
    // only create the collection view if it is not already created (by IB)
    if(!_collectionView) {
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // This seems like a hack, but is needed for real compatibility
    // There can be implementations of loadView that don't call super and don't set the view, yet it works in UICollectionViewController.
    if(![self isViewLoaded]) {
        self.view = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    // Attach the view
    if(self.view != self.collectionView) {
        [self.view addSubview:self.collectionView];
        self.collectionView.frame = self.view.bounds;
        self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(_collectionViewControllerFlags.appearsFirstTime) {
        [_collectionView reloadData];
        _collectionViewControllerFlags.appearsFirstTime = NO;
    }
    
    if(_collectionViewControllerFlags.clearsSelectionOnViewWillAppear) {
        for (NSIndexPath *aIndexPath in [[_collectionView indexPathsForSelectedItems] copy]) {
            [_collectionView deselectItemAtIndexPath:aIndexPath animated:animated];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Lazy load the collection view

- (UICollectionView *)collectionView {
    if(!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        // If the collection view isn't the main view, add it.
        if(self.isViewLoaded && self.view != self.collectionView) {
            [self.view addSubview:self.collectionView];
            self.collectionView.frame = self.view.bounds;
            self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        }
    }
    return _collectionView;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Properties

- (void)setClearsSelectionOnViewWillAppear:(BOOL)clearsSelectionOnViewWillAppear {
    _collectionViewControllerFlags.clearsSelectionOnViewWillAppear = clearsSelectionOnViewWillAppear;
}

- (BOOL)clearsSelectionOnViewWillAppear {
    return _collectionViewControllerFlags.clearsSelectionOnViewWillAppear;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
