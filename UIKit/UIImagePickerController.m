//
//  UIImagePickerController.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/10/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIImagePickerController.h"

#import "UIViewController_Private.h"
#import "UIImage.h"

#import <objc/message.h>

#define SUPPORTED_TYPES @[ (id)kUTTypeImage ]

@implementation UIImagePickerController {
    NSOpenPanel *_openPanel;
}

#pragma mark - Lifecycle

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithRootViewController:(UIViewController *)viewController
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)init
{
    /* Don't call super. We aren't a real navigation controller. */
    self.mediaTypes = SUPPORTED_TYPES;
    
    return self;
}

#pragma mark - Overrides

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [NSException raise:NSInternalInconsistencyException
                format:@"UIImagePickerController cannot be contained within another view controller"];
}

- (void)loadView
{
    //Do nothing.
}

- (void)setView:(UIView *)view
{
    [NSException raise:NSInternalInconsistencyException format:@"UIImagePickerController does not support having its view set"];
}

- (UIView *)view
{
    return nil;
}

#pragma mark -

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated
{
    [NSException raise:NSInternalInconsistencyException format:@"Unsupported operation"];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [NSException raise:NSInternalInconsistencyException format:@"Unsupported operation"];
}

- (void)popViewControllerAnimated:(BOOL)animated
{
    [NSException raise:NSInternalInconsistencyException format:@"Unsupported operation"];
}

- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [NSException raise:NSInternalInconsistencyException format:@"Unsupported operation"];
}

- (void)popToRootViewControllerAnimated:(BOOL)animated
{
    [NSException raise:NSInternalInconsistencyException format:@"Unsupported operation"];
}

#pragma mark - Setting the Picker Source

+ (NSArray *)availableMediaTypesForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if(sourceType == UIImagePickerControllerSourceTypePhotoLibrary ||
       sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        return SUPPORTED_TYPES;
    }
    
    return @[];
}

+ (BOOL)isSourceTypeAvailable:(UIImagePickerControllerSourceType)sourceType
{
    return (sourceType == UIImagePickerControllerSourceTypePhotoLibrary ||
            sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum);
}

- (void)setSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if(![self.class isSourceTypeAvailable:sourceType])
        [NSException raise:NSInternalInconsistencyException format:@"Unavailable source type"];
    
    _sourceType = sourceType;
}

#pragma mark - Customizing the Camera Controls

- (void)setShowsCameraControls:(BOOL)showsCameraControls
{
    [NSException raise:NSInvalidArgumentException format:@"%s used with invalid type", __PRETTY_FUNCTION__];
}

- (BOOL)showsCameraControls
{
    [NSException raise:NSInvalidArgumentException format:@"%s used with invalid type", __PRETTY_FUNCTION__];
    return NO;
}

- (void)setCameraOverlayView:(UIView *)cameraOverlayView
{
    [NSException raise:NSInvalidArgumentException format:@"%s used with invalid type", __PRETTY_FUNCTION__];
}

- (UIView *)cameraOverlayView
{
    [NSException raise:NSInvalidArgumentException format:@"%s used with invalid type", __PRETTY_FUNCTION__];
    return nil;
}

- (void)setCameraViewTransform:(CGAffineTransform)cameraViewTransform
{
    [NSException raise:NSInvalidArgumentException format:@"%s used with invalid type", __PRETTY_FUNCTION__];
}

- (CGAffineTransform)cameraViewTransform
{
    [NSException raise:NSInvalidArgumentException format:@"%s used with invalid type", __PRETTY_FUNCTION__];
    return CGAffineTransformIdentity;
}

#pragma mark - Capturing Still Images or Movies

- (void)takePicture
{
    [NSException raise:NSInvalidArgumentException format:@"%s used with invalid type", __PRETTY_FUNCTION__];
}

- (void)startVideoCapture
{
    [NSException raise:NSInvalidArgumentException format:@"%s used with invalid type", __PRETTY_FUNCTION__];
}

- (void)stopVideoCapture
{
    [NSException raise:NSInvalidArgumentException format:@"%s used with invalid type", __PRETTY_FUNCTION__];
}

#pragma mark - Configuring the Camera

+ (BOOL)isCameraDeviceAvailable:(UIImagePickerControllerCameraDevice)cameraDevice
{
    return NO;
}

+ (NSArray *)availableCaptureModesForCameraDevice:(UIImagePickerControllerCameraDevice)cameraDevice
{
    return @[];
}

#pragma mark -

+ (BOOL)isFlashAvailableForCameraDevice:(UIImagePickerControllerCameraDevice)cameraDevice
{
    return NO;
}

#pragma mark - Presentation

- (BOOL)_isResponsibleForOwnModalPresentation
{
    return YES;
}

