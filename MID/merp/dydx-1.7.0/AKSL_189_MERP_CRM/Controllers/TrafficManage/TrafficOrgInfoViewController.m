//
//  TrafficOrgInfoViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-5-16.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "TrafficOrgInfoViewController.h"
#import "TrafficSummaryCell.h"
#import "HttpApiCall.h"
#import "UIViewController+MMDrawerController.h"
#import "MJRefresh.h"
#import "TrafficManageQueryViewController.h"


@interface TrafficOrgInfoViewController (){
    NSMutableArray *listForData;
    BOOL isQueryRest;
    NSString * timeForQuery;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@end

@implementation TrafficOrgInfoViewController


-(void)setQueryDate:(NSString *)queryDate{
    isQueryRest = YES;
    timeForQuery = queryDate;
    if (listForData) {
        [listForData removeAllObjects];
        listForData = nil;
    }
    [self setData:YES];
}

static TrafficOrgInfoViewController * mainpage;

+(id) getNewInstance{
    
    if (!mainpage) {
        mainpage = [[TrafficOrgInfoViewController alloc] initWithNibName:@"TrafficOrgInfoViewController" bundle:nil];
        
    }
    return mainpage;
    
}
+(void)newInstance{
    if(mainpage){
        [mainpage removeFromParentViewController];
        mainpage = nil;
    }
    mainpage = [[TrafficOrgInfoViewController alloc] initWithNibName:@"TrafficOrgInfoViewController" bundle:nil];
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
    UINib *nib = [UINib nibWithNibName:@"TrafficSummaryCell" bundle:nil];
    [_tableview registerNib:nib forCellReuseIdentifier:@"summaryCell"];
        timeForQuery = @"day";
    isQueryRest = false;
    [self addFooter];
    [self addHeader];
}
- (void)addFooter
{
    __unsafe_unretained TrafficOrgInfoViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableview;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [vc setData:NO];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:1.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    _footer = footer;
}

- (void)addHeader
{
    __unsafe_unretained TrafficOrgInfoViewController *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableview;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        if (listForData) {
            [listForData removeAllObjects];
            listForData = nil;
        }
        [vc setData:YES];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:1.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
                NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
    [header beginRefreshing];
    _header = header;
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
   // [self.tableview reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}
//Table DataSoucre
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (listForData) {
        return listForData.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 103;
}
 
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TrafficSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"summaryCell"];
    NSDictionary * dic = listForData[indexPath.row];
 
    [cell setData:[dic valueForKey:@"name"] Pnum:[[dic valueForKey:@"pnum"]intValue] Pack:[[dic valueForKey:@"pack"]intValue] App:[[dic valueForKey:@"app"]intValue] Useage:[[dic valueForKey:@"usage"]intValue] Payment:[[dic valueForKey:@"payment"]doubleValue]];
    return cell;
}

-(void)setData:(BOOL)isFrist
{
    int pageSize = 10;
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

    NSString *url = [NSString stringWithFormat:@"/api/traffic/v2/collect/%@/%d/%d",timeForQuery,startindex,pageSize];
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"collect_get_data"];
    __weak ASIFormDataRequest *request = requestx;
    [self showActivityIndicator];
    [request setCompletionBlock:^
     {
             [self hideActivityIndicator];
             [request setResponseEncoding:NSUTF8StringEncoding];
             NSString *reArg = [request responseString];
             @try {
                 NSDictionary *temp = [reArg JSONValueNewMy];
                 if(temp == nil){
                     return;
                 }
                 if (isFrist) {
                     listForData = [temp valueForKey:@"collection"];
                     [_tableview setContentOffset:CGPointMake(0, 0) animated:YES];
                 }else{
                     [listForData addObjectsFromArray:[temp valueForKey:@"collection"]];
                 }
                 NSDictionary * dicSum = [temp valueForKey:@"sum"];
                 _textForTitle.text = [dicSum valueForKey:@"name"];
                 _textForPack.text = [[dicSum valueForKey:@"pack"]stringValue];
                 _textForpnum.text = [[dicSum valueForKey:@"pnum"]stringValue];
                 _textFroApp.text = [[dicSum valueForKey:@"app"]stringValue];
                 _textForUseage.text = [[dicSum valueForKey:@"usage"]stringValue];
                 _textForPayment.text = [NSString stringWithFormat:@"%.2f",[[dicSum valueForKey:@"payment"]doubleValue]];
                 [_tableview reloadData];
         }
         @catch (NSException *exception) {
             showMessageBox(@"暂无数据！");
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
- (IBAction)toSelect:(id)sender {
    TrafficManageQueryViewController * view = [[TrafficManageQueryViewController alloc]initWithNibName:@"TrafficManageQueryViewController" bundle:nil];
    [self.mm_drawerController.navigationController pushViewController:view animated:YES];
}
- (IBAction)topButtonClickM:(id)sender {
    
 [self topButtonClick:sender];
    
}

@end
