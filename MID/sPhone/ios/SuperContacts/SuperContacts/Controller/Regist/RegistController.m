//
//  RegistController.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-10.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "RegistController.h"
#import "ASIFormDataRequest.h"
#import "HttpApiCall.h"
#import "ModleUser.h"
#import "RegistUserController.h"
@interface RegistController (){
@private NSString *vcode;
}
@property (strong, nonatomic) IBOutlet UITextField *textfieldPhone;
@property (strong, nonatomic) IBOutlet UITextField *textfieldAuthCode;

@end

@implementation RegistController
+(id) getNewInstance{
    NSString *a = @"//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.";
    return [[RegistController alloc] initWithNibName:@"RegistController" bundle:nil];
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
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toucheControll)];
    [self.view addGestureRecognizer:tapGesture];
    [self setCornerRadiusAndBorder:[self.view viewWithTag:134563]];
    [self setCornerRadiusAndBorder:[self.view viewWithTag:432524]];
    // Do any additional setup after loading the view from its nib.
}
-(bool) toucheControll{
    bool flag = [_textfieldPhone resignFirstResponder];
    flag = flag||[_textfieldAuthCode resignFirstResponder];
    return flag;
}
- (IBAction)clickGetAuthCode:(id)sender {
    if(![NSString isEnabled:_textfieldPhone.text]){
        COMMON_SHOWALERT(@"请输入手机号");
        return;
    }
    NSString *strurl = [NSString stringWithFormat:@"/regist/vcode/%@",_textfieldPhone.text];
    strurl= COMMON_GET_BASE_URL(strurl);
    NSURL *ourl = [NSURL URLWithString:strurl];
    
    ASIFormDataRequest *requestx = [ASIFormDataRequest requestWithURL:ourl];
    __weak typeof(requestx) request = requestx;
    __weak typeof(self) tempself = self;
    [request setTimeOutSeconds:20];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setRequestMethod:COMMON_HTTP_API_GET];
    [request setCompletionBlock:^{
        @try {
            [request setResponseEncoding:NSUTF8StringEncoding];
            NSString *result = [request responseString];
            if(![NSString isEnabled:result]){
                @throw [[NSException alloc] initWithName:@"空值异常" reason:@"数据返回了一个空!" userInfo:nil];
            }
            NSDictionary *json = [result JSONValue];
            if(![@"success" isEqual:[json valueForKey:@"state"]]){
                @throw [[NSException alloc] initWithName:@"帐号异常" reason:@"当前帐号已被注册!" userInfo:nil];
            }
            vcode = [json valueForKey:@"vcode"];
            _textfieldAuthCode.text = vcode;
        }
        @catch (NSException *exception) {
            COMMON_SHOWALERT(exception.reason);
        }
        @finally {
            [tempself hideActivityIndicator];
        }
    }];
    [request setFailedBlock:^{
        [tempself hideActivityIndicator];
    }];
    [request startAsynchronous];
    [self showActivityIndicator];
}
- (IBAction)clickRegistAndNext:(id)sender {
    if(![NSString isEnabled:_textfieldAuthCode.text]){
        COMMON_SHOWALERT(@"验证码不能为空!");
        return;
    }
    NSString *phone = _textfieldPhone.text;
    if(![NSString isEnabled:phone]){
        COMMON_SHOWALERT(@"请输入手机号");
        return;
    }
    ModleUser *user = [ModleUser new];
    user.phoneNum = phone;
    user.vcode = vcode;
    RegistUserController *ruc = [RegistUserController getNewInstance];
    [ruc setModelUser:user];
    [self.navigationController pushViewController:ruc animated:YES];
}
-(void) saveLoactionAccountData{
    NSString *phone = [ConfigManage getConfigPublic:COMMON_KEY_AT];
    NSString *password = [ConfigManage getConfigPublic:COMMON_KEY_PW];
    if(![NSString isEnabled:phone]||![NSString isEnabled:password])
        if([self toucheControll]) return;
    @try {
        if (![NSString isEnabled:phone]) {
            @throw [[NSException alloc] initWithName:@"保存异常" reason:@"电话号码为空!" userInfo:nil];
        }
        if (![NSString isEnabled:password]) {
            @throw [[NSException alloc] initWithName:@"保存异常" reason:@"密码为空!" userInfo:nil];
        }
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
        }];
        [request startAsynchronous];
        [super showActivityIndicator];
    }
    @catch (NSException *exception) {
        COMMON_SHOWALERT(exception.reason);
    }
}
- (IBAction)clickReturn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
