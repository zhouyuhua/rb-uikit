//
//  UIAppearanceProperty.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/5/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

///The UIAppearanceProperty class encapsulates information on a property
///that is supported by the UIConcreteAppearance class.
///
///Property information includes setter and getter selectors and type encodings.
///
///Properties also encapsulate axis-value application, managed by an owning
///UIConcreteAppearance class instance.
@interface UIAppearanceProperty : NSObject

///Initialize the receiver with a given setter method.
///
/// \param  method  The setter method. Required.
///
/// \result A fully initialized property object.
///
///This is the designated initializer.
- (instancetype)initWithSetterMethod:(Method)method;

#pragma mark - Properties

///The getter selector of the property.
///
///Calculated based off of the setter selector.
@property (nonatomic) SEL getterSelector;

///The getter's type encoding.
///
///Calculated based off of the setter type encoding.
@property (nonatomic, copy) NSString *getterTypeEncoding;

#pragma mark -

///The setter selector of the property.
@property (nonatomic) SEL setterSelector;

///The setter type encoding of the property.
@property (nonatomic, copy) NSString *setterTypeEncoding;

#pragma mark - Application

///Apply the property to a given instance with a given value and axis values.
///
/// \param  instance    The instance to apply the property to.
/// \param  value       The value. Required.
/// \param  axisValues  The axis values. Required.
///
- (void)applyToInstance:(id)instance withValue:(NSValue *)value axisValues:(NSArray *)axisValues;

@end
