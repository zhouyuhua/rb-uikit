//
//  UIConcreteAppearance.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/5/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIAppearance.h"

///The UIConcreteAppearance class implements the UIAppearance proxy for RB-UIKit.
///
///##Important:
///
///UIConcreteAppearance reserves all methods beginning with _ for itself,
///and will not proxy for _ methods in appearance-supporting classes.
@interface UIConcreteAppearance : NSObject

///Returns the appearance for a given class when contained in a given path.
///
/// \param  class               The class to return the appearance for. Required.
/// \param  ContainerClass...   A nil-terminated UIAppearanceContainer path.
///
/// \result The appearance appropriate for the given parameters.
///
///A separate appearance instance is created for each container class path.
+ (id)appearanceForClass:(Class)class containedIn:(Class <UIAppearanceContainer>)ContainerClass, ...;

/// \seealso(+[self appearanceForClass:containedIn:])
+ (id)appearanceForClass:(Class)class containedIn:(Class <UIAppearanceContainer>)ContainerClass arguments:(va_list)arguments;

@end

///Applies a concrete appearance to a given instance.
///
/// \param  appearance  The concrete appearance to apply.
/// \param  instance    The instance to apply the appearance to. Required.
///
///This function performs a runtime type check on the appearance, and will safely
///do nothing if the appearance is a custom user-provided class.
UIKIT_EXTERN void UIConcreteAppearanceApply(UIConcreteAppearance *appearance, id instance);

///Returns a BOOL indicating whether or not an appearance has a value for a given setter selector.
///
///This function performs a runtime type check on the appearance, and will safely
///do nothing if the appearance is a custom user-provided class.
UIKIT_EXTERN BOOL UIConcreteAppearanceHasValueFor(UIConcreteAppearance *appearance, SEL getterSelector);

///Returns the concrete appearance for a given instance,
///taking into account the container path of the instance.
///
///This function should always be used to access the appearance
///of an instance of a UIAppearance-supporting class.
UIKIT_EXTERN UIConcreteAppearance *UIConcreteAppearanceForInstance(id instance);

///Generate the default +appearance... methods for the current class.
#define UI_CONCRETE_APPEARANCE_GENERATE(_Class) + (instancetype)appearance \
{ \
    return [self appearanceWhenContainedIn:nil]; \
} \
+ (instancetype)appearanceWhenContainedIn:(Class<UIAppearanceContainer>)ContainerClass, ... \
{ \
    va_list args; \
    va_start(args, ContainerClass); \
    id appearance = [UIConcreteAppearance appearanceForClass:self containedIn:ContainerClass arguments:args]; \
    va_end(args); \
    return appearance; \
}
