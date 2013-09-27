//
//  UIPasteboard_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/10/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIPasteboard.h"

@interface UIPasteboard ()

- (instancetype)initWithNativePasteboard:(NSPasteboard *)pasteboard;

@property (nonatomic) NSPasteboard *_nativePasteboard;

@end