- (void)_presentModallyWithinViewController:(UIViewController *)parent animate:(BOOL)animate completionHandler:(dispatch_block_t)completionHandler
{
    if(_openPanel) {
        [NSException raise:NSInternalInconsistencyException format:@"Cannot present an image picker more than once"];
    }
    
    self.beingPresented = YES;
    self.presentingViewController = parent;
    parent.presentedViewController = self;
    
    _openPanel = [NSOpenPanel openPanel];
    [_openPanel setAllowsMultipleSelection:NO];
    [_openPanel setAllowedFileTypes:self.mediaTypes];
    [_openPanel setResolvesAliases:YES];
    [_openPanel setDirectoryURL:[[NSFileManager defaultManager] URLForDirectory:NSPicturesDirectory
                                                                       inDomain:NSUserDomainMask
                                                              appropriateForURL:nil
                                                                         create:YES
                                                                          error:NULL]];
    [_openPanel setTitle:UILocalizedString(@"Choose Image", @"")];
    [_openPanel setPrompt:UILocalizedString(@"Choose", @"")];
    [_openPanel beginWithCompletionHandler:^(NSInteger result) {
        self.beingPresented = NO;
        self.presentingViewController = nil;
        parent.presentedViewController = nil;
        
        if(result == NSFileHandlingPanelOKButton) {
            if([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:)]) {
                NSURL *imageURL = [[_openPanel URLs] firstObject];
                UIImage *image = [[UIImage alloc] initWithContentsOfFile:[imageURL path]];
                NSString *mediaType = (id)kUTTypeImage;
                
                NSDictionary *info = @{ UIImagePickerControllerMediaType: mediaType,
                                        UIImagePickerControllerOriginalImage: image,
                                        UIImagePickerControllerMediaURL: imageURL,
                                        UIImagePickerControllerReferenceURL: imageURL };
                
                [self.delegate imagePickerController:self didFinishPickingMediaWithInfo:info];
            }
        } else if(result == NSFileHandlingPanelCancelButton) {
            if([self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)])
                [self.delegate imagePickerControllerDidCancel:self];
        }
        
        _openPanel = nil;
    }];
    
    if(completionHandler)
        completionHandler();
}

- (void)dismissViewControllerAnimated:(BOOL)aniamted completion:(dispatch_block_t)completionHandler
{
    if(!_openPanel) {
        [NSException raise:NSInternalInconsistencyException format:@"Cannot dismiss a non-presented image picker"];
    }
    
    [_openPanel cancel:nil];
}

@end

#pragma mark - Image and Movie Saving

void UIImageWriteToSavedPhotosAlbum(UIImage *image, id completionTarget, SEL completionSelector, void *contextInfo)
{
    NSCParameterAssert(image);
    
    /* - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo; */
    
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setAllowedFileTypes:@[ (id)kUTTypePNG ]];
    [savePanel setDirectoryURL:[[NSFileManager defaultManager] URLForDirectory:NSPicturesDirectory
                                                                      inDomain:NSUserDomainMask
                                                             appropriateForURL:nil
                                                                        create:YES
                                                                         error:NULL]];
    [savePanel beginWithCompletionHandler:^(NSInteger result) {
        NSError *error = nil;
        
        if(result == NSFileHandlingPanelOKButton) {
            NSData *imageData = UIImagePNGRepresentation(image);
            [imageData writeToURL:[savePanel URL] options:NSDataWritingAtomic error:&error];
        } else if(result == NSFileHandlingPanelCancelButton) {
            error = [NSError errorWithDomain:NSCocoaErrorDomain
                                        code:NSFileWriteNoPermissionError
                                    userInfo:@{NSLocalizedDescriptionKey: UILocalizedString(@"User declined saving image", @"")}];
        }
        
        if(completionTarget && completionSelector) {
            ((void(*)(id, SEL, ...))objc_msgSend)(completionTarget, completionSelector, image, error, contextInfo);
        }
    }];
}

#pragma mark -

BOOL UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(NSString *videoPath)
{
    NSCParameterAssert(videoPath);
    
    return NO;
}

void UISaveVideoAtPathToSavedPhotosAlbum(NSString *videoPath, id completionTarget, SEL completionSelector, void *contextInfo)
{
    NSCParameterAssert(videoPath);
    
    UIKitUnimplementedMethod();
}

NSString *const UIImagePickerControllerMediaType = @"UIImagePickerControllerMediaType";
NSString *const UIImagePickerControllerOriginalImage = @"UIImagePickerControllerOriginalImage";
NSString *const UIImagePickerControllerEditedImage = @"UIImagePickerControllerEditedImage";
NSString *const UIImagePickerControllerCropRect = @"UIImagePickerControllerCropRect";
NSString *const UIImagePickerControllerMediaURL = @"UIImagePickerControllerMediaURL";
NSString *const UIImagePickerControllerReferenceURL = @"UIImagePickerControllerReferenceURL";
NSString *const UIImagePickerControllerMediaMetadata = @"UIImagePickerControllerMediaMetadata";
