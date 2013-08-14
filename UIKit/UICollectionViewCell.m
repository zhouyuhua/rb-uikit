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

#import "UICollectionView_Internal.h"
#import "UICollectionViewCell_Private.h"

#import "UILongPressGestureRecognizer.h"
#import "UIPanGestureRecognizer.h"

#import "UIControl.h"

@implementation UICollectionReusableView

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if((self = [super initWithCoder:aDecoder])) {
        self.reuseIdentifier = [aDecoder decodeObjectForKey:@"UIReuseIdentifier"];
    }
    return self;
}

- (void)awakeFromNib {
    self.reuseIdentifier = [self valueForKeyPath:@"reuseIdentifier"];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)prepareForReuse {
    self.layoutAttributes = nil;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    if(layoutAttributes != _layoutAttributes) {
        _layoutAttributes = layoutAttributes;
        
        self.bounds = (CGRect){.origin = self.bounds.origin, .size = layoutAttributes.size};
        self.center = layoutAttributes.center;
        self.hidden = layoutAttributes.hidden;
        self.layer.transform = layoutAttributes.transform3D;
        self.layer.zPosition = layoutAttributes.zIndex;
        self.layer.opacity = layoutAttributes.alpha;
    }
}

- (void)willTransitionFromLayout:(UICollectionViewLayout *)oldLayout toLayout:(UICollectionViewLayout *)newLayout {
    _reusableViewFlags.inUpdateAnimation = YES;
}

- (void)didTransitionFromLayout:(UICollectionViewLayout *)oldLayout toLayout:(UICollectionViewLayout *)newLayout {
    _reusableViewFlags.inUpdateAnimation = NO;
}

- (BOOL)isInUpdateAnimation {
    return _reusableViewFlags.inUpdateAnimation;
}

- (void)setInUpdateAnimation:(BOOL)inUpdateAnimation {
    _reusableViewFlags.inUpdateAnimation = inUpdateAnimation;
}

@end


@implementation UICollectionViewCell {
    UIView *_contentView;
    UIView *_backgroundView;
    UIView *_selectedBackgroundView;
    UILongPressGestureRecognizer *_menuGesture;
    id _selectionSegueTemplate;
    id _highlightingSupport;
    struct {
        unsigned int selected : 1;
        unsigned int highlighted : 1;
        unsigned int showingMenu : 1;
        unsigned int clearSelectionWhenMenuDisappears : 1;
        unsigned int waitingForSelectionAnimationHalfwayPoint : 1;
    }_collectionCellFlags;
    BOOL _selected;
    BOOL _highlighted;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_backgroundView];
        
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_contentView];
        
        _menuGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(menuGesture:)];
        [self addGestureRecognizer:_menuGesture];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    UIKitUnimplementedMethod();
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)prepareForReuse {
    self.layoutAttributes = nil;
    self.selected = NO;
    self.highlighted = NO;
}

// Selection highlights underlying contents
- (void)setSelected:(BOOL)selected {
    _collectionCellFlags.selected = selected;
    [self updateBackgroundView:selected];
}

// Cell highlighting only highlights the cell itself
- (void)setHighlighted:(BOOL)highlighted {
    _collectionCellFlags.highlighted = highlighted;
    [self updateBackgroundView:highlighted];
}

- (void)updateBackgroundView:(BOOL)highlight {
    _selectedBackgroundView.alpha = highlight ? 1.0f : 0.0f;
    [self setHighlighted:highlight forViews:self.contentView.subviews];
}

- (void)setHighlighted:(BOOL)highlighted forViews:(id)subviews {
    for (id view in subviews) {
        // Ignore the events if view wants to
        if(!((UIView *)view).isUserInteractionEnabled &&
           [view respondsToSelector:@selector(setHighlighted:)] &&
           ![view isKindOfClass:UIControl.class]) {
            [view setHighlighted:highlighted];
            
            [self setHighlighted:highlighted forViews:[view subviews]];
        }
    }
}

- (void)menuGesture:(UILongPressGestureRecognizer *)recognizer {
    [self.collectionView showMenuForCell:self];
}

- (void)setBackgroundView:(UIView *)backgroundView {
    if(_backgroundView != backgroundView) {
        [_backgroundView removeFromSuperview];
        _backgroundView = backgroundView;
        _backgroundView.frame = self.bounds;
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self insertSubview:_backgroundView atIndex:0];
    }
}

- (void)setSelectedBackgroundView:(UIView *)selectedBackgroundView {
    if(_selectedBackgroundView != selectedBackgroundView) {
        [_selectedBackgroundView removeFromSuperview];
        _selectedBackgroundView = selectedBackgroundView;
        _selectedBackgroundView.frame = self.bounds;
        _selectedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _selectedBackgroundView.alpha = self.selected ? 1.0f : 0.0f;
        if(_backgroundView) {
            [self insertSubview:_selectedBackgroundView aboveSubview:_backgroundView];
        }
        else {
            [self insertSubview:_selectedBackgroundView atIndex:0];
        }
    }
}

- (BOOL)isSelected {
    return _collectionCellFlags.selected;
}

- (BOOL)isHighlighted {
    return _collectionCellFlags.highlighted;
}

@end
