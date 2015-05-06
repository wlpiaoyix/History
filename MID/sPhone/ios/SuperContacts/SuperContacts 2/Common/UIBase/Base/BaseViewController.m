//
//  BaseViewController.m
//  YLJOAIpad
//
//  Created by robin on 13-3-19.
//  Copyright (c) 2013年 robin. All rights reserved.
//

#import "BaseViewController.h" 
#import "UIViewController+MMDrawerController.h"

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
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
        CGRect frameWindow = [[UIScreen mainScreen] bounds];
        frameWindow =  CGRectMake(0,20,frameWindow.size.width,frameWindow.size.height-20);
        [[UIApplication sharedApplication].keyWindow.rootViewController.view setFrame:frameWindow];
    }
    [super viewDidAppear:YES];
}

-(void)setKeyboardNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(intputshow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(intputhide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)intputshow:(NSNotification *)notification{
    //键盘显示，设置toolbar的frame跟随键盘的frame
    if(methodIntputshow){
        //键盘显示，设置toolbar的frame跟随键盘的frame
//        CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//        [UIView animateWithDuration:animationTime animations:^{
//            CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        }];
        if(target){
            [target performSelector:methodIntputshow withObject:notification];
        }else{
            [self performSelector:methodIntputshow withObject:notification];
        }
    }
}

-(void)intputhide:(NSNotification *)notification{
    //键盘显示，设置toolbar的frame跟随键盘的frame
    if(methodIntputhidden){
        if(target){
            [target performSelector:methodIntputhidden withObject:notification];
        }else{
            [self performSelector:methodIntputhidden withObject:notification];
        }
    }
  
}
-(void)setCornerRadiusAndBorder:(UIView *)view{
    [self setCornerRadiusAndBorder:view CornerRadius:5 BorderWidth:0.5 BorderColor:[[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor]];
}
-(void)setCornerRadiusAndBorder:(UIView *)view CornerRadius:(float) cornerRadius{
    [self setCornerRadiusAndBorder:view CornerRadius:cornerRadius BorderWidth:0.5 BorderColor:[[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor]];
}
-(void)setCornerRadiusAndBorder:(UIView *)view CornerRadius:(float) cornerRadius BorderWidth:(float) borderWidth BorderColor:(CGColorRef) borderColor{
    view.layer.cornerRadius = cornerRadius;
    view.layer.borderWidth = borderWidth;
    [view setClipsToBounds:YES];
    if(borderColor)view.layer.borderColor = borderColor;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)topLeftOrRight:(ENUM_BVC) bvc{
    switch (bvc) {
        case 1:{
            //rgiht click
            [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
        }
            break;
        default:{
            //left click
            [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        }
            break;
    }
}
#pragma mark -加载数据

- (void) showActivityIndicator{
    [self showActivityIndicator:@"请稍后，加载数据..."];
}

- (void) showActivityIndicator:(NSString*) msg
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
    myMBProgressHUD.labelText = msg;
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
