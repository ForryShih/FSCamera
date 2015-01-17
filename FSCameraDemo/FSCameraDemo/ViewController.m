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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    FSCamera *camera = [[FSCamera alloc] init];
    camera.delegate = self;
    [camera showImagePickerForCamera];
}

@end
