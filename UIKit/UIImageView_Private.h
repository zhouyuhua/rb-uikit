//
//  UIImageView_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIImageView.h"

@interface UIImageView () {
    UIImage *_displayedImage;
    BOOL _manuallyDrawingImage;
}

@property (nonatomic) BOOL _prefersToRenderTemplateImages;

@end
