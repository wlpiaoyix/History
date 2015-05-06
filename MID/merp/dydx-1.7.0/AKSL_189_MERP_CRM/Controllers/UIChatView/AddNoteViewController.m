//
//  AddNoteViewController.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-14.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "AddNoteViewController.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "HttpApiCall.h"

@interface AddNoteViewController ()

@end

@implementation AddNoteViewController
- (IBAction)commitdata:(id)sender {
    if(_textInput.text.length<5){
        showMessageBox(@"您好，通知内容必须大于5个字。");
        return;
    } 
    [self showActivityIndicator];
    NSString *url =@"/api/publicinfo";
    NSString *commitData = _textInput.text;
     commitData =[NSString stringWithFormat:@"{\"names\":\"通知\",\"digest\":null,\"contents\":\"%@\",\"digestPic\":null,\"toUserCodes\":null,\"toUserNum\":null,\"readNum\": null,\"infoType\":{\"id\":70}}",commitData];
    ASIFormDataRequest *requestx = [HttpApiCall requestCallPOST:url Params:[commitData JSONValueNewMy] Logo:@"selldata_commit_toServer"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [self hideActivityIndicator];
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSDictionary *temp = [reArg JSONValueNewMy];
            if (temp) {
                [self goBack:nil];
            }else{
            showMessageBox(@"提交失败，请重新提交数据。");
            }
        }
        @catch (NSException *exception) {
        }
        @finally {
            
        }
    }];
    [request setFailedBlock:^{
        [self hideActivityIndicator];
        showMessageBox(@"提交失败，请重新提交数据。");
    }];
    [request startAsynchronous];
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
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
