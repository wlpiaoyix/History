//
//  ForgetPasswordViewController.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-10-20.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "JSON.h"
#import "HttpApiCall.h"
#import "ASIFormDataRequest.h"

@interface ForgetPasswordViewController ()

@end

@implementation ForgetPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)goback:(id)sender {
    [_inputText resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toServer:(id)sender {
    [_inputText resignFirstResponder];
    NSURL *url =[NSURL URLWithString:API_BASE_URL(@"/api/sms/password?code=5488888&ak=817cdcb1b3bfdc220da5c48c000291283d3a5050&log=user_login")]; //@"/api/sms/password";// [NSString stringWithFormat:@"/api/products/1/10"];
    NSString *data = [NSString stringWithFormat:@"{receiveNum:%@}",_inputText.text];
  __weak  ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        const char* str = [data UTF8String];
        NSMutableData *nsdata = [[NSMutableData alloc]initWithBytes:(str) length:strlen(str)];
        [request setPostBody:nsdata];
    [request setTimeOutSeconds:30];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setRequestMethod:HTTP_API_POST];
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSDictionary *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                showMessageBox(@"未找到该用户，请检查输入是否正确。");
                return;
            }
            showMessageBox(@"提交成功，密码将会随短信发送到您的手机，注意查收。");
            [self.navigationController popViewControllerAnimated:YES];
        }
        @catch (NSException *exception) {
             showMessageBox(@"未找到该用户，请检查输入是否正确。");
        }
        @finally {
            
        }
    }];
    [request setFailedBlock:^{
         showMessageBox(@"未找到该用户，请检查输入是否正确。");
    }];
    [request startAsynchronous];
}
@end
