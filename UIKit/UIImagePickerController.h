//
//  UIImagePickerController.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/10/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UINavigationController.h"

@protocol UIImagePickerControllerDelegate;

typedef NS_ENUM(NSUInteger, UIImagePickerControllerSourceType) {
    UIImagePickerControllerSourceTypePhotoLibrary,
    UIImagePickerControllerSourceTypeCamera,
    UIImagePickerControllerSourceTypeSavedPhotosAlbum
};

typedef NS_ENUM(NSUInteger, UIImagePickerControllerQualityType) {
    UIImagePickerControllerQualityTypeHigh            = 0,
    UIImagePickerControllerQualityTypeMedium          = 1,  // default value
    UIImagePickerControllerQualityTypeLow             = 2,
    UIImagePickerControllerQualityType640x480         = 3,
    UIImagePickerControllerQualityTypeIFrame1280x720  = 4,
    UIImagePickerControllerQualityTypeIFrame960x540   = 5
};

typedef NS_ENUM(NSUInteger, UIImagePickerControllerCameraDevice) {
    UIImagePickerControllerCameraDeviceRear,
    UIImagePickerControllerCameraDeviceFront
};

typedef NS_ENUM(NSUInteger, UIImagePickerControllerCameraCaptureMode) {
    UIImagePickerControllerCameraCaptureModePhoto,
    UIImagePickerControllerCameraCaptureModeVideo
};

typedef NS_ENUM(NSInteger, UIImagePickerControllerCameraFlashMode) {
    UIImagePickerControllerCameraFlashModeOff  = -1,
    UIImagePickerControllerCameraFlashModeAuto = 0,
    UIImagePickerControllerCameraFlashModeOn   = 1
};

@interface UIImagePickerController : UINavigationController

#pragma mark - Setting the Picker Source

+ (NSArray *)availableMediaTypesForSourceType:(UIImagePickerControllerSourceType)sourceType;
+ (BOOL)isSourceTypeAvailable:(UIImagePickerControllerSourceType)sourceType;

@property (nonatomic) UIImagePickerControllerSourceType sourceType;

#pragma mark - Configuring the Picker

@property (nonatomic) BOOL allowsEditing;
@property (nonatomic, unsafe_unretained) id <UINavigationControllerDelegate, UIImagePickerControllerDelegate> delegate;
@property (nonatomic) NSArray *mediaTypes;

#pragma mark - Configuring the Video Capture Options

@property (nonatomic) UIImagePickerControllerQualityType videoQuality;
@property (nonatomic) NSTimeInterval videoMaximumDuration;

#pragma mark - Customizing the Camera Controls

@property (nonatomic) BOOL showsCameraControls;
@property (nonatomic) UIView *cameraOverlayView;
@property (nonatomic) CGAffineTransform cameraViewTransform;

#pragma mark - Capturing Still Images or Movies

- (void)takePicture;
- (void)startVideoCapture;
- (void)stopVideoCapture;

#pragma mark - Configuring the Camera

@property (nonatomic) UIImagePickerControllerCameraDevice cameraDevice;

#pragma mark -

+ (BOOL)isCameraDeviceAvailable:(UIImagePickerControllerCameraDevice)cameraDevice;
+ (NSArray *)availableCaptureModesForCameraDevice:(UIImagePickerControllerCameraDevice)cameraDevice;

@property (nonatomic) UIImagePickerControllerCameraCaptureMode cameraCaptureMode;

#pragma mark - 

@property (nonatomic) UIImagePickerControllerCameraFlashMode cameraFlashMode;
+ (BOOL)isFlashAvailableForCameraDevice:(UIImagePickerControllerCameraDevice)cameraDevice;

@end

#pragma mark - Image and Movie Saving

UIKIT_EXTERN void UIImageWriteToSavedPhotosAlbum(UIImage *image, id completionTarget, SEL completionSelector, void *contextInfo);

#pragma mark -

UIKIT_EXTERN BOOL UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(NSString *videoPath);
UIKIT_EXTERN void UISaveVideoAtPathToSavedPhotosAlbum(NSString *videoPath, id completionTarget, SEL completionSelector, void *contextInfo);

#pragma mark -

@protocol UIImagePickerControllerDelegate <NSObject>
@optional

#pragma mark - Closing the Picker

- (void)imagePickerController:(UIImagePickerController *)controller didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)controller;

@end

UIKIT_EXTERN NSString *const UIImagePickerControllerMediaType;
UIKIT_EXTERN NSString *const UIImagePickerControllerOriginalImage;
UIKIT_EXTERN NSString *const UIImagePickerControllerEditedImage;
UIKIT_EXTERN NSString *const UIImagePickerControllerCropRect;
UIKIT_EXTERN NSString *const UIImagePickerControllerMediaURL;
UIKIT_EXTERN NSString *const UIImagePickerControllerReferenceURL;
UIKIT_EXTERN NSString *const UIImagePickerControllerMediaMetadata;
