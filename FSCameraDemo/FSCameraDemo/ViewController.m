//
//  ViewController.m
//  FSCameraDemo
//
//  Created by ForryShih on 1/17/15.
//  Copyright (c) 2015 Rampage Works. All rights reserved.
//

#import "ViewController.h"
#import "FSCamera.h"

@interface ViewController ()

@property (nonatomic, strong) FSCamera *camera;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    self.camera = [[FSCamera alloc] init];
    self.camera.delegate = self;
    [self.camera showImagePickerForCamera];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
}

@end
