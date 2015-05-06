//
//  RealCommitDetaileViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 13-12-12.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "RealCommitDetaileViewController.h"
#import "DetailedSellInfoView.h"
#import "HttpApiCall.h"
#import "ASIFormDataRequest.h"

@interface RealCommitDetaileViewController ()

@end

@implementation RealCommitDetaileViewController
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    UINib *nib = [UINib nibWithNibName:@"SingerProductCell" bundle:nil];
    [_tableview registerNib:nib forCellReuseIdentifier:@"SingerProductCell"];
    ///api/user/specifiedrealtimeinfo/{id}
    NSString *url =[NSString stringWithFormat:@"/api/user/specifiedrealtimeinfo/%lli",_ids];
     ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"DISTRICT_INFO_KEY"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSDictionary *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                return;
            }
            listDataForTable = [temp objectForKey:@"data"];
            if(listDataForTable){
                for (int i=0; i<listDataForTable.count; i++) {
                    NSDictionary *dic = [listDataForTable objectAtIndex:i];
                   int value = [[dic objectForKey:@"productSalesVolume"]intValue];
                    if (value==0) {
                        [listDataForTable removeObjectAtIndex:i];
                        i--;
                    }
                }
            }
            [_tableview reloadData];
        }
        @catch (NSException *exception) {
        }
        @finally {
            
        }
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Table DataSoucre
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(listDataForTable)
        return listDataForTable.count;
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SingerProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SingerProductCell"];
    if(cell){
        NSDictionary *dic = [listDataForTable objectAtIndex:indexPath.row];
        cell.labelProductName.text = [dic objectForKey:@"productName"];
        cell.labelValueText.text =[dic objectForKey:@"productSalesVolume"];
    }
    return cell;
}

@end
