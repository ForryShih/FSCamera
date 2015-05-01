//
//  FSCamera.h
//  FSCamera
//
//  Created by ForryShih on 1/17/15.
//  Copyright (c) 2015 Rampage Works. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSCamera : NSObject

@property (nonatomic, assign) id <UINavigationControllerDelegate, UIImagePickerControllerDelegate> delegate;
@property (nonatomic, assign) UIImagePickerControllerSourceType sourceType;

- (void)showImagePickerForCamera;
- (void)showImagePickerForPhotoLibrary;
- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType animated:(BOOL)flag completion:(void (^)(void))completion;
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;

@end
