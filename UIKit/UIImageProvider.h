//
//  UIImageProvider.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/20/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImageProvider : NSObject <NSCopying>

- (instancetype)initWithContentsOfFile:(NSString *)file scale:(CGFloat)scale;
- (instancetype)initWithData:(NSData *)data scale:(CGFloat)scale;
- (instancetype)initWithCGImage:(CGImageRef)image scale:(CGFloat)scale;

- (CGImageRef)image NS_RETURNS_INNER_POINTER;

- (CGSize)imageSize;
- (CGFloat)scale;

- (BOOL)isOpaque;

- (void)drawInRect:(CGRect)destinationRect fromRect:(CGRect)fromRect tile:(BOOL)tile;

@end
