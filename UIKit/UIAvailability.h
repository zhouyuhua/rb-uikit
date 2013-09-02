//
//  UIAvailability.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#ifndef UIKit_UIAvailability_h
#define UIKit_UIAvailability_h

///Indicates whether or not deprecation warnings should be included.
#define UIAvailabilityIncludeDeprecationWarnings    1

#pragma mark -

#if UIAvailabilityIncludeDeprecationWarnings

/* Do not use these directly */
#   define UI_DEPRECATED_SINCE_6_0(...)         __attribute__((deprecated("Deprecated since iOS 6. " __VA_ARGS__)))
#   define UI_DEPRECATED_SINCE_7_0(...)         __attribute__((deprecated("Deprecated since iOS 7. " __VA_ARGS__)))

#pragma mark -

///Marks a method or function as deprecated since a given version.
#   define UI_DEPRECATED_SINCE(version, ...)    UI_DEPRECATED_SINCE_##version(__VA_ARGS__)

#else

///Marks a method or function as deprecated since a given version.
#   define UI_DEPRECATED_SINCE(version, ...)

#endif /* UIAvailabilityIncludeDeprecationWarnings */

#endif
