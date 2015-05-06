//
//  CommitDataViewController.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-18.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "CommitDataViewController.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "HttpApiCall.h"
#import "SelectReportViewController.h"

@interface CommitDataViewController ()

@end

@implementation CommitDataViewController

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
    [self setCornerRadiusAndBorder:_textForsms];
    //api/sms/newsummary
    LoginUser * loginuser = [ConfigManage getLoginUser];
    [self showActivityIndicator];
   NSString* url = @"/api/sms/newsummary";
        ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"selldata_commit_summary"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSDictionary * temp = [reArg JSONValueNewMy];
            if(temp){
                _textForsms.text=[temp objectForKey:@"contents"];
                [ConfigManage setConfig:[@"today_commit_text_ok_" stringByAppendingString:loginuser.userId]  Value:[NSString stringWithFormat:@"%d",[NSDate new].day]];
            }
            [self hideActivityIndicator];
            
        }
        @catch (NSException *exception) {
            showMessageBox(@"没有汇总数据，请稍后在上报汇总。");
        }
        @finally {
            
        }
    }];
    [request setFailedBlock:^{
        [self hideActivityIndicator];
        showMessageBox(@"没有汇总数据，请稍后在上报汇总。");
    }];
    [request startAsynchronous];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)copyTo:(id)sender {
    
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:_textForsms.text];
    showMessageBox(@"复制成功！");
    
}

@end
