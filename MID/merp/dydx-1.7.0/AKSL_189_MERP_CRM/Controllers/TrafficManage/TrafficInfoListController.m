//
//  TrafficInfoListController.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-4-22.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "TrafficInfoListController.h"
#import "TrafficTodayReportCell.h"
#import "HttpApiCall.h"
#import "ReportDetailsViewController.h"

@interface TrafficInfoListController (){
    NSMutableArray * listForData;
     UIColor * borderColorForTable;
    NSString * typeStr;
    NSString * typeenStr;
}

@end

@implementation TrafficInfoListController

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
    borderColorForTable = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    _viewHeaderForTable.layer.borderColor = borderColorForTable.CGColor;
    _viewHeaderForTable.layer.borderWidth = 0.5;
    // Do any additional setup after loading the view from its nib.
    UINib *nib = [UINib nibWithNibName:@"TrafficTodayReportCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"TrafficTodayReportCell"];
    [_ImageForIconType setImage:[UIImage imageNamed:[NSString stringWithFormat:@"flowmanage_type%d.png",_type]]];
    _textForTitle.text = self.title;
    switch (_type) {
        case 10:
             typeStr = @"package";
            typeenStr = @"packageCount";
            break;
        case 11:
            typeStr = @"app";
            typeenStr = @"appCount";
            break;
        case 13:
            typeStr = @"achieve";
            typeenStr = @"achieveConut";
            break;
        default:
            break;
    }
}
-(void)reloadData:(BOOL)isFrist{
    [self getReportDataFromServer:isFrist];
}

-(void)getReportDataFromServer:(BOOL)isFrist{
    
    int pageSize = 15;
    int startindex = 1;
    if (!isFrist) {
        if (listForData.count%pageSize){
            return;
        }else{
            startindex = listForData.count+1;
        }
    }else if(listForData){
        return;
    }
    NSString *url =[NSString stringWithFormat:@"/api/traffic/v2/report/%@/%ld/month/%d/%d" ,typeStr, [ConfigManage getLoginUser].userDataId,startindex,pageSize];
    [self showActivityIndicator];
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"getMonthReportDataFromServer"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
          [self hideActivityIndicator];
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSDictionary *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                return;
            }
            if (isFrist) {
                listForData = [temp valueForKey:@"data"];
            }else{
                [listForData addObjectsFromArray:[temp valueForKey:@"data"]];
            }
            double valuetotal=[[temp valueForKey:@"payMentCount"]doubleValue];
            _textForTotal.text = [NSString stringWithFormat:@"%0.2f",valuetotal];
            [_tableView reloadData];
        }
        @catch (NSException *exception) {
            showAlertBox(@"提示", exception.reason);
            return;
        }
        @finally {
            
        }
    }];
    [request setFailedBlock:^{
          [self hideActivityIndicator];
    }];
    [request startAsynchronous];
}

//Table DataSoucre
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (listForData) {
        return listForData.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return  _viewHeaderForTable;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TrafficTodayReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrafficTodayReportCell"];
    NSDictionary * dic = listForData[indexPath.row];
    cell.layer.borderColor = borderColorForTable.CGColor;
    cell.layer.borderWidth = 0.5;
    
        [cell setData:[dic valueForKey:@"customerPhone"] Type:_type Date:[NSDate dateFormateString:[dic valueForKey:@"reportTime"] FormatePattern:nil] NumForTotal:[[dic valueForKey:typeenStr]intValue] NumForSell:[[dic valueForKey:@"payment"]doubleValue]];
    if (indexPath.row+1 == listForData.count) {
        [self getReportDataFromServer:NO];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = listForData[indexPath.row];
    
    ReportDetailsViewController * view = [[ReportDetailsViewController alloc]initWithNibName:@"ReportDetailsViewController" bundle:nil];
    [view setPhoneNum:[dic valueForKey:@"customerPhone"]];
    [self.pViewController.navigationController pushViewController:view animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
