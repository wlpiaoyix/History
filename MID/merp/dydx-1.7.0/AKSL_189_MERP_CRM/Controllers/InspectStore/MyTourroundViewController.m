//
//  MyTourroundViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-5-29.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "MyTourroundViewController.h"
#import "MyTourroundCell.h"
#import "HttpApiCall.h"
#import "MJRefresh.h"
#import "SeeTourRoundViewController.h"


@interface MyTourroundViewController ()
{
    NSMutableArray *tourroundArray;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    NSString *_userCode;
}


@end

@implementation MyTourroundViewController

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
    [self setData:YES];
    
    UINib *nib = [UINib nibWithNibName:@"MyTourroundCell" bundle:nil];
    [self.tableTourround registerNib:nib forCellReuseIdentifier:@"tourroundCell"];
    self.tableTourround.delegate = self;
    self.tableTourround.dataSource = self;
    [self addFooter];
    [self addHeader];

}
-(void)viewDidAppear:(BOOL)animated
{
    self.lblTitle.text = [[[tourroundArray firstObject] objectForKey:@"userName"] stringByAppendingString:@"的巡一巡"];
}

- (void)addFooter
{
    __unsafe_unretained MyTourroundViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableTourround;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [vc setData:NO];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:1.0];
    };
    _footer = footer;
}
- (void)addHeader
{
    __unsafe_unretained MyTourroundViewController *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableTourround;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        if (tourroundArray) {
            [tourroundArray removeAllObjects];
            tourroundArray = nil;
        }
        [vc setData:YES];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:1.0];
        
        //NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        //NSLog(@"%@----刷新完毕", refreshView.class);
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
               // NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
               // NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                //NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
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
    [self.tableTourround reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tourroundArray) {
        return [tourroundArray count];
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 113;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTourroundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tourroundCell"];
    if(!cell)
    {
        cell = [[MyTourroundCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tourroundCell"];
    }
    bool isDate = YES;
    bool isType = YES;
    NSString *strDate = [[[[tourroundArray objectAtIndex:indexPath.row] objectForKey:@"checkTime"] componentsSeparatedByString:@" "] firstObject];
    NSDate *date = [NSDate dateFormateString:strDate FormatePattern:@"yyyy-MM-dd"];
    if (indexPath.row > 0) {
        NSString *strpDate = [[[[tourroundArray objectAtIndex:indexPath.row-1] objectForKey:@"checkTime"] componentsSeparatedByString:@" "] firstObject];
        NSDate *pdate = [NSDate dateFormateString:strpDate FormatePattern:@"yyyy-MM-dd"];

        if (![pdate compareDate:0 compareDate:date]) {
            isDate = NO;
        }
        if (![[[tourroundArray objectAtIndex:indexPath.row] objectForKey:@"checkTypeName"] isEqualToString:[[tourroundArray objectAtIndex:indexPath.row-1] objectForKey:@"checkTypeName"]]) {
            isType = NO;
        }
    }
    [cell setTourroundData:[tourroundArray objectAtIndex:indexPath.row] ISDate:isDate IsCheckType:isType];
    return cell;
}
-(void)setUserCode:(NSString *)userCode
{
    _userCode = userCode;
}
-(void)setData:(BOOL)isFrist
{
    int pageSize = 10;
    int startindex = 1;
    if(!isFrist)
    {
        if (tourroundArray.count % pageSize) {
            return;
        }
        else
        {
            startindex = tourroundArray.count+1;
        }
    }
    else if (tourroundArray)
    {
        return;
    }
    else if (_userCode == nil)
    {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"/api/attendances/myatt/%d/%d/all/%@",startindex,pageSize,_userCode];
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"collect_get_data"];
    __weak ASIFormDataRequest *request = requestx;
    [self showActivityIndicator];
    [request setCompletionBlock:^
     {
         [self hideActivityIndicator];
         [request setResponseEncoding:NSUTF8StringEncoding];
         NSString *reArg = [request responseString];
         @try {
             NSDictionary *dic = [reArg JSONValueNewMy];
             if (dic == nil) {
                 return;
             }
             if (isFrist) {
                 tourroundArray = [dic objectForKey:@"data"];
             }
             else
             {
                 [tourroundArray addObjectsFromArray:[dic objectForKey:@"data"]];
             }
             [self.tableTourround reloadData];
         }
         @catch (NSException *exception) {
             showMessageBox(@"暂无数据");
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    SeeTourRoundViewController *seeTour = [[SeeTourRoundViewController alloc] init];
    [seeTour setdata:[tourroundArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:seeTour animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUserCode:(NSString *)userCode :(NSString *)name{
}
@end
