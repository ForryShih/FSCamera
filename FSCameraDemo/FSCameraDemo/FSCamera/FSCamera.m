//
//  FSCamera.m
//  FSCamera
//
//  Created by ForryShih on 1/17/15.
//  Copyright (c) 2015 Rampage Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCamera.h"


@interface FSCamera ()

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) IBOutlet UIView *cameraOverlayView;
@property (nonatomic, weak) IBOutlet UIButton *takePhotoButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIButton *switchCameraButton;
@property (nonatomic, weak) IBOutlet UIButton *switchFlashModeButton;
@property (nonatomic, weak) IBOutlet UIView *captureModeIndicatorView;

@end


@implementation FSCamera

#pragma mark - Lifecycle Methods

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}

- (void)showImagePickerForCamera
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (void)showImagePickerForPhotoLibrary
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self.delegate;
    self.imagePickerController.sourceType = sourceType;
    self.imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        self.imagePickerController.showsCameraControls = NO;
        
        [[NSBundle mainBundle] loadNibNamed:@"FSCameraOverlayView" owner:self options:nil];
        self.cameraOverlayView.frame = self.imagePickerController.cameraOverlayView.frame;
        self.imagePickerController.cameraOverlayView = self.cameraOverlayView;
        self.cameraOverlayView = nil;
    }
    
    CGFloat offsetY = self.imagePickerController.navigationBar.frame.size.height;
    self.imagePickerController.cameraViewTransform = CGAffineTransformMakeTranslation(0.0f,offsetY);
    
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(switchCaptureMode:)];
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.imagePickerController.cameraOverlayView addGestureRecognizer:swipeGestureLeft];
    
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(switchCaptureMode:)];
    swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.imagePickerController.cameraOverlayView addGestureRecognizer:swipeGestureRight];

    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark - Action Methods

- (IBAction)takePhoto:(UIButton *)sender
{
    [self.imagePickerController takePicture];
}

- (IBAction)cancelButtonClicked:(UIButton *)sender
{
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)switchCameraButtonClicked:(UIButton *)sender
{
    self.imagePickerController.cameraDevice = (self.imagePickerController.cameraDevice + 1) % 2;
}

- (IBAction)switchFlashModeButtonClicked:(UIButton *)sender
{
    NSInteger cameraFlashMode = self.imagePickerController.cameraFlashMode + 1;
    if (cameraFlashMode > 1)
    {
        cameraFlashMode = -1;
    }
    self.imagePickerController.cameraFlashMode = cameraFlashMode;
}

- (void)switchCaptureMode:(UISwipeGestureRecognizer *)swipeGesture
{
    if (swipeGesture.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if (self.imagePickerController.cameraCaptureMode == UIImagePickerControllerCameraCaptureModePhoto)
        {
            return;
        }
        else
        {
            self.takePhotoButton.tag = 0;
            self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            [self adjustCaptureModeIndicatorView:UIImagePickerControllerCameraCaptureModePhoto];
        }
    }
    else if (swipeGesture.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if (self.imagePickerController.cameraCaptureMode == UIImagePickerControllerCameraCaptureModeVideo)
        {
            return;
        }
        else
        {
            self.takePhotoButton.tag = 1;
            self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
            [self adjustCaptureModeIndicatorView:UIImagePickerControllerCameraCaptureModeVideo];
        }
    }
}

#pragma mark - Utility Methods

- (void)adjustCaptureModeIndicatorView:(UIImagePickerControllerCameraCaptureMode)captureMode
{
    if (captureMode == UIImagePickerControllerCameraCaptureModeVideo)
    {
        [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGFloat originX = self.captureModeIndicatorView.frame.origin.x + self.captureModeIndicatorView.frame.size.width * 0.5f;
            self.captureModeIndicatorView.frame = CGRectMake(originX, self.captureModeIndicatorView.frame.origin.y, self.captureModeIndicatorView.frame.size.width, self.captureModeIndicatorView.frame.size.height);
            
        } completion:nil];
    }
    else if (captureMode == UIImagePickerControllerCameraCaptureModePhoto)
    {
        [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGFloat originX = self.captureModeIndicatorView.frame.origin.x - self.captureModeIndicatorView.frame.size.width * 0.5f;
            self.captureModeIndicatorView.frame = CGRectMake(originX, self.captureModeIndicatorView.frame.origin.y, self.captureModeIndicatorView.frame.size.width, self.captureModeIndicatorView.frame.size.height);
            
        } completion:nil];
    }
}


@end
