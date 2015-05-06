//
//  dydxTrafficManagementViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-8-1.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "dydxTrafficManagementViewController.h"
#import "dydxTrafficManageCell.h"
#import "zeroApplicationViewController.h"
#import "TrafficManageQueryViewController.h"
#import "HttpApiCall.h"
#import "TrafficInfoQueryViewController.h"
#import "MJRefresh.h"
#import "UIViewController+MMDrawerController.h"
#import "SVPullToRefresh.h"

@interface dydxTrafficManagementViewController ()
{
    NSDictionary *dataDic;
    NSMutableArray *_orgArray;
    MJRefreshFooterView *_footer;
    NSMutableArray *dataArray;
    long _ogrID;
    BOOL falog;
    NSString *_Date;
}

@end

@implementation dydxTrafficManagementViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil :(BOOL)_falog
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    falog = _falog;
    _ogrID = -1;
        _Date = @"default";
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        falog = YES;
        _ogrID = -1;
        _Date = @"default";
    }
    return self;
}
-(void)setOrgId:(long)_orgId
{
    _ogrID = _orgId;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    _orgArray = [NSMutableArray new];
    dataArray = [NSMutableArray new];
    //[self setCornerRadiusAndBorder:self.tableData];
    [self setCornerRadiusAndBorder:self.huizongView];
    
    self.tableData.dataSource = self;
    self.tableData.delegate = self;
    if (!falog) {
       [self.back setImage:[UIImage imageNamed:@"icon_w_back.png"] forState:UIControlStateNormal];
        //self.lblTitle.text = _title;
        if ([_Date isEqualToString:@"default"]) {
            self.lblDate.text = [NSDate dateFormateDate:[NSDate date] FormatePattern:@"yyyy.MM.dd"];
        }
        else
        {
        NSArray *dateArray = [_Date componentsSeparatedByString:@"-"];
        NSString *startDate = [dateArray objectAtIndex:0];
        NSString *endDate = [dateArray objectAtIndex:1];


        if ([startDate  isEqualToString:endDate ]) {
            self.lblDate.text = [NSString stringWithFormat:@"%@.%@.%@",[endDate substringWithRange:NSMakeRange(0, 4)],[endDate substringWithRange:NSMakeRange(4, 2)],[endDate substringWithRange:NSMakeRange(6, 2)]];
        }
        else
        {
            self.lblDate.text = [NSString stringWithFormat:@"%@.%@-%@.%@",[startDate substringWithRange:NSMakeRange(4, 2)],[startDate substringWithRange:NSMakeRange(6, 2)],[endDate substringWithRange:NSMakeRange(4, 2)],[endDate substringWithRange:NSMakeRange(6, 2)]];
        }
        }
        
    }
    
    UINib *nib = [UINib nibWithNibName:@"dydxTrafficManageCell" bundle:nil];
    [self.tableData registerNib:nib forCellReuseIdentifier:@"dydxtraffic"];
    [self setData:_ogrID :_Date :NO];
    // Do any additional setup after loading the view from its nib.
    
    [self addFooter];
}
- (void)addFooter
{
    __unsafe_unretained dydxTrafficManagementViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableData;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [vc setData:_ogrID :_Date :YES];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:1.0];
    };
    _footer = footer;
}
- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.tableData reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}
-(void)setData:(NSInteger)orgId :(NSString *)date : (BOOL)isAdd
{
    [self showActivityIndicator];
    self.lblTitle.text = @"";
    self.lblUserCount.text = @"";
    self.lblPakageCount.text = @"";
    self.lblPakagePayment.text = @"";
    self.lblAppPayment.text = @"";
    self.lblAppCount.text = @"";
    int start = 1;
    int count = 10;
    if (!isAdd) {
        [dataArray removeAllObjects];
    }
    if ([dataArray count] !=0) {
        start = dataArray.count+1;
    }
    NSString *url = [NSString stringWithFormat:@"/api/traffic/v2/statistics/%li/%@/%d/%d",_ogrID,_Date,start,count];
    ASIFormDataRequest *request = [HttpApiCall requestCallGET:url Params:nil Logo:@"pakage_data"];
    __weak ASIFormDataRequest *request1 = request;
    [request1 setCompletionBlock:^{
        [self hideActivityIndicator];
        @try {
            [request1 setResponseEncoding:NSUTF8StringEncoding];
            NSString *str = [request1 responseString];
            
            NSDictionary *dics = [str JSONValueNewMy];
            if (!dics) {
                showMessageBox(@"暂无数据");
                return;
            }
            dataDic = dics;
            if (!isAdd) {
                dataArray = [dataDic objectForKey:@"data"];
            }
            else
            {
                [dataArray addObjectsFromArray:[dataDic objectForKey:@"data"]];
            }
            
            NSDictionary *dic = [dataArray objectAtIndex:0];
            //if (falog) {
                self.lblTitle.text = [dataDic objectForKey:@"title"];
            //}
            if ([[dataDic objectForKey:@"title"] isEqualToString:@""]) {
                self.lblTitle.text = @"流量经营";
            }
            self.lblHuiZong.text =[[dataArray firstObject] objectForKey:@"name"];
            if ([[[dataArray firstObject] objectForKey:@"name"] length] >2) {
                [self.lblDate setHidden:YES];
            }
            NSArray *dateArray = [[dataDic objectForKey:@"time"] componentsSeparatedByString:@"-"];
            NSString *startDate = [dateArray objectAtIndex:0];
            NSString *endDate = [dateArray objectAtIndex:1];
            
            
            if ([startDate  isEqualToString:endDate ]) {
                self.lblDate.text = [NSString stringWithFormat:@"%@.%@.%@",[endDate substringWithRange:NSMakeRange(0, 4)],[endDate substringWithRange:NSMakeRange(4, 2)],[endDate substringWithRange:NSMakeRange(6, 2)]];
            }
            else
            {
                self.lblDate.text = [NSString stringWithFormat:@"%@.%@-%@.%@",[startDate substringWithRange:NSMakeRange(4, 2)],[startDate substringWithRange:NSMakeRange(6, 2)],[endDate substringWithRange:NSMakeRange(4, 2)],[endDate substringWithRange:NSMakeRange(6, 2)]];
            }
            
            self.lblUserCount.text = [dic objectForKey:@"userCount"];
            self.lblPakageCount.text = [[dic objectForKey:@"pakageCount"] stringValue];
            self.lblPakagePayment.text = [[dic objectForKey:@"pakagePayment"] stringValue];
            self.lblAppPayment.text = [[dic objectForKey:@"appPayment"] stringValue];
            self.lblAppCount.text = [[dic objectForKey:@"appCount"] stringValue];
//            if (orgId == 1) {
//                [self.back setImage:[UIImage imageNamed:@"icon_w_menu.png"] forState:UIControlStateNormal];
//            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        [self.tableData reloadData];
    }];
    [request1 setFailedBlock:^{
        [self hideActivityIndicator];
    }];
    [request1 startAsynchronous];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([dataArray count] == 0) {
        return 0;
    }
    else
    {
    return [dataArray count]-1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"dydxtraffic";
    dydxTrafficManageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[dydxTrafficManageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
   cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell setdata:[dataArray objectAtIndex:indexPath.row+1]];
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 162;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[dataDic objectForKey:@"isOrg"] intValue] == 1) {
//        [_orgArray addObject:[dataDic objectForKey:@"orgId"]];
//        [self.back setImage:[UIImage imageNamed:@"icon_w_back.png"] forState:UIControlStateNormal];
        long orgId = [[[dataArray objectAtIndex:indexPath.row+1] objectForKey:@"id"] intValue];
//        _ogrID = orgId;
//        [self setData:orgId :[dataDic objectForKey:@"time"] :NO];
        dydxTrafficManagementViewController *dydx = [[dydxTrafficManagementViewController alloc] initWithNibName:@"dydxTrafficManagementViewController" bundle:nil :NO];
        [dydx setOrgId:orgId];
        [dydx setDate:_Date];
        if (!falog) {
            [self.navigationController pushViewController:dydx animated:YES];
        }
        else
        {
            [self.mm_drawerController.navigationController pushViewController:dydx animated:YES];
        }
        
    }
    else
    {
        TrafficInfoQueryViewController * trafficInfo = [[TrafficInfoQueryViewController alloc]initWithNibName:@"TrafficInfoQueryViewController" bundle:nil];
        trafficInfo.title = [[dataArray objectAtIndex:indexPath.row+1] objectForKey:@"name"];
        NSString * dateString = [@"default" isEqualToString:_Date]?@"month":_Date;
        trafficInfo.urlForData =[NSString stringWithFormat:@"all/%d/%@",[[[dataArray objectAtIndex:indexPath.row+1] objectForKey:@"id"] intValue],dateString];
        trafficInfo.noteForTableTitle = [[dataDic objectForKey:@"time"] stringByAppendingString:@"上报"];
        trafficInfo.type = 0;
        trafficInfo.isCanToFlier = NO;
        [self.navigationController pushViewController:trafficInfo animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)zeroApplication:(id)sender {
    
    zeroApplicationViewController *zero = [[zeroApplicationViewController alloc] initWithNibName:@"zeroApplicationViewController" bundle:nil];
    [zero setOrgOrTime:[[dataDic objectForKey:@"orgId"] intValue] :_Date :@"零流量应用营业员"];
    if (!falog) {
        [self.navigationController pushViewController:zero animated:YES];
    }
    else
    {
        [self.mm_drawerController.navigationController pushViewController:zero animated:YES];
    }
}

- (IBAction)zeroSale:(id)sender {
    
    zeroApplicationViewController *zero = [[zeroApplicationViewController alloc] initWithNibName:@"zeroApplicationViewController" bundle:nil];
    [zero setOrgOrTime:[[dataDic objectForKey:@"orgId"] intValue] :_Date :@"零流量销售营业员"];
    if (!falog) {
        [self.navigationController pushViewController:zero animated:YES];
    }
    else
    {
        [self.mm_drawerController.navigationController pushViewController:zero animated:YES];
    }
}

- (IBAction)Screening:(id)sender {
    TrafficManageQueryViewController *traffic = [[TrafficManageQueryViewController alloc] init];
    [traffic setRetureMethods:^(NSString *date,NSDate *startDate,NSDate *endDate)
     {
         _Date = date;
         [self setData:[[dataDic objectForKey:@"orgId"] intValue] :date :NO];
         if (startDate.timeIntervalSince1970 == endDate.timeIntervalSince1970) {
             self.lblDate.text = [NSDate dateFormateDate:startDate FormatePattern:@"yyyy.MM.dd"];
         }
         else
         {
         self.lblDate.text = [NSString stringWithFormat:@"%@-%@",[NSDate dateFormateDate:startDate FormatePattern:@"MM.dd"],[NSDate dateFormateDate:endDate FormatePattern:@"MM.dd"]];
         }
     }];
    [self.navigationController pushViewController:traffic animated:YES];
}

-(void)setDate:(NSString *)date{
    _Date = date;
}
- (IBAction)backUpInslde:(id)sender {
    if (falog/*[[dataDic objectForKey:@"orgId"] intValue] == 1 || !dataDic*/) {
        [self topButtonClick:sender];
    }
    else
    {
        //int orgId = [[dataDic objectForKey:@"orgId"] intValue];
//        [self setData:[[_orgArray lastObject] intValue] :[dataDic objectForKey:@"time"] :NO];
//        [_orgArray removeLastObject];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
