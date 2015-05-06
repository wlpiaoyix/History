//
//  ChangeValueForCommitSellViewController.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-12-4.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "ChangeValueForCommitSellViewController.h"
#import "HttpApiCall.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@interface ChangeValueForCommitSellViewController ()

@end

@implementation ChangeValueForCommitSellViewController

-(void)setData:(NSString *)name ID:(int)ids{
    pname = name;
    _ids = ids;
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
    _name.text = pname;
    NSString * numofproductskey = [NSString stringWithFormat:@"products_num_for_commit_data_and_date_%d",_ids];
    NSString * numofproducts =[ConfigManage getConfig:numofproductskey];
    int today = [NSDate new].day;
    _numForSell.text = @"0";
    if(numofproducts){
        NSArray * ar = [numofproducts componentsSeparatedByString:@":"];
        if(today == [[ar objectAtIndex:0]intValue]){
            _numForSell.text = [ar objectAtIndex:1];
        }
    }

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)commit:(id)sender {
    [self showActivityIndicator];
    NSString * commitData = [NSString stringWithFormat:@"[{\"productID\":%d,\"productName\":\"%@\",\"count\":%d}]",_ids,pname,[_numForSell.text intValue]];
    if ([commitData JSONValueNewMy]) {
        NSString *url =@"/api/datareports/batch";
         ASIFormDataRequest *requestx = [HttpApiCall requestCallPOST:url Params:[commitData JSONValueNewMy] Logo:@"selldata_commit_toServer"];
        __weak ASIFormDataRequest *request = requestx;
        [request setCompletionBlock:^{
            [request setResponseEncoding:NSUTF8StringEncoding];
            NSString *reArg = [request responseString];
            @try {
                NSDictionary * temp = [reArg JSONValueNewMy];
                if (temp) {
                    NSString * data = [temp objectForKey:@"akmsg:"];
                    if ([data isEqualToString:@"批量增加成功"]) {
                        int today = [NSDate new].day;
                        NSString * numofproductskey = [NSString stringWithFormat:@"products_num_for_commit_data_and_date_%d",_ids];
                        NSString * numofproducts =[NSString stringWithFormat:@"%d:%@",today,_numForSell.text];
                        [ConfigManage setConfig:numofproductskey Value:numofproducts];
                        showMessageBox(@"销量上报成功!");
                        [self goback:nil];
                    }else if([data isEqualToString:@"0"]){
                     showMessageBox(@"渠道经理已经确认，今天无法上报数据。");
                    [self goback:nil];
                    }else{
                        showMessageBox(@"提交失败，请重新提交数据。");
                    }

                }
            }
            @catch (NSException *exception) {
                showMessageBox(@"提交失败，请重新提交数据。");
            }
            @finally {
                 [self hideActivityIndicator];
            }
           
           
           
                }];
        [request setFailedBlock:^{
            [self hideActivityIndicator];
            showMessageBox(@"提交失败，请重新提交数据。");
        }];
        [request startAsynchronous];
    }

}
- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
