//
//  CodeTemp.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-11.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "CodeTemp.h"
#import "HttpApiCall.h"

@implementation CodeTemp

-(void)net{
    NSString *url = @"/api/products/report/default/default/default";
    
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"get_products_data_main"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
    //    [self hideActivityIndicator];
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSMutableArray *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                showMessageBox(@"暂无数据");
                return;
            }
            
        }
        @catch (NSException *exception) {
            showAlertBox(@"提示", exception.reason);
            return;
        }
        @finally {
            
        }
    }];
    [request setFailedBlock:^{
    //    [self hideActivityIndicator];
    }];
    [request startAsynchronous];
    
}

//Table DataSoucre
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [UITableViewCell new];
    cell.textLabel.text = @"TEST-Name-China";
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
@end
