//
//  CameraViewController.h
//
//
//  Created by ForryShih on 1/4/15.
//  Copyright (c) 2015 Rampage Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSCamera;

@interface CameraViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) FSCamera *camera;

@end
