//
//  TrafficInfoQueryViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-4-25.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "TrafficInfoQueryViewController.h"
#import "TrafficQueryCell.h"
#import "HttpApiCall.h"
#import "ReportDetailsViewController.h"
#import "TrafficQueryStaffCell.h"
#import "FlowQueryViewController.h"

@interface TrafficInfoQueryViewController (){
NSMutableArray * listForData;
    IBOutlet UIView *viewHeaderForTable;
    __weak IBOutlet UITableView *tableviewForData;
    UIColor * borderColorForTable;
    __weak IBOutlet UILabel *textForTotal;
    __weak IBOutlet UILabel *textForTitle;
    __weak IBOutlet UILabel *textForNoteTitle;
}
@property (weak, nonatomic) IBOutlet UIButton *butToFiler;

@end

@implementation TrafficInfoQueryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isCanToFlier = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!_isCanToFlier) {
        _butToFiler.hidden = YES;
    }
    textForTitle.text = self.title;
    textForNoteTitle.text = _noteForTableTitle;
    borderColorForTable = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    viewHeaderForTable.layer.borderColor = borderColorForTable.CGColor;
    viewHeaderForTable.layer.borderWidth = 0.5;
    UINib *nib = [UINib nibWithNibName:@"TrafficQueryCell" bundle:nil];
    [tableviewForData registerNib:nib forCellReuseIdentifier:@"TrafficQueryCell"];
    nib = [UINib nibWithNibName:@"TrafficQueryStaffCell" bundle:nil];
    [tableviewForData registerNib:nib forCellReuseIdentifier:@"TrafficQueryStaffCell"];
    
    [self getReportDataFromServer:YES];
    // Do any additional setup after loading the view from its nib.
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
    NSString *url =[NSString stringWithFormat:@"/api/traffic/v2/report/%@/%d/%d" ,_urlForData, startindex,pageSize];
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
            textForTotal.text = [NSString stringWithFormat:@"%0.2f",valuetotal];
            [ tableviewForData reloadData];
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
    return  viewHeaderForTable;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_type==0) {
        TrafficQueryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrafficQueryCell"];
        NSDictionary * dic = listForData[indexPath.row];
        cell.layer.borderColor = borderColorForTable.CGColor;
        cell.layer.borderWidth = 0.5;
        
        [cell setData:[dic valueForKey:@"customerPhone"]   Date:[NSDate dateFormateString:[dic valueForKey:@"reportTime"] FormatePattern:nil] AppCount:[[dic valueForKey:@"appCount"]intValue] PackCount:[[dic valueForKey:@"packageCount"]intValue] NumForSell:[[dic valueForKey:@"payment"]doubleValue]];//:[[dic valueForKey:typeenStr]intValue] NumForSell:[[dic valueForKey:@"payment"]doubleValue]];
        if (indexPath.row+1 == listForData.count) {
            [self getReportDataFromServer:NO];
        }
        return cell;

    }
    if (_type==1) {
        TrafficQueryStaffCell * cell =[tableView dequeueReusableCellWithIdentifier:@"TrafficQueryStaffCell"];
        NSDictionary * dic = listForData[indexPath.row];
        cell.layer.borderColor = borderColorForTable.CGColor;
        cell.layer.borderWidth = 0.5;
        [cell setData:[dic valueForKey:@"name"] AppCount:[[dic valueForKey:@"appCount"]intValue] PackCount:[[dic valueForKey:@"packageCount"]intValue] UseCount:[[dic valueForKey:@"achieveCount"]intValue] NumForSell:[[dic valueForKey:@"payment"]doubleValue]];
        if (indexPath.row+1 == listForData.count) {
            [self getReportDataFromServer:NO];
        }
        return cell;
    }
    return [UITableViewCell new];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_type == 0) {
        NSDictionary * dic = listForData[indexPath.row];
        
        ReportDetailsViewController * view = [[ReportDetailsViewController alloc]initWithNibName:@"ReportDetailsViewController" bundle:nil];
        [view setPhoneNum:[dic valueForKey:@"customerPhone"]];
        [self.navigationController pushViewController:view animated:YES];
    }
   
    
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)toFlier:(id)sender {
    FlowQueryViewController *fqvc = [[FlowQueryViewController alloc] initWithNibName:@"FlowQueryViewController" bundle:nil];
    [self.navigationController pushViewController:fqvc animated:YES];
}

@end
