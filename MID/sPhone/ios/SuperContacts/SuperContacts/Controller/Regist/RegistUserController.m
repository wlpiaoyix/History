//
//  RegistUserController.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-17.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "RegistUserController.h"
#import "ModleUser.h"
#import "HttpApiCall.h"
#import "ASIFormDataRequest.h"
@interface RegistUserController (){
@private ModleUser *userx;
    
}
@property (strong, nonatomic) IBOutlet UIView *view01;
@property (strong, nonatomic) IBOutlet UIView *view0101;
@property (strong, nonatomic) IBOutlet UITextField *textFiledPW01;
@property (strong, nonatomic) IBOutlet UITextField *textFiledPW02;

@end

@implementation RegistUserController
+(id) getNewInstance{
    return [[RegistUserController alloc] initWithNibName:@"RegistUserController" bundle:nil];
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
    [super setCornerRadiusAndBorder:_view01 CornerRadius:0 BorderWidth:0.5 BorderColor:[[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor]];
    [super setCornerRadiusAndBorder:_view0101 CornerRadius:0 BorderWidth:0.5 BorderColor:[[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor]];
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void) setModelUser:(ModleUser*) user{
    userx = user;
}
- (IBAction)clickConfirm:(id)sender {
    @try {
        if(!userx){
            @throw [[NSException alloc] initWithName:@"空异常" reason:@"没有找到对应的用户信息" userInfo:nil];
        }
        if(![NSString isEnabled:_textFiledPW01.text]){
            @throw [[NSException alloc] initWithName:@"空异常" reason:@"请输入密码" userInfo:nil];
        }
        if(![NSString isEnabled:_textFiledPW02.text]){
            @throw [[NSException alloc] initWithName:@"空异常" reason:@"请确认密码" userInfo:nil];
        }
        if(![_textFiledPW01.text isEqual:_textFiledPW02.text]){
            @throw [[NSException alloc] initWithName:@"值异常" reason:@"再次密码输入不同" userInfo:nil];
        }
        NSString *phone = userx.phoneNum;
        NSString *password = _textFiledPW01.text;
        if(![NSString isEnabled:phone]){
            COMMON_SHOWALERT(@"请输入手机号");
            return;
        }
        
        NSString *strurl = [NSString stringWithFormat:@"/regist/vcode/%@/%@/%@",phone,password,userx.vcode];
        strurl = COMMON_GET_BASE_URL(strurl);
        NSURL *ourl = [NSURL URLWithString:strurl];
        ASIFormDataRequest *requestx = [ASIFormDataRequest requestWithURL:ourl];
        __weak typeof(requestx) request = requestx;
        [request setTimeOutSeconds:20];
        [request setResponseEncoding:NSUTF8StringEncoding];
        [request setRequestMethod:COMMON_HTTP_API_POST];
        [request setCompletionBlock:^{
            @try {
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *result = [request responseString];
                
                if(![NSString isEnabled:result]&&[result JSONValue]){
                    @throw [[NSException alloc] initWithName:@"空值异常" reason:@"数据返回了一个空!" userInfo:nil];
                }
                [ConfigManage setConfigTemp:COMMON_KEY_AT Value:phone];
                [ConfigManage setConfigTemp:COMMON_KEY_PW Value:password];
                [ConfigManage setConfigPublic:COMMON_KEY_AT Value:phone];
                [ConfigManage setConfigPublic:COMMON_KEY_PW Value:password];
                [self.navigationController popToRootViewControllerAnimated:YES];
                COMMON_SHOWALERT(@"注册成功");
            }
            @catch (NSException *exception) {
                COMMON_SHOWALERT(exception.reason);
            }
            @finally {
                [super hideActivityIndicator];
            }
        }];
        [request setFailedBlock:^{
            [super hideActivityIndicator];
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

- (IBAction)clickReturn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
