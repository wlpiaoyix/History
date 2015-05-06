//
//  FlowQueryRestViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-2-24.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "FlowQueryRestViewController.h"
#import "HttpApiCall.h"
#import "UIFlowUploadCell.h"
#import "FlowQuerySubCell.h"

@interface FlowQueryRestViewController ()

@end

@implementation FlowQueryRestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setUrlForQuery:(NSString *)url{
    urlForQueryFlow = url;
}

-(void)setTimeString:(NSString *)str{
    timeString = str;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCornerRadiusAndBorder:_TopView];
    [self setCornerRadiusAndBorder:_dataTableView];
    _textTimeString.text = timeString;
    if(_selectPepleType==2){
       
        CGRect frame = _dataTableView.frame;
        frame.size.height += 121;
        frame.origin.y -= 121;
        _dataTableView.frame = frame;
        
        frame = _TopView.frame;
        frame.size.height -= 121;
        _TopView.frame = frame;
    }
    [self getDataForServer];
}
-(void)getDataForServer{
    [self showActivityIndicator];
    NSString *url = urlForQueryFlow;
    
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"get_FlowQuery_data_main"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
         [self hideActivityIndicator];
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSMutableArray *temp = [reArg JSONValueNewMy];
            NSString * status =[temp valueForKey:@"status"];
            if(temp == nil|| [status isEqualToString:@"failure"]){
                
                return;
            }
            if ([ConfigManage getLoginUser].roelId==6||_selectPepleType==1) {
                temp = [temp valueForKey:@"data"];
                
                _textFirstDayActiveTotalNum.text = [NSString stringWithFormat:@"%ld",[[temp valueForKey:@"firstDayActiveTotalNum"]longValue]];
                _textTrafficAppTotalNum.text = [NSString stringWithFormat:@"%ld",[[temp valueForKey:@"trafficAppTotalNum"]longValue]];
                _textTrafficPackTotalNum.text = [NSString stringWithFormat:@"%ld",[[temp valueForKey:@"trafficPackTotalNum"]longValue]];
                _textTotalPayment.text =[NSString stringWithFormat:@"%.2f",[[temp valueForKey:@"totalPayment"]doubleValue]];
                listForData = [temp valueForKey:@"customerData"];
                UINib *nib = [UINib nibWithNibName:@"UIFlowUploadCell" bundle:nil];
                [_dataTableView registerNib:nib forCellReuseIdentifier:@"UIFlowUploadCell"];
                [_dataTableView reloadData];
            }else if(_selectPepleType==2){
             //如果是店长查看自己店员成绩
                listForData = [temp valueForKey:@"data"];
                UINib *nib = [UINib nibWithNibName:@"FlowQuerySubCell" bundle:nil];
                [_dataTableView registerNib:nib forCellReuseIdentifier:@"UIFlowUploadCell"];
                [_dataTableView reloadData];
            }else if(_selectPepleType==3){
            
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
          [self hideActivityIndicator];
    }];
    [request startAsynchronous];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Table DataSoucre
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (listForData) {
        return listForData.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
 return @"上报记录";
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([ConfigManage getLoginUser].roelId==6||_selectPepleType==1) {
    UIFlowUploadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UIFlowUploadCell"];
    if (cell) {
        [cell setData:listForData[indexPath.row]];
       return cell;
    }
    }else if(_selectPepleType==2){
    FlowQuerySubCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UIFlowUploadCell"];
        
        if (cell) {
            [cell setData:listForData[indexPath.row]];
            return cell;
        }
    }
    return [[UITableViewCell alloc]init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
}
- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
