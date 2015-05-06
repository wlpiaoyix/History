//
//  InspectStoreListViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-17.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "InspectStoreListViewController.h"
#import "InspectStoreCell.h"
#import "HttpApiCall.h"
#import "NotesImageViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "SVPullToRefresh.h"
#import "InspectStoreInfo.h"
#import "CountForMsgCell.h"
#import "MessageListViewController.h"

@interface InspectStoreListViewController (){
    NSMutableArray * listForData;
    int maxCount;
    UIViewController * mainView;
}

@end

@implementation InspectStoreListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)setMainView:(UIViewController *)view{
    mainView = view;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    if (!listForData||_isChangeData) {
//        _isChangeData = NO;
//        [self updataFromServer:NO];
//    }
    
}
-(InspectStoreInfo *)getInspectStroeInfo:(int)index{
    if (index>=listForData.count) {
        return NULL;
    }
    return  listForData[index];
}
-(void)reloadData:(bool)isFrist{
    if (!isFrist) {
       [self updataFromServer:NO];
    }else if(!listForData){
        [self updataFromServer:NO];
    }
}
-(void)reloadData{
    [_tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _isChangeData = NO;
    maxCount = INT32_MAX;
    // Do any additional setup after loading the view from its nib.
    UINib *nib = [UINib nibWithNibName:@"InspectStoreCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"InspectStoreCell"];
     nib = [UINib nibWithNibName:@"CountForMsgCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"CountForMsgCell"];
    //api/attendances/{startIndex}/{count}/{type}/{queryName}
    [_tableView addPullToRefreshWithActionHandler:^{
        [self updataFromServer:NO];
        [_tableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
    }];
}
-(void)updataFromServer:(bool)isAdd{
     int pageSize = 11;
    int startIndex = 1;
    if(isAdd&&listForData){
        if (listForData.count>=maxCount){
            return;
        }else{
            startIndex = listForData.count + 1;
        }
    }
    [self showActivityIndicator];
    NSString *url = [NSString stringWithFormat:@"/api/attendances/%d/%d/,%ld,",startIndex,pageSize,_ids];
    
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"get_attendances_data_main"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
       [self hideActivityIndicator];
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSDictionary *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                showMessageBox(@"暂无数据");
                return;
            }
            maxCount = [[temp objectForKey:@"totalCount"]intValue];
            if (!listForData) {
                listForData = [NSMutableArray new];
            }
            if (!isAdd) {
                [listForData removeAllObjects];
            }
            NSArray  * list = [temp objectForKey:@"data"];
            for (NSDictionary * dic in list) {
                [listForData addObject:[InspectStoreInfo getInspectStoreInfo:dic]];
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
     [self hideActivityIndicator];
    }];
    [request startAsynchronous];

}
//Table DataSoucre
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1 || _CountForMsg<= 0) {
    if(listForData){
        return listForData.count;
    }
    }
    if (section== 0 && _CountForMsg >0 ) {
        return 1;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section== 0 && _CountForMsg >0 ) {
        return 67;
    }
    
     InspectStoreInfo * info = listForData[indexPath.row];
      return info.hieghtForZanpingjia;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_CountForMsg>0){
        return 2;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_CountForMsg>0 && indexPath.section == 0) {
      CountForMsgCell *countcell = [tableView dequeueReusableCellWithIdentifier:@"CountForMsgCell"];
        [countcell setData:_CountForMsg];
        return countcell;
    }
    
    InspectStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InspectStoreCell"];
    InspectStoreInfo * info = listForData[indexPath.row];
    NSDate * date = info.date;
    bool isshowdate = YES;
    if (indexPath.row>0) {
        NSDate * pdate = [(InspectStoreInfo *)listForData[indexPath.row-1] date];
        if (![pdate compareDate:0 compareDate:date]) {
            isshowdate = NO;
        }
    }
    [cell setData:info isShowDate:isshowdate inspectView:[InspectStoreViewController getInspectStoreMain] indexInListData:indexPath.row];
    if (indexPath.row==listForData.count-1) {
        [self updataFromServer:YES];
    }
    return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[InspectStoreViewController getInspectStoreMain] hideZanpingjia];
}
//数据项被选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[InspectStoreViewController getInspectStoreMain] isShowPingjiaInput]) {
         [[InspectStoreViewController getInspectStoreMain] hideZanpingjia];
         return ;
    }
    if (indexPath.section==0 && _CountForMsg>0) {
        MessageListViewController * messageview = [[MessageListViewController alloc]initWithNibName:@"MessageListViewController" bundle:nil];
         [mainView.mm_drawerController.navigationController pushViewController:messageview animated:YES];
        return;
    }
    [[InspectStoreViewController getInspectStoreMain]hideZanpingjia];
    InspectStoreInfo * info = listForData[indexPath.row];
    NSString *attamentsIds = info.attamentsIds;//[json objectForKey:@"attamentsIds"];
    if(![NSString isEnabled:attamentsIds]){
        showMessageBox(@"当前数据没有图片！");
        return;
    }
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:[@"/api/attachments/imgsbyids/" stringByAppendingString:attamentsIds] Params:nil Logo:@"get_attendances_details"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            id temp = [reArg JSONValueNewMy];
            if(temp){
                NSMutableDictionary *jsonDatas = [[NSMutableDictionary alloc]init];
                NSMutableArray *temp2 = [[NSMutableArray alloc]init];
                for(NSDictionary *temp3 in (NSArray*)temp){
                    NSMutableDictionary *temp4 =[[NSMutableDictionary alloc]init];
                    [temp4 setValue:API_IMAGE_URL_GET2([temp3 objectForKey:@"attachUrl"]) forKey:@"imageURL"];
                    [temp2 addObject:temp4];
                }
                [jsonDatas setValue:info.checkContents forKey:@"imageInfo"];
                if (temp2.count==0) {
                    showMessageBox(@"后台数据有误!无法查看。");
                    return ;
                }
                [jsonDatas setValue: temp2 forKey:@"data"];
                NotesImageViewController *l = [[NotesImageViewController alloc]initWithNibName:@"NotesImageViewController" bundle:nil];
                l.jsonData = jsonDatas;
                NSDictionary *organization = info.organization;
                l.title= [organization objectForKey:@"fullName"];
                [mainView.mm_drawerController.navigationController pushViewController:l animated:YES];
            }
        }
        @catch (NSException *exception) {
            showAlertBox(@"提示", exception.reason);
        }
        @finally {
            [self hideActivityIndicator];
        }
        
    }];
    [request setFailedBlock:^{
        [self hideActivityIndicator];
    }];
    [request startAsynchronous];
    [self showActivityIndicator];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
