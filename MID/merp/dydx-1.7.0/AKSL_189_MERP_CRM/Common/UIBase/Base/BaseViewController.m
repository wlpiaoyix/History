//
//  BaseViewController.m
//  YLJOAIpad
//
//  Created by robin on 13-3-19.
//  Copyright (c) 2013年 robin. All rights reserved.
//

#import "BaseViewController.h" 
#import "UIViewController+MMDrawerController.h"
#import "RightMenuViewController.h"
#import "CompulsoryUpdateController.h"
 

#define MyMBProgressHUDTAG  78495
@interface BaseViewController ()

@end

@implementation BaseViewController 
 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
	// Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
        CGRect frameWindow = [[UIScreen mainScreen] bounds];
        
        frameWindow =  CGRectMake(0,20,frameWindow.size.width,frameWindow.size.height-20);
        [[UIApplication sharedApplication].keyWindow.rootViewController.view setFrame:frameWindow];
    }
    
    //升级软件配置
}
-(void)setKeyboardNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(intputshow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(intputhide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)intputshow:(NSNotification *)notification{
    //键盘显示，设置toolbar的frame跟随键盘的frame
   
}

-(void)intputhide:(NSNotification *)notification{
    //键盘显示，设置toolbar的frame跟随键盘的frame
  
}
-(void)setCornerRadiusAndBorder:(UIView *)view{
    view.layer.cornerRadius = 5;
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)topButtonClick:(id)sender{

    int tag = ((UIView *)sender).tag;
    switch (tag) {
        case 100:
            //left click
            [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
            break;
        case 101:
            //rgiht click
            [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
            break;
        default:
            break;
    }
}
#pragma mark -加载数据


- (void) showActivityIndicator
{
    self.view.userInteractionEnabled=NO;
    MBProgressHUD * tempMBProgressHUD =(MBProgressHUD *)[self.view viewWithTag:MyMBProgressHUDTAG];
    if (tempMBProgressHUD!=nil) {
        [tempMBProgressHUD removeFromSuperview];
    }
    myMBProgressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    myMBProgressHUD.tag=MyMBProgressHUDTAG;
	[self.view addSubview:myMBProgressHUD];
	[self.view bringSubviewToFront:myMBProgressHUD];
    myMBProgressHUD.delegate = self;
    myMBProgressHUD.labelText =@"请稍后，加载数据...";
	[myMBProgressHUD show:YES];
 
}



- (void) hideActivityIndicator
{
    
    self.view.userInteractionEnabled=YES;
    if (myMBProgressHUD)
    {
        [myMBProgressHUD removeFromSuperview];
        [myMBProgressHUD release];
        myMBProgressHUD = nil;
    }
    MBProgressHUD * tempMBProgressHUD =(MBProgressHUD *)[self.view viewWithTag:MyMBProgressHUDTAG];
    if (tempMBProgressHUD!=nil) {
        [tempMBProgressHUD removeFromSuperview];
    }
    
}
 
@end
