//
//  upLoadFilesViewController.m
//  FDC
//
//  Created by NewDoone on 15/1/20.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "upLoadFilesViewController.h"

@interface upLoadFilesViewController ()

@end

@implementation upLoadFilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
-(void)initView{
    self.cameraView.layer.cornerRadius=12.0;
    self.cameraView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.cameraView.layer.borderWidth=0.5;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)searchAction:(id)sender {
}
- (IBAction)takePhotoAction:(id)sender {
    NSLog(@"take photo");
}


@end
