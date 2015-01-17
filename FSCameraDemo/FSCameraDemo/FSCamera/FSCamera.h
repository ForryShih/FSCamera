//
//  FSCamera.h
//  FSCamera
//
//  Created by ForryShih on 1/17/15.
//  Copyright (c) 2015 Rampage Works. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSCamera : NSObject

@property (nonatomic,assign) id <UINavigationControllerDelegate, UIImagePickerControllerDelegate> delegate;

- (void)showImagePickerForCamera;
- (void)showImagePickerForPhotoLibrary;

@end
