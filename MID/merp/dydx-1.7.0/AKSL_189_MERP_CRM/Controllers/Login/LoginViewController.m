//
//  LoginViewController.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-10-18.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetPasswordViewController.h"
#import "LeftMenuViewController.h"
#import "MainPageViewController.h"
#import "MMDrawerController.h"
#import "RightMenuViewController.h"
#import "ASIFormDataRequest.h"
#import "HttpApiCall.h"
#import "MyScheduleAlertOPT.h"
#import "LoginUser.h"
#import "CompulsoryUpdateController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

static UINavigationController *mainNav;

+(UINavigationController *)getMainNav{
    return mainNav;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)loginToServer:(id)sender {
  //  [self toMainPage:YES];
   // return;
    [self clickBackground:sender];
    [self showActivityIndicator];
    if(self.username.text==nil||[@"" isEqual:self.username.text]){
        showAlertBox(@"提示", @"请输入用户名！");
        [self hideActivityIndicator];
        return;
    }
    if(self.password.text==nil||[@"" isEqual:self.password.text]){
        showAlertBox(@"提示", @"请输入密码！");
        [self hideActivityIndicator];
        return;
    }
    
    [ConfigManage setConfig:HTTP_API_PCODE Value:self.username.text];
    [ConfigManage setConfig:STR_USER_PASSWORD Value:self.password.text];
      ASIFormDataRequest *requestx = [HttpApiCall requestCallPOST:@"/api/user/loginmobile" Params:nil Logo:@"user_login"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
//            LoginUser * user = [LoginUser getLoginUserFromJson:reArg];
            NSDictionary *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                showAlertBox(@"登录失败", @"帐户信息不正确。请重新输入。");
                [ConfigManage clearAllData];
                return;
            }
            if([reArg hasPrefix:@"{\"ecy\""]){
                showAlertBox(@"登录失败", @"帐户信息不正确。请重新输入。");
                [ConfigManage clearAllData];
                return;
            }
            [ConfigManage setConfig:HTTP_API_JSON_PERSONINFO Value:reArg];
            [MyScheduleAlertOPT getAlertInfo];
            [self toMainPage:YES];
        }
        @catch (NSException *exception) {
            showAlertBox(@"提示", exception.reason);
            [ConfigManage clearAllData];
        }
        @finally {
            [self hideActivityIndicator];
            _viewForMain.hidden = NO;
        }
    }];
    [request setFailedBlock:^{
        showAlertBox(@"登录失败", @"网络连接问题!请稍后再试。");
         [ConfigManage clearAllData];
          _viewForMain.hidden = NO;
        [self hideActivityIndicator];
    }];
    [request startAsynchronous];
  //  int i=0;
}
- (IBAction)forgetPassword:(id)sender {
   ForgetPasswordViewController * forgetpassword = [[ForgetPasswordViewController alloc]initWithNibName:@"ForgetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:forgetpassword animated:YES];
  //  showMessageBox(@"为了系统的安全性，请联系系统管理员找回密码。");
}

- (IBAction)clickBackground:(id)sender {
    [_username resignFirstResponder];
    [_password resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // showMessageBox(@"渠道经理用户用户名最后一位为3，领导用户修改最后一位为1，代理商用户修改最后一位为4.");
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(intputshow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(intputhide:) name:UIKeyboardWillHideNotification object:nil];
    //[_username limitTextLength:11];
     // _username.pattern = @"^\\d{11}$";
   // _username.limitTextLength = 11;
    [_username limitTextLength:11];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self cToLogin];
}

-(void)cToLogin{
    NSString * usercode = [ConfigManage getConfig:HTTP_API_JSON_PERSONINFO];
    if (usercode && usercode.length>0) {
        @try {
            NSDictionary * user = [usercode JSONValueNewMy];
            if(user){
                self.username.text = [ConfigManage getConfig:HTTP_API_PCODE];
                self.password.text = [ConfigManage getConfig:STR_USER_PASSWORD];
                _viewForMain.hidden = YES;
                
                [self loginToServer:nil];
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
}
-(void)toMainPage:(BOOL)isLogin{
     
    [ConfigManage setConfig:APP_NAME_AND_RES Value:@"yes"];
    MainPageViewController *main = [MainPageViewController getMainPage];
     UINavigationController *navMain = [[UINavigationController alloc]initWithRootViewController:main];
    navMain.navigationBarHidden = YES;
    LeftMenuViewController *left=[[LeftMenuViewController alloc]initWithNibName:@"LeftMenuViewController" bundle:nil];
    RightMenuViewController *right=[[RightMenuViewController alloc]initWithNibName:@"RightMenuViewController" bundle:nil];
    MMDrawerController *viewcontroller = [[MMDrawerController alloc]initWithCenterViewController:navMain leftDrawerViewController:left rightDrawerViewController:right];
    [viewcontroller setMaximumLeftDrawerWidth:200];
    [viewcontroller setMaximumRightDrawerWidth:250];
    [viewcontroller setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [viewcontroller setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    viewcontroller.centerHiddenInteractionMode = 0;
    [viewcontroller setShouldStretchDrawer:NO];
      
    UINavigationController *navnext = [[UINavigationController alloc]initWithRootViewController:viewcontroller];
    [navnext setNavigationBarHidden:YES];
    mainNav = navnext;
    [UIApplication sharedApplication].keyWindow.rootViewController = navnext;
    
    CGRect frameWindow = [[UIScreen mainScreen] bounds];
    if (IOS7_OR_LATER) {
        
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
        frameWindow=  CGRectMake(0,20,frameWindow.size.width,frameWindow.size.height-20);
        [[UIApplication sharedApplication].keyWindow.rootViewController.view setFrame:frameWindow];
        //[navnext.view setFrame:frameWindow];
        //[UIApplication sharedApplication].keyWindow.frame = frameWindow;
    }else{
        frameWindow=  CGRectMake(0,20,frameWindow.size.width,frameWindow.size.height-20);
        navnext.view.frame = frameWindow;
    }
   // [self.navigationController pushViewController:viewcontroller animated:YES];
    
}
-(void)intputshow:(NSNotification *)notification{
    //键盘显示，设置toolbar的frame跟随键盘的frame
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
         CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        float num =400.0 - keyBoardFrame.origin.y;
        if(num > 0){
        CGRect frmeimage = _viewForMain.frame;
        frmeimage.origin.y =0 - num;
        _viewForMain.frame = frmeimage;
        }
    }];
}

-(void)intputhide:(NSNotification *)notification{
    //键盘显示，设置toolbar的frame跟随键盘的frame
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect frmeimage = _viewForMain.frame;
        frmeimage.origin.y = 0;
        _viewForMain.frame = frmeimage;
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
