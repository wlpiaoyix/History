//
//  ReportDetailsViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-4-18.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "ReportDetailsViewController.h"
#import "TableViewHeadCell.h"
#import "SaleCell.h"
#import "ApplicationCell.h"
#import "TrafficReportController.h"
#import "HttpApiCall.h"
#import "UseCell.h"

@interface ReportDetailsViewController ()
{
    NSDictionary *reportdetailDic;
    NSArray *packListArray;
    NSArray *appDetailArray;

    NSString *_phoneNum;
}

@end

@implementation ReportDetailsViewController

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

    [self.reportTableView registerNib:[UINib nibWithNibName:@"TableViewHeadCell" bundle:nil] forCellReuseIdentifier:@"HeadCell"];
    [self.reportTableView registerNib:[UINib nibWithNibName:@"SaleCell" bundle:nil] forCellReuseIdentifier:@"SCell"];
    [self.reportTableView registerNib:[UINib nibWithNibName:@"ApplicationCell" bundle:nil] forCellReuseIdentifier:@"licationCell"];
    [self.reportTableView registerNib:[UINib nibWithNibName:@"UseCell" bundle:nil] forCellReuseIdentifier:@"ucell"];
    [self setReportdetailData];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count=1;
    if (section == 0) {
        if (packListArray.count == 0) {
            count = 0;
        }
        count = [packListArray count];
    }
    else if (section == 1)
    {
        if (appDetailArray.count == 0) {
            count = 0;
        }
        count = [appDetailArray count];
    }
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cellxx;
    NSUInteger index = [indexPath section];
    if (index == 0) {
            SaleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCell"];
            if(!cell)
            {
                cell = [[SaleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCell"];
            }
            NSDictionary *dic = [packListArray objectAtIndex:indexPath.row];
        
            cell.lblName.text = [dic objectForKey:@"userName"];
           [cell setButton:[dic objectForKey:@"productName"]];
        if ([[dic objectForKey:@"payment"] intValue] ==0) {
            cell.lblTime.text = [dic objectForKey:@"payState"];
            cell.lblTime.textColor = [UIColor redColor];
            [cell.lblMoney setHidden:YES];
            [cell.imgMoney setHidden:YES];
        }
        else
        {
            cell.lblTime.text = [[NSDate dateFormateString:[dic objectForKey:@"reportTime"] FormatePattern:nil] getFriendlyTime2];
            NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"payment"]];
            cell.lblMoney.text = str;
        }
            cellxx = cell;

    }
    else if (index == 1)
    {
            ApplicationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"licationCell"];
            if(!cell)
            {
                cell = [[ApplicationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"licationCell"];
            }
            NSDictionary *dic = [appDetailArray objectAtIndex:indexPath.row];
        if ([[dic objectForKey:@"payment"] intValue] ==0) {
            cell.lblTime.text = [dic objectForKey:@"payState"];
            cell.lblTime.textColor = [UIColor redColor];
            [cell.lblMoney setHidden:YES];
            [cell.imgMoney setHidden:YES];
        }
        else
        {
            NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"payment"]];
            cell.lblMoney.text = str;
            
            cell.lblTime.text =[[NSDate dateFormateString:[dic objectForKey:@"reportTime"] FormatePattern:nil] getFriendlyTime2];
            cell.imgMoney.image = [UIImage imageNamed:@"flowmanager_returnmoney.png"];
        }
        cell.lblName.text = [dic objectForKey:@"productName"];
            cell.imgApplication.imageUrl = API_IMAGE_URL_GET2([dic objectForKey:@"icon"]);
            cellxx = cell;
    }
    else
    {
            UseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ucell"];
            if(!cell)
            {
                cell = [[UseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ucell"];
            }

            [cell setData:[reportdetailDic objectForKey:@"achieve"]];
            cellxx = cell;
    }
        return cellxx;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    id celxx ;
    if (section == 0) {
        TableViewHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeadCell"];
        if(!cell)
        {
            cell = [[TableViewHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HeadCell"];
        }
        cell.lblType.text = @"流量销售";
        cell.img.image = [UIImage imageNamed:@"flowmanage_type10.png"];
        celxx = cell;
    }
    else if (section == 1)
    {
        TableViewHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeadCell"];
        if(!cell)
        {
            cell = [[TableViewHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HeadCell"];
        }
        cell.lblType.text = @"流量应用";
        cell.img.image = [UIImage imageNamed:@"flowmanage_type11.png"];
        celxx = cell;
    }
    else if (section == 2)
    {
        TableViewHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeadCell"];
        if(!cell)
        {
            cell = [[TableViewHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HeadCell"];
        }
        cell.lblType.text = @"流量使用(达100M)";
        cell.img.image = [UIImage imageNamed:@"flowmanage_type10.png"];
        celxx = cell;
    }
    return celxx;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightX=30;
    NSUInteger index = [indexPath section];
    if (index == 0 ) {
        heightX = 45;
    }
    if (index == 1) {
        heightX = 65;
    }
    if (index == 2) {
        heightX = 50;
    }
    return heightX;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 18;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)Report:(id)sender {
    [self.navigationController pushViewController:[[TrafficReportController alloc] init] animated:YES];
}
-(void)setPhoneNum:(NSString *)phoneNum
{
    _phoneNum = phoneNum;
}
-(void)setReportdetailData
{
    
    NSString *url = [NSString stringWithFormat:@"/api/traffic/v2/reportdetail/%@/month",_phoneNum];
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"reportdetail_get_data"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^
     {
         @try {
             [request setResponseEncoding:NSUTF8StringEncoding];
             NSString *responseString = [request responseString];
             if ([responseString hasPrefix:@"{\"akmsg"]) {
                 showMessageBox(@"暂无数据！");
                 return;
             }
             NSArray *dic = [responseString JSONValueNewMy];
             
             reportdetailDic = [dic lastObject];
             
             packListArray = [[reportdetailDic objectForKey:@"trafficPack"] objectForKey:@"packList"];
             appDetailArray = [[reportdetailDic objectForKey:@"trafficApp"] objectForKey:@"appDetail"];
             if (reportdetailDic != nil) {
                 self.reportTableView.delegate = self;
                 self.reportTableView.dataSource = self;
                 NSString *str = @"号码:";
                 self.lblphoneNum.text =[str stringByAppendingString:[reportdetailDic objectForKey:@"phoneNum"]];
                 [self.reportTableView reloadData];
             }

         }
         @catch (NSException *exception) {
             //showMessageBox(@"暂无数据！");
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
@end
