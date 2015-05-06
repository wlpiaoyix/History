//
//  zeroApplicationViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-8-1.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "zeroApplicationViewController.h"
#import "zeroApplicationCell.h"
#import "HttpApiCall.h"
#import "SVPullToRefresh.h"
#import "MJRefresh.h"
#import "UIViewController+MMDrawerController.h"

@interface zeroApplicationViewController ()
{
    long _orgId;
    NSString *_date;
    NSString *_title;
    NSMutableArray *dataArray;
    MJRefreshFooterView *_footer;

}

@end

@implementation zeroApplicationViewController

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
    dataArray = [NSMutableArray new];
    self.lblTongji.text = @"";
    self.tableData.dataSource = self;
    self.tableData.delegate = self;
    UINib *nib = [UINib nibWithNibName:@"zeroApplicationCell" bundle:nil];
    [self.tableData registerNib:nib forCellReuseIdentifier:@"zeroapplicationCell"];

}
-(void)viewDidAppear:(BOOL)animated
{
    self.lblTitle.text = _title;
    if ([_title isEqualToString:@"零流量销售营业员"]) {
        [self setZeroData:_orgId :_date :NO];
//        [self.tableData addPullToRefreshWithActionHandler:
//         ^{
//             [self setZeroData:_orgId :_date :NO];
//             [self.tableData reloadData];
//             [self.tableData.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
//             
//         }];
        [self addFooterA];
    }
    else if ([_title isEqualToString:@"零流量应用营业员"])
    {
        [self setAppData:_orgId :_date :NO];
//        [self.tableData addPullToRefreshWithActionHandler:
//         ^{
//             [self setZeroData:_orgId :_date :NO];
//             [self.tableData reloadData];
//             [self.tableData.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
//             
//         }];
        [self addFooterB];
    }
    else
    {
        return;
    }

}
- (void)addFooterA
{
    __unsafe_unretained zeroApplicationViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableData;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 增加10条数据

        [vc setZeroData:_orgId :_date :YES];
        [self.tableData reloadData];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
    };
    _footer = footer;
    
}
- (void)addFooterB
{
    __unsafe_unretained zeroApplicationViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableData;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 增加10条数据
        
        [vc setZeroData:_orgId :_date :YES];
        [self.tableData reloadData];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([dataArray count] ==0) {
        return 0;
    }
    else
    {
        return [dataArray count];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    zeroApplicationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zeroapplicationCell"];
    cell.heardImg.layer.cornerRadius = 25;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell setdata:[dataArray objectAtIndex:indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}
-(void)setOrgOrTime:(int)orgId :(NSString *)time :(NSString *)title
{
    _orgId = orgId;
    _date = time;
    _title = title;
}
-(void)setZeroData:(int)orgId :(NSString *)time :(BOOL)isAdd
{
    [self showActivityIndicator];
    int start = 1;
    int count = 10;
    if([dataArray count] != 0)
    {
            start = dataArray.count+1;
    }

    NSString *url =[NSString stringWithFormat:@"/api/traffic/v2/zero/package/%d/%@/%d/%d",orgId,time,start,count] ;
    ASIFormDataRequest *request = [HttpApiCall requestCallGET:url Params:nil Logo:@"message_data"];
    __weak ASIFormDataRequest *request1 = request;
    [request1 setCompletionBlock:^{
        [self hideActivityIndicator];
        @try {
            [request1 setResponseEncoding:NSUTF8StringEncoding];
            NSString *str = [request1 responseString];
            
            NSDictionary *dic = [str JSONValueNewMy];
            if (!dic) {
                showMessageBox(@"暂无数据！");
                return;
            }
            int count = [[dic objectForKey:@"totalCount"] intValue];
            if (!isAdd) {
                dataArray = [dic objectForKey:@"data"];
            }
            else
            {
                [dataArray addObjectsFromArray:[dic objectForKey:@"data"]];
            }
            if ([_date isEqualToString:@"default"]) {
                self.lblTongji.text = [NSString stringWithFormat:@"本月零流量销售营业员总数 %d 人",count];
            }
            else
            {
                NSArray *dateArray = [_date componentsSeparatedByString:@"-"];
                NSString *startDate = [dateArray objectAtIndex:0];
                NSString *endDate = [dateArray objectAtIndex:1];
                if ([[startDate substringWithRange:NSMakeRange(4, 2)] isEqualToString:[endDate substringWithRange:NSMakeRange(4, 2)]]) {
                    self.lblTongji.text = [NSString stringWithFormat:@"本月零流量销售营业员总数 %d 人",count];
                }
                else
                {
                self.lblTongji.text = [NSString stringWithFormat:@"%@至%@月零流量销售营业员总数 %d 人",[startDate substringWithRange:NSMakeRange(4, 2)],[endDate substringWithRange:NSMakeRange(4, 2)],count];
                }
            }
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
-(void)setAppData:(int)orgId :(NSString *)time :(BOOL) isAdd
{
    [self showActivityIndicator];
    int start = 1;
    int count = 10;
    if([dataArray count] != 0)
    {
        
        start = dataArray.count+1;
        
    }
    NSString *url = [NSString stringWithFormat:@"/api/traffic/v2/zero/app/%d/%@/%d/%d",orgId,time,start,count];
    ASIFormDataRequest *request = [HttpApiCall requestCallGET:url Params:nil Logo:@"message_data"];
    __weak ASIFormDataRequest *request1 = request;
    [request1 setCompletionBlock:^{
        [self hideActivityIndicator];
        @try {
            [request1 setResponseEncoding:NSUTF8StringEncoding];
            NSString *str = [request1 responseString];
            
            NSDictionary *dic = [str JSONValueNewMy];
            if (!dic) {
                showMessageBox(@"暂无数据！");
                return;
            }
            int count = [[dic objectForKey:@"totalCount"] intValue];
            if (!isAdd) {
                dataArray = [dic objectForKey:@"data"];
            }
            else
            {
                [dataArray addObjectsFromArray:[dic objectForKey:@"data"]];
            }
            
            if ([_date isEqualToString:@"default"]) {
                self.lblTongji.text = [NSString stringWithFormat:@"本月零流量应用营业员总数 %d 人",count];
            }
            else
            {
                NSArray *dateArray = [_date componentsSeparatedByString:@"-"];
                NSString *startDate = [dateArray objectAtIndex:0];
                NSString *endDate = [dateArray objectAtIndex:1];
                if ([[startDate substringWithRange:NSMakeRange(4, 2)] isEqualToString:[endDate substringWithRange:NSMakeRange(4, 2)]]) {
                    self.lblTongji.text = [NSString stringWithFormat:@"本月零流量应用营业员总数 %d 人",count];
                }
                else
                {
                    self.lblTongji.text = [NSString stringWithFormat:@"%@至%@月零流量应用营业员总数 %d 人",[startDate substringWithRange:NSMakeRange(4, 2)],[endDate substringWithRange:NSMakeRange(4, 2)],count];
                }
            }

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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
