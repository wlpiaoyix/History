//
//  SystemSetsCellsUserInfoController.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-28.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "SystemSetsCellsUserInfoController.h"
#import "SystemSetViewBottom.h"
#import "UIViewController+MMDrawerController.h"
#import "NSObject+SBJSON.h"
#import "ASIFormDataRequest.h"
#import "HttpApiCall.h"
@interface SystemSetsCellsUserInfoController ()

@end

@implementation SystemSetsCellsUserInfoController

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
    self.viewBottom = [SystemSetViewBottom init];
    [self cornerRadius:self.viewValues];
    self.lableParam.text = self._param;
    self.textFieldValues.text = self._values;
    [((SystemSetViewBottom*)self.viewBottom).buttonCancle setImage:[UIImage imageNamed:@"icon_w_back.png"] forState:UIControlStateNormal];
    [((SystemSetViewBottom*)self.viewBottom).buttonConfirm setImage:[UIImage imageNamed:@"icon_w_ok.png"] forState:UIControlStateNormal];
    [((SystemSetViewBottom*)self.viewBottom).buttonCancle addTarget:self action:@selector(clickButtonCancle:) forControlEvents:UIControlEventTouchUpInside];
    [((SystemSetViewBottom*)self.viewBottom).buttonConfirm addTarget:self action:@selector(clickButtonConfirm:) forControlEvents:UIControlEventTouchUpInside];
    ((SystemSetViewBottom*)self.viewBottom).lableCurrentName.text = self._titles;
    [self.view addSubview:self.viewBottom];
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGRect r = self.viewBottom.frame;
    r.origin.y = 0;
    self.viewBottom.frame = r;
}
-(void) clickButtonCancle:(id) sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) clickButtonConfirm:(id) sender{
    if(!self.textFieldValues.text||self.textFieldValues.text==nil||[@"" isEqual:self.textFieldValues.text]){
        [self showMessage:@"请输入你的信息！"];
        return;
    }
    [self.textFieldValues resignFirstResponder];
    NSMutableDictionary *json = [[[ConfigManage getConfig:HTTP_API_JSON_PERSONINFO] JSONValueNewMy] objectForKey:@"user"];
    switch (self.flag) {
        case 1:{
            [json setValue:self.textFieldValues.text forKey:@"userName"];
        }
            break;
        case 2:{
            [json setValue:self.textFieldValues.text forKey:@"mobilePhone"];
        }
            break;
    }
    [self commitData:json];
    
}
-(void) cornerRadius:(UIView*) v{
    v.layer.masksToBounds = YES;
    v.layer.cornerRadius = 5;
    v.layer.borderWidth = 0.5;
    v.layer.borderColor = [[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor];
}

-(void) showMessage:(NSString*) msg{
    UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"温馨提示" message: msg  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [alert release];
}
-(void) commitData:(NSDictionary*) json{
    ASIFormDataRequest *request = [HttpApiCall requestCallPUT:@"/api/user" Params:json Logo:@"edit_user_sex"];
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            id temp = [reArg JSONValueNewMy];
            NSDictionary *json = [[ConfigManage getConfig:HTTP_API_JSON_PERSONINFO] JSONValueNewMy];
            [json setValue:temp forKey:@"user"];
            [ConfigManage setConfig:HTTP_API_JSON_PERSONINFO Value:[json JSONRepresentation]];
            [ConfigManage updateLoginUser];
            [ConfigManage updateOrganization];
            if(temp){
//                [self showMessage:@"修改成功"];
                self.target.lableValue.text = self.textFieldValues.text;
                [self.navigationController popViewControllerAnimated:YES];
            }else{
//                [self showMessage:@"修改失败！"];
            }
        }
        @catch (NSException *exception) {
            [self showMessage:@"出现未知错误！"];
        }
        @finally {
            [self hideActivityIndicator];
        }
        
    }];
    [request setFailedBlock:^{
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"错误" message: @"服务器没有响应！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [self hideActivityIndicator];
    }];
    [self showActivityIndicator];
    [request startAsynchronous];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.viewBottom release];
    [self.viewValues release];
    [self.lableParam release];
    [self.textFieldValues release];
}

@end
