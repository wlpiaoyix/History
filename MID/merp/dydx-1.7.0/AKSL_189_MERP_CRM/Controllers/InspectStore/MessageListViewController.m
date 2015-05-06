//
//  MessageListViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-3-27.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageListCell.h"
#import "HttpApiCall.h"
#import "SVPullToRefresh.h"
#import "MJRefresh.h"
#import "InspectStoreViewController.h"

@interface MessageListViewController ()
{
    NSMutableArray *messageArray;
    MJRefreshFooterView *_footer;
}

@end

@implementation MessageListViewController

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
    [[InspectStoreViewController getInspectStoreMain]clearNotReadMsg];
    messageArray = [[NSMutableArray alloc] initWithCapacity:0];

    [self messageList:10 :0 :-1:NO];
    self.messageTalbleView.delegate = self;
    self.messageTalbleView.dataSource = self;
    [self.messageTalbleView addPullToRefreshWithActionHandler:
    ^{
        [self messageList:10 :0 :-1:NO];
        [self.messageTalbleView reloadData];
        [self.messageTalbleView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
        
    }];

    [self addFooter];
}

- (void)addFooter
{
    __unsafe_unretained MessageListViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.messageTalbleView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 增加10条数据
        long long int lastDate= [self os_time];
        [self messageList:10 : lastDate:0 :YES];
        [self.messageTalbleView reloadData];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
    };
    _footer = footer;
    
}

-(long long int)os_time
{

    NSArray *timeArray = [[[messageArray lastObject] objectForKey:@"createTime"] componentsSeparatedByString:@"."];
    NSArray *timeArraySS = [[timeArray objectAtIndex:1] componentsSeparatedByString:@"+"];
    
    NSDate * date =[NSDate dateFormateString:[timeArray objectAtIndex:0] FormatePattern:nil];

    NSTimeInterval time = [date timeIntervalSince1970];
    NSTimeInterval newTime = time *1000 + [[timeArraySS objectAtIndex:0] doubleValue];
    long long int Time = (long long)newTime;
    return Time;
}
- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.messageTalbleView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [messageArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [messageArray count]) {
        
    }
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    if(!cell)
    {
        cell = [[MessageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageCell"];
    }
    
     NSDictionary *dic = [messageArray objectAtIndex:indexPath.row];
    
    NSInteger msgType = [[dic objectForKey:@"msgType"] intValue];
    NSArray *timeArray = [[dic objectForKey:@"createTime"] componentsSeparatedByString:@"."];
    
    NSDate * date =[NSDate dateFormateString:[timeArray firstObject] FormatePattern:nil];
    
    [cell setDate:[dic objectForKey:@"userName"] UserPortraint:API_IMAGE_URL_GET2([dic objectForKey:@"userPortraint"]) Content:[dic objectForKey:@"content"] PicturePath:API_IMAGE_URL_GET2([dic objectForKey:@"picturePath"]) MsgType:msgType CreateTime:date];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   NSDictionary *dic = [messageArray objectAtIndex:indexPath.row];
    InspectStoreViewController * inspect = [[InspectStoreViewController alloc]initWithNibName:@"InspectStoreViewController" bundle:nil];
    inspect.isQueryRest = YES;
    inspect.isSingeInfo = YES;
    inspect.QueryInspectId = [[dic valueForKey:@"attendaceId"]longValue];
    [self.navigationController pushViewController:inspect animated:YES];
}
/*
 GET /api/like/messages/{count}/{date}点赞评论
 
 说明：1.查询消息列表 如果查询提示最新条数 count参数传新消息提示个数 则显示最新消息列表 后台进行已读修改操作。
 2.如果查询所有消息列表,则与之前分页无异。
 3.区分评论和点赞，返回参数msgType  0则代表评论 1代表点赞
 4.date 参数第一次访问数据的时候默认传 -1 获取第一页或最新消息数据 后续访问传第一次访问返回集合的最后一个对象
 的creatTime的毫秒数。
 Request:
 参数说明：
 "date":默认参数为-1 （查询开始时间）
 "count":分页条数
 */
-(void)messageList:(NSInteger) pageCount :(long long int)date :(int)newDate :(BOOL) isAdd
{
    [self showActivityIndicator];
    //NSString *url = [NSString stringWithFormat:@"/api/attendances/messages/%d",30309];
   // NSString *url = [NSString stringWithFormat:@"/api/attendances/%d/%d/%d",1,10,77];
    //[messageArray removeAllObjects];
    NSString *url;
    if(date == 0 && newDate == -1)
    {
        url = [NSString stringWithFormat:@"/api/like/messages/%d/%d",pageCount,newDate];
    }
    else if (date != 0 && newDate !=-1)
    {
        url = [NSString stringWithFormat:@"/api/like/messages/%d/%lli",pageCount,date];
    }
    
    ASIFormDataRequest *request = [HttpApiCall requestCallGET:url Params:nil Logo:@"message_data"];
    __weak ASIFormDataRequest *request1 = request;
    [request1 setCompletionBlock:^{
        [self hideActivityIndicator];
        [request1 setResponseEncoding:NSUTF8StringEncoding];
        NSString *str = [request1 responseString];
    
        NSDictionary *dic = [str JSONValueNewMy];
      
        if(dic == nil)
        {
            showMessageBox(@"暂无数据");
            return;
        }
        if (!isAdd) {
            messageArray = [dic objectForKey:@"data"];
        }
        else if (isAdd)
        {
            [messageArray addObjectsFromArray:[dic objectForKey:@"data"]];
        }
        
        [self.messageTalbleView reloadData];
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
