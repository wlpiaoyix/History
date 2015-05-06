//
//  LoginController.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-4.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "LoginController.h"
#import "CTM_LeftController.h"
#import "CTM_RightController.h"
#import "CTM_MainController.h"
#import "MMDrawerController.h"
#import "RegistController.h"
#import "ASIFormDataRequest.h"
#import "HttpApiCall.h"
#import "ConfigManage.h"
#import <AddressBook/AddressBook.h>
@interface LoginController ()
@property (strong, nonatomic) IBOutlet UITextField *textfieldPhone;
@property (strong, nonatomic) IBOutlet UITextField *textfieldPassword;
@property (strong, nonatomic) IBOutlet UIButton *buttonReturn;

@end

@implementation LoginController

+(id) getNewInstance{
    return [[LoginController alloc] initWithNibName:@"LoginController" bundle:nil];
}
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
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toucheControll)];
    [self.view addGestureRecognizer:tapGesture];
    [_buttonReturn addTarget:self action:@selector(clickReturn:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *phone = [ConfigManage getConfigPublic:COMMON_KEY_AT];
    NSString *password = [ConfigManage getConfigPublic:COMMON_KEY_PW];
    _textfieldPhone.text = phone;
    _textfieldPassword.text = password;
//    
//    NSArray *tempx = [[NSArray alloc] initWithObjects:@"sdfs",@"adfasd", nil];
//    CFArrayRef people = (__bridge CFArrayRef)(tempx);
//    NSData *vCardData = (__bridge_transfer NSData*)(ABPersonCreateVCardRepresentationWithPeople(people));
//    NSLog(@"sdfs");
}
-(void)viewDidAppear:(BOOL)animated{
    NSString *phone = [ConfigManage getConfigPublic:COMMON_KEY_AT];
    NSString *password = [ConfigManage getConfigPublic:COMMON_KEY_PW];
    _textfieldPhone.text = phone;
    _textfieldPassword.text = password;
    [super viewDidAppear:animated];
}
-(bool) toucheControll{
    bool flag = [_textfieldPhone resignFirstResponder];
    flag = flag||[_textfieldPassword resignFirstResponder];
    return flag;
}
- (IBAction)clickLogin:(id)sender {
    [ConfigManage clearAllTempData];
    NSString *phone = _textfieldPhone.text;
    NSString *password = _textfieldPassword.text;
    if(![NSString isEnabled:phone]||![NSString isEnabled:password])
    if([self toucheControll]) return;
    @try {
        if (![NSString isEnabled:phone]) {
            @throw [[NSException alloc] initWithName:@"登录异常" reason:@"电话号码为空!" userInfo:nil];
        }
        if (![NSString isEnabled:password]) {
            @throw [[NSException alloc] initWithName:@"登录异常" reason:@"密码为空!" userInfo:nil];
        }
        [ConfigManage setConfigTemp:COMMON_KEY_AT Value:phone];
        [ConfigManage setConfigTemp:COMMON_KEY_PW Value:password];
        [ConfigManage setConfigPublic:COMMON_KEY_AT Value:phone];
        [ConfigManage setConfigPublic:COMMON_KEY_PW Value:password];
        NSMutableDictionary *jsonData = [NSMutableDictionary new];
        [jsonData setValue:phone forKey:@"userCode"];
        [jsonData setValue:password forKey:@"password"];
        ASIFormDataRequest *requestx = [HttpApiCall requestCallPOST:@"/login/mobile"Params:jsonData Logo:@"login"];
        __weak typeof(requestx) request = requestx;
        __weak typeof(self) tempself = self;
        
        [request setCompletionBlock:^{
            @try {
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *result = [request responseString];
                if(![NSString isEnabled:result]){
                    @throw [[NSException alloc] initWithName:@"空异常" reason:@"数据返回了一个空!" userInfo:nil];
                }
                id accountInfo = [result JSONValue];
                if(!accountInfo){
                    @throw [[NSException alloc] initWithName:@"值异常" reason:@"用户名或密码错误!" userInfo:nil];
                }
                [ConfigManage setConfigCache:CMCK_ACCONTINFO Value:result];
                [tempself  toMainController];
            }
            
            @catch (NSException *exception) {
                COMMON_SHOWALERT(exception.reason)
            }
            @finally {
                [tempself hideActivityIndicator];
            }
        }];
        [request setFailedBlock:^{
            [tempself hideActivityIndicator];
            COMMON_SHOWALERT(@"用户名或密码有误!");
        }];
        [request startAsynchronous];
        [super showActivityIndicator];
    }
    @catch (NSException *exception) {
        COMMON_SHOWALERT(exception.reason);
    }
    @finally {
    }
}
- (IBAction)clickRegister:(id)sender {
    if([self toucheControll]) return;
    RegistController *rc = [RegistController getNewInstance];
    [self.navigationController pushViewController:rc animated:YES];
}
-(void) toMainController{
    CTM_MainController *main = [CTM_MainController getSingleInstance];
    UINavigationController *navMain = [[UINavigationController alloc]initWithRootViewController:main];
    navMain.navigationBarHidden = YES;
    CTM_LeftController *left=[CTM_LeftController getSingleInstance];
    CTM_RightController *right=[CTM_RightController getSingleInstance];
    MMDrawerController *viewcontroller = [[MMDrawerController alloc]initWithCenterViewController:navMain leftDrawerViewController:left rightDrawerViewController:right];
    [viewcontroller setMaximumLeftDrawerWidth:106];
    [viewcontroller setMaximumRightDrawerWidth:255];
    [viewcontroller setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [viewcontroller setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    viewcontroller.centerHiddenInteractionMode = 0;
    [viewcontroller setShouldStretchDrawer:NO];
    UINavigationController *navnext = [[UINavigationController alloc]initWithRootViewController:viewcontroller];
    [navnext setNavigationBarHidden:YES];
    [UIApplication sharedApplication].keyWindow.rootViewController = navnext;
    COMMON_ADDROOTCONTROLLER(navnext);
}
-(void) clickReturn:(id) sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
