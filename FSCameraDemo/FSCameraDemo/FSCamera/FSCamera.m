//
//  FSCamera.m
//  FSCamera
//
//  Created by ForryShih on 1/17/15.
//  Copyright (c) 2015 Rampage Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCamera.h"
#import "MZTimerLabel.h"

#define kCameraFlashModeAuto    @"Auto"
#define kCameraFlashModeOn      @"On"
#define kCameraFlashModeOff     @"Off"

@interface FSCamera ()

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) IBOutlet UIView *cameraOverlayView;
@property (nonatomic, weak) IBOutlet UIButton *takePhotoButton;
@property (nonatomic, weak) IBOutlet UIButton *takeVideoButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIButton *switchCameraButton;
@property (nonatomic, weak) IBOutlet UIButton *switchFlashModeButton;
@property (nonatomic, weak) IBOutlet UIView *captureModeIndicatorView;
@property (nonatomic, weak) IBOutlet UILabel *photoLabel;
@property (nonatomic, weak) IBOutlet UILabel *videoLabel;
@property (nonatomic, weak) IBOutlet MZTimerLabel *timerLabel;
@property (nonatomic, assign) BOOL isRecording;


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

- (UIImagePickerControllerSourceType)sourceType
{
    return self.imagePickerController.sourceType;
}

- (void)showImagePickerForCamera
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera animated:YES completion:nil];
}

- (void)showImagePickerForPhotoLibrary
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary animated:YES completion:nil];
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType animated:(BOOL)flag completion:(void (^)(void))completion
{
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.sourceType = sourceType;
    self.imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        self.imagePickerController.showsCameraControls = NO;
        self.imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        
        [[NSBundle mainBundle] loadNibNamed:@"FSCameraOverlayView" owner:self options:nil];
        self.cameraOverlayView.frame = self.imagePickerController.cameraOverlayView.frame;
        self.imagePickerController.cameraOverlayView = self.cameraOverlayView;
        self.cameraOverlayView = nil;
        
        CGFloat offsetY = self.imagePickerController.navigationBar.frame.size.height;
        self.imagePickerController.cameraViewTransform = CGAffineTransformMakeTranslation(0.0f,offsetY);
        
        UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(switchCaptureMode:)];
        swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.imagePickerController.cameraOverlayView addGestureRecognizer:swipeGestureLeft];
        
        UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(switchCaptureMode:)];
        swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self.imagePickerController.cameraOverlayView addGestureRecognizer:swipeGestureRight];
        
        [self.takePhotoButton setImage:[UIImage imageNamed:@"take_photo_btn_highlighted"] forState:UIControlStateHighlighted];
    }

    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.imagePickerController animated:flag completion:completion];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [self.imagePickerController dismissViewControllerAnimated:flag completion:completion];
}

#pragma mark - Action Methods

- (IBAction)takePhoto:(UIButton *)sender
{
    [self.imagePickerController takePicture];
}
- (IBAction)takeVideo:(UIButton *)sender
{
    if (self.isRecording)
    {
        self.isRecording = NO;
        [self.timerLabel pause];
        [self.timerLabel reset];
        [self.takeVideoButton setImage:[UIImage imageNamed:@"take_video_btn_normal"] forState:UIControlStateNormal];
        [self.imagePickerController stopVideoCapture];
    }
    else
    {
        self.isRecording = YES;
        [self.timerLabel start];
        [self.takeVideoButton setImage:[UIImage imageNamed:@"take_video_btn_record"] forState:UIControlStateNormal];
        [self.imagePickerController startVideoCapture];
    }
}

- (IBAction)cancelButtonClicked:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)switchCameraButtonClicked:(UIButton *)sender
{
    self.imagePickerController.cameraDevice = (self.imagePickerController.cameraDevice + 1) % 2;
}

- (IBAction)switchFlashModeButtonClicked:(UIButton *)sender
{

    UIImagePickerControllerCameraFlashMode flashMode = self.imagePickerController.cameraFlashMode;
    if (flashMode == UIImagePickerControllerCameraFlashModeAuto)
    {
        flashMode = UIImagePickerControllerCameraFlashModeOn;
        [self.switchFlashModeButton setImage:[UIImage imageNamed:@"camera_flash_on_btn"] forState:UIControlStateNormal];
    }
    else if (flashMode == UIImagePickerControllerCameraFlashModeOn)
    {
        flashMode = UIImagePickerControllerCameraFlashModeOff;
        [self.switchFlashModeButton setImage:[UIImage imageNamed:@"camera_flash_off_btn"] forState:UIControlStateNormal];
    }
    else if (flashMode == UIImagePickerControllerCameraFlashModeOff)
    {
        flashMode = UIImagePickerControllerCameraFlashModeAuto;
        [self.switchFlashModeButton setImage:[UIImage imageNamed:@"camera_flash_auto_btn"] forState:UIControlStateNormal];
    }
    self.imagePickerController.cameraFlashMode = flashMode;
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
            self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            self.takePhotoButton.hidden = NO;
            self.takeVideoButton.hidden = YES;
            self.timerLabel.hidden = YES;
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
            self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
            self.takePhotoButton.hidden = YES;
            self.takeVideoButton.hidden = NO;
            self.timerLabel.hidden = NO;
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
            
        } completion:^(BOOL finished){
            self.photoLabel.textColor = [UIColor whiteColor];
            self.videoLabel.textColor = [UIColor colorWithRed:255.0f/255.0f green:204.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
            
        }];
    }
    else if (captureMode == UIImagePickerControllerCameraCaptureModePhoto)
    {
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGFloat originX = self.captureModeIndicatorView.frame.origin.x - self.captureModeIndicatorView.frame.size.width * 0.5f;
            self.captureModeIndicatorView.frame = CGRectMake(originX, self.captureModeIndicatorView.frame.origin.y, self.captureModeIndicatorView.frame.size.width, self.captureModeIndicatorView.frame.size.height);
            
        } completion:^(BOOL finished){
            self.videoLabel.textColor = [UIColor whiteColor];
            self.photoLabel.textColor = [UIColor colorWithRed:255.0f/255.0f green:204.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
            
        }];
    }
}

@end
