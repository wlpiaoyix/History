//
//  TrafficManageViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-4-18.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "TrafficManageViewController.h"
#import "MonthReportedView.h"
#import "MonthSellDataView.h"
#import "UIViewController+MMDrawerController.h"
#import "TrafficTodayReportCell.h"
#import "TrafficInfoQueryViewController.h"
#import "TraffincInfoViewController.h"
#import "HttpApiCall.h"
#import "FlowQueryViewController.h"
#import "TrafficReportController.h"
#import "ReportDetailsViewController.h"

@interface TrafficManageViewController (){
    NSMutableArray * listForData;
    UIColor * borderColorForTable;
    LoginUser * loginUser;
    MonthSellDataView * monthSell;
    MonthReportedView * monthReport;
    BOOL isLoding;
}

@end

@implementation TrafficManageViewController

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
    isLoding = false;
    loginUser = [ConfigManage getLoginUser];
    UINib *nib = [UINib nibWithNibName:@"TrafficTodayReportCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"TrafficTodayReportCell"];
    borderColorForTable = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    // Do any additional setup after loading the view from its nib.
    monthReport = [[MonthReportedView alloc]initWithFrame:CGRectMake(2, 2, 145, 145)];
    monthReport.month=1;
    monthReport.numForReport = 0;
    monthReport.backgroundColor = [UIColor clearColor];
    [_viewForReport addSubview:monthReport];
    monthSell = [[MonthSellDataView alloc]initWithFrame:CGRectMake(15, 15, 120, 120)];
    monthSell.numForTotal = 0;
    monthSell.valueForPercent = 0;
    monthSell.backgroundColor = [UIColor clearColor];
    [_viewForTotal addSubview:monthSell];
    _butToAId.layer.cornerRadius = 9;
    _butToSell.layer.cornerRadius = 9;
    _butToUseFlow.layer.cornerRadius = 9;
    _viewHaderForTable.layer.borderWidth = 0.5;
    _viewHaderForTable.layer.borderColor =borderColorForTable.CGColor;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!isLoding){
        [self getMonthTotalDataFromServer];
        [self getMonthReportDataFromServer];
        [self getReportTodayDataFromServer:YES];
    }
}
///traffic/v2/report/phone/{persontype}/{time}/{startIndex}/{count}
-(void)getReportTodayDataFromServer:(BOOL)isFrist{
    
    int pageSize = 15;
    int startindex = 1;
    if (!isFrist) {
        if (listForData.count%pageSize){
            return;
        }else{
            startindex = listForData.count+1;
        }
    }
    NSString *url =[NSString stringWithFormat:@"/api/traffic/v2/report/phone/self/day/%d/%d" , startindex,pageSize];
    
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"getMonthReportDataFromServer"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        //    [self hideActivityIndicator];
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
        //    [self hideActivityIndicator];
    }];
    [request startAsynchronous];
}

-(void)getMonthReportDataFromServer{
    NSString *url = @"/api/traffic/v2/report/count";
    
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"getMonthReportDataFromServer"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        //    [self hideActivityIndicator];
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSDictionary *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                return;
            }
            monthReport.month = [[temp valueForKey:@"month"]intValue];
            monthReport.numForReport = [[temp valueForKey:@"count"]doubleValue];
            [monthReport replaceData];
            
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
-(void)getMonthTotalDataFromServer{
    NSString *url = [NSString stringWithFormat:@"/api/traffic/v2/payment/%@/month",loginUser.userId];
    
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"getMonthTotalDataFromServer"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        //    [self hideActivityIndicator];
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSDictionary *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                return;
            }
            monthSell.valueForPercent = [[temp valueForKey:@"rank"]doubleValue]*100;
            monthSell.numForTotal = [[temp valueForKey:@"totalPayment"]doubleValue];
            [monthSell replaceData];
           NSArray * arry = [temp valueForKey:@"listPaymentDetail"];
            _textForMonthTrafficSell.text =[NSString stringWithFormat:@"%0.2f", [[arry[0] valueForKey:@"payment"]doubleValue]];
            _textForMonthTrafficApp.text =[NSString stringWithFormat:@"%0.2f", [[arry[1] valueForKey:@"payment"]doubleValue]];
              _textForMonthTrafficUse.text =[NSString stringWithFormat:@"%0.2f", [[arry[2] valueForKey:@"payment"]doubleValue]];
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
    if (listForData) {
        return listForData.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return  _viewHaderForTable;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (listForData&&listForData.count>0) {
        return 25;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   TrafficTodayReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrafficTodayReportCell"];
    NSDictionary * dic = listForData[indexPath.row];
    cell.layer.borderColor = borderColorForTable.CGColor;
    cell.layer.borderWidth = 0.5;
    [cell setData:[dic valueForKey:@"customerPhone"] Date:[NSDate dateFormateString:[dic valueForKey:@"reportTime"] FormatePattern:nil]];
    if (indexPath.row+1 == listForData.count) {
        [self getReportTodayDataFromServer:NO];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = listForData[indexPath.row];
    
    ReportDetailsViewController * view = [[ReportDetailsViewController alloc]initWithNibName:@"ReportDetailsViewController" bundle:nil];
    [view setPhoneNum:[dic valueForKey:@"customerPhone"]];
     [self.mm_drawerController.navigationController pushViewController:view animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)butClickToInfoPage:(id)sender {
    TraffincInfoViewController *view = [[TraffincInfoViewController alloc]initWithNibName:@"TraffincInfoViewController" bundle:nil];
    view.type = ((UIButton *)sender).tag;
    [self.mm_drawerController.navigationController pushViewController:view animated:YES];
}
- (IBAction)topClick:(id)sender {
    [self topButtonClick:sender];
}
- (IBAction)toReport:(id)sender {
    TrafficReportController * view = [[TrafficReportController alloc]initWithNibName:@"TrafficReportController" bundle:nil];
       isLoding=false;
     [self.mm_drawerController.navigationController pushViewController:view animated:YES];
}
- (IBAction)toMonthReport:(id)sender {
    TrafficInfoQueryViewController * infoQuery = [[TrafficInfoQueryViewController alloc]initWithNibName:@"TrafficInfoQueryViewController" bundle:nil];
    infoQuery.title = @"本月上报";
    infoQuery.urlForData =[NSString stringWithFormat:@"all/%ld/month",[ConfigManage getLoginUser].userDataId];
    infoQuery.type = 0;
    infoQuery.isCanToFlier = YES;
    infoQuery.noteForTableTitle = [NSString stringWithFormat:@"%d月上报",monthReport.month];
     [self.mm_drawerController.navigationController pushViewController:infoQuery animated:YES];
}
- (IBAction)toFiler:(id)sender {
    FlowQueryViewController *fqvc = [[FlowQueryViewController alloc] initWithNibName:@"FlowQueryViewController" bundle:nil];
    [self.mm_drawerController.navigationController pushViewController:fqvc animated:YES];
}
@end
