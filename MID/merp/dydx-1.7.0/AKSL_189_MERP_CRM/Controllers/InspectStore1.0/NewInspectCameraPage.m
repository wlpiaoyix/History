//
//  NewInspectCameraPage.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-Apple on 14/6/12.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "NewInspectCameraPage.h"
#import "CameraImageHelper.h"
#import "ImageUtil.h"

@interface NewInspectCameraPage ()<AVHelperDelegate>{

    NSMutableArray * listForImages;
    NSMutableArray * listForPerImages;
    BOOL isWaitImage;
    BOOL isHasImages;
    BOOL isChangeImage;
}

@property(retain,nonatomic) CameraImageHelper *CameraHelper;

@end

@implementation NewInspectCameraPage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setImages:(NSMutableArray *)listIamge isFrsat:(BOOL)isfrsat{
    listForPerImages = listIamge;
    listForImages = [[NSMutableArray alloc]initWithArray:listForPerImages copyItems:YES];
    isHasImages = isfrsat;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _CameraHelper = [[CameraImageHelper alloc]init];
    _CameraHelper.delegate = self;
    // 开始实时取景
    [_CameraHelper startRunning];
    [_CameraHelper embedPreviewInView:self.cameraView];
    [_CameraHelper changePreviewOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    UIButton * but = (UIButton *)[self.view viewWithTag:9527];
    [but setEnabled:YES];
    [self DrawImages];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    isWaitImage = NO;
    // Do any additional setup after loading the view from its nib.
    isChangeImage = NO;
    _textForCountOfImages.text = @"0";
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_CameraHelper changePreviewOrientation:(UIInterfaceOrientation)toInterfaceOrientation];
}

-(IBAction)getCameraImage:(id)sender{
    if (isWaitImage||listForImages.count>=4) {
        return;
    }
 [_CameraHelper CaptureStillImage];
    isWaitImage = YES;
}

-(void)foucusStatus:(BOOL)isadjusting{

}

-(void)didFinishedCapture:(UIImage *)_img{
isChangeImage = YES;
NSLog(@"%f,%f",_img.size.height,_img.size.width);
UIImage * newImage =[ImageUtil scaleFromImage:_img MaxHeight:960 MaxWidth:640];
[listForImages addObject:newImage];
isWaitImage = NO;
[_img release];
[self DrawImages];
}

-(void)DrawImages{
    for (int i=0; i<4; i++) {
        UIButton * but = (UIButton *)[_imagesView viewWithTag:i+1];
        if (i<listForImages.count) {
            UIImage * image = listForImages[i];
            [but setBackgroundImage:image forState:UIControlStateNormal];
            but.hidden = NO;
        }else{
            but.hidden = YES;
        }
        
    }
    _textForCountOfImages.text = [NSString stringWithFormat:@"%d",listForImages.count];
}


-(IBAction)next:(id)sender{
    if (listForImages.count==0) {
        showMessageBox(@"至少拍摄一张照片！");
    }else {
    if(isChangeImage){
    [listForPerImages removeAllObjects];
    [listForPerImages addObjectsFromArray:listForImages];
        }
    [self dismissModalViewControllerAnimated:YES];
    }
}

-(IBAction)goback:(id)sender{
[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)deleteImages:(id)sender{
    UIButton * but = sender;
    isChangeImage = YES;
    [listForImages removeObjectAtIndex:but.tag-1];
    [self DrawImages];
}

- (void)dealloc {
    [_cameraView release];
    [_imagesView release];
    [_textForCountOfImages release];
   // for (UIImage * image in listForImages) {
   //     [image release];
   // }
    [listForImages release];
    [_CameraHelper stopRunning];
    [_CameraHelper release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
