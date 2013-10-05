//
//  UIRetainingNSValue.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/5/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

///The UIRetainingNSValue class extends NSValue to retain objects given to it.
@interface UIRetainingNSValue : NSValue

/*
 NSValue is a secret class cluster. Only the following methods
 have been overriden and wrapped. Do not use any others.
 */

+ (NSValue *)valueWithBytes:(const void *)value objCType:(const char *)type;
- (const char *)objCType;
- (void)getValue:(void *)value;

#pragma mark - Contents

///Returns YES if the receiver's contents can be considered nil, NO otherwise.
- (BOOL)isNil;

@end
