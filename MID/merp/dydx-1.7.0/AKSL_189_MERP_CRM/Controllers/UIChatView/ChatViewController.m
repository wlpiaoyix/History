//
//  ChatViewController.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-11.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTableCell.h"
#import "AddNoteViewController.h"
#import "ASIFormDataRequest.h"
#import "HttpApiCall.h"
#import "PublicInfo.h"
#import "SVPullToRefresh.h"

@interface ChatViewController ()

@end

@implementation ChatViewController{
    NSMutableArray *dataForNotes;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setTitleLabelString:(NSString *)str{
    titleString = str;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    _TitleLabel.text = titleString;
    if (listData) {
        if(listData.count>0){
            [listData removeAllObjects];
        }
        listData = nil;
    }
    [self loadDataForServer];
   // /api/publicinfo/byfactor/{factor}/{startIndex}/{count}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [ConfigManage setConfig:@"notice-Notification" Value:@"0"];
    _addButton.hidden = [ConfigManage getLoginUser].roelId == 4;
    UINib *nib = [UINib nibWithNibName:@"ChatTableCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"ChatTableCell"];
    [_tableView addPullToRefreshWithActionHandler:^{
        if (listData) {
            if(listData.count>0){
                [listData removeAllObjects];
            }
            listData = nil;
        }
        [self loadDataForServer];
        [_tableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
    }];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)loadDataForServer{
    int count = 10;
    int page = 1;
    if (listData) {
        if(listData.count%count){
            return;
        }else{
            page = listData.count+1;
        }
        
    }
   // [self showActivityIndicator];
    
    NSString *url = [NSString stringWithFormat:@"/api/publicinfo/%d/%d/notice",page,count];
    
      ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"get_notice_data"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            //            LoginUser * user = [LoginUser getLoginUserFromJson:reArg];
            NSDictionary *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                showMessageBox(@"暂无数据");
                return;
            }
            NSArray * data = [temp objectForKey:@"data"];
            if (data.count==0) {
                return;
            }
            if(!listData){
                listData = [[NSMutableArray alloc]init];
            }
            for (int i=0; i<data.count; i++) {
                PublicInfo *info = [PublicInfo getPulicInfoByDic:[data objectAtIndex:i]];
                [listData addObject:info];
            }
            [_tableView reloadData];
        }
        @catch (NSException *exception) {
            showAlertBox(@"提示", exception.reason);
            return;
        }
        @finally {
          //  [self hideActivityIndicator];
            
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

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addNote:(id)sender {
    AddNoteViewController *view = [[AddNoteViewController alloc]initWithNibName:@"AddNoteViewController" bundle:nil];
    [self.navigationController pushViewController:view animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (listData) {
    return  listData.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIFont *font = [UIFont systemFontOfSize:14];
   CGSize size=[((PublicInfo *)[listData objectAtIndex:indexPath.row]).contents sizeWithFont:font constrainedToSize:CGSizeMake(204, 1000)];
    if (size.height<=20) {
        return 95.0;
    }
    return 95.0+size.height-20.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CustomCellIdentifier = @"ChatTableCell";
        ChatTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    PublicInfo * info =  (PublicInfo *)[listData objectAtIndex:indexPath.row];
    [cell setData:info.userheaderImageUrl Content:info.contents DateForMessage:info.TimeToNote];
    int row = indexPath.row+1;
    if(row == listData.count){
        [self loadDataForServer];
    }
    return cell;
}
@end
