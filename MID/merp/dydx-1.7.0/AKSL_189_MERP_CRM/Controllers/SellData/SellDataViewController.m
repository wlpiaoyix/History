//
//  SellDataViewController.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-5.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "SellDataViewController.h"
#import "SingleDateScheduleCell.h" 
#import "ManagerSellDataCell.h"
#import "CuostmSellDataCell.h"
#import "RealTimeCommitCell.h"
#import "DetailedSellInfoView.h"
#import "DetailedSellInfoViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "SellFilterViewController.h"
#import "CommitDataViewController.h"
#import "ASIFormDataRequest.h"
#import "HttpApiCall.h"
#import "SVPullToRefresh.h"
#import "ChangeValueForCommitSellViewController.h"
#import "RealCommitDetaileViewController.h"

#define CUSTOM_CELL_IDENTIFIER @"SellDataCell"

@interface SellDataViewController ()

@end

@implementation SellDataViewController

static SellDataViewController * selldatapage;

-(void)setSelectIndex:(NSInteger)index{
    selectedIndex = index;
}

+(id)getSellData{
    if(!selldatapage){
        selldatapage = [[SellDataViewController alloc]initWithNibName:@"SellDataViewController" bundle:nil];
    }
    return selldatapage;
}
+(void)newSellData{
    if(selldatapage){
        [selldatapage removeFromParentViewController];
        selldatapage = nil;
    }
    selldatapage = [[SellDataViewController alloc]initWithNibName:@"SellDataViewController" bundle:nil];
}
static int numtoSelectUser = 1;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)intputshow:(NSNotification *)notification{
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
          
        CGFloat num =100 - keyBoardFrame.origin.y;
        if (num>0) {
            CGRect frmeimage = mainScrollView.frame;
            frmeimage.origin.y =48 - num - 50;
            mainScrollView.frame = frmeimage;
        
        }
        
    }];

}
-(void)intputhide:(NSNotification *)notification{
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect frmeimage = mainScrollView.frame;
        frmeimage.origin.y =48;
        mainScrollView.frame = frmeimage;
    }];

}
-(void)viewDidAppear:(BOOL)animated{
     [super viewDidAppear:animated];
    if(loginuser.roelId == 4)
        [((UITableView *) [mainScrollView viewWithTag:20001]) reloadData];
    if(isLoadStart == 0){
    mainScrollView = (UIScrollView *)[mainView viewWithTag:3000];
    selectedLabelBackground = (UILabel *)[mainView viewWithTag:2000];
    CGFloat heightforMainScroll = mainScrollView.frame.size.height;
    
    if (numberOfTab == 3) {
        //添加列表
        for (int i= 0; i<numberOfTab; i++) {
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(320*i, 0, 320,heightforMainScroll)];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.tag = i+10000*numberOfTab;
            if(IOS7_OR_LATER)
                tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            NSString *CustomCellNibName = @"ManagerSellDataCell";
            if (i==1) {
                CustomCellNibName = @"CuostmSellDataCell";
            }
            if (i==2) {
                CustomCellNibName = @"RealTimeCommitCell";
                CGRect frameview =  _viewForGetCommitDataCuostmSell.frame;
                frameview.origin.x = 640;
                _viewForGetCommitDataCuostmSell.frame = frameview;
                [mainScrollView addSubview:_viewForGetCommitDataCuostmSell];
                [tableView setFrame:CGRectMake(320*i, 43, 320,heightforMainScroll-43)];
            }
            
            UINib *nib = [UINib nibWithNibName:CustomCellNibName bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:CUSTOM_CELL_IDENTIFIER];
            if (i==2) {
                [tableView addPullToRefreshWithActionHandler:^{
                  UITableView *view = (UITableView *)[mainScrollView viewWithTag:30002];
                    if(!view)return;
                    if (CommitDataList) {
                        if(CommitDataList.count>0){
                            [CommitDataList removeAllObjects];
                        }
                        CommitDataList = nil;
                    }
                    [self getDataForServer:1003 Page:1];
                    [view.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
                }];
            }
            [mainScrollView addSubview:tableView];
        }
    }else if(numberOfTab == 2){
        //添加详细数据
        DetailedSellInfoView * deview = [[DetailedSellInfoView alloc]initWithFrame:CGRectMake(0, 0, 320, heightforMainScroll)];
        deview.UserCode = loginuser.userId;
        deview.type = 0;
        [deview setBase:self];
        [mainScrollView addSubview:deview];
        //添加上报
        int i=1;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(320*i, 0, 320,heightforMainScroll)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag = i+10000*numberOfTab;
        
        if(IOS7_OR_LATER)
            tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        NSString *CustomCellNibName = @"SellCommitCell";
        
        UINib *nib = [UINib nibWithNibName:CustomCellNibName bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CUSTOM_CELL_IDENTIFIER];
        
        [mainScrollView addSubview:tableView];
//        UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(320, 0, 320, heightforMainScroll)];
//        UIView *commitpage= [_CommitMainPage viewWithTag:1000];
//        [self setCornerRadiusAndBorder:commitpage];
//        [scrollview addSubview:_CommitMainPage];
//        scrollview.contentSize =CGSizeMake(320, _CommitMainPage.frame.size.height);
//        //scrollview.delegate = self;
//        [mainScrollView addSubview:scrollview];
    }
    
    mainScrollView.contentSize = CGSizeMake(320*numberOfTab, mainScrollView.frame.size.height);
        if(selectedIndex){
            [self ChangePageToScroll:selectedIndex];
        }else{
      // selectedIndex = numberOfTab==3?1001:1004;
      [self ChangePageToScroll:(numberOfTab==3?1001:1004)];
        }
        isLoadStart = 1;
       // [self getDataForServer:1002 Page:0];
    }else if(isLoadStart == 2){
        [self reloadData];
        isLoadStart = 1;
    }else if(isLoadStart == 1){
      [self ChangePageToScroll:selectedIndex];
    }
 
}
-(void)reloadData{
    if(CuomstList){
        if (CuomstList.count>0) {
            [CuomstList removeAllObjects];
        }
        CuomstList = nil;
       UITableView * table = (UITableView *)[mainScrollView viewWithTag:30001];
        if (table) {
            [table reloadData];
        }
        
    }
    if(ChannelManagerList){
        if (ChannelManagerList.count>0) {
            [ChannelManagerList removeAllObjects];
        }
        ChannelManagerList = nil;
        //清空表
        UITableView * table = (UITableView *)[mainScrollView viewWithTag:30000];
        if (table) {
            [table reloadData];
        }
    }
    [self getDataForServer:selectedIndex Page:1];
}

-(void)getDataForServer:(int)type Page:(int)page{
        if((page-1)%20 && type != 1003){
         return;
         }
    [self showActivityIndicator];
    // /api/user/channelfilter/year/,29,32,41,/,81,82,83,/,1,2,/1/1
    // /api/user/agentfilter/year/,29,32,41,/,81,82,83,/,1,2,/0/20
    if(![ConfigManage getConfig:DATE_SELECT_KEY]){
        [ConfigManage setConfig:PRODUCTS_INFO_SELECT_KEY Value:@"/all"];
        [ConfigManage setConfig:DATE_SELECT_KEY Value:@"/week"];
        [ConfigManage setConfig:DISTRICT_INFO_SELECT_KEY Value:@"/all"];
        [ConfigManage setConfig:STORETYPE_INFO_SELECT_KEY Value:@"/all"];
    }
    //添加 年周 产品 厅店类型 区域
    NSString *url = [[[[ConfigManage getConfig:DATE_SELECT_KEY]stringByAppendingString:[ConfigManage getConfig:PRODUCTS_INFO_SELECT_KEY]]stringByAppendingString:[ConfigManage getConfig:STORETYPE_INFO_SELECT_KEY]]stringByAppendingString:[ConfigManage getConfig:DISTRICT_INFO_SELECT_KEY]];
    
    switch (type) {
        case 1001:
            url =[NSString stringWithFormat:@"/api/user/%@%@/%d/20",@"channelfilter",url,page];
            break;
        case 1002:
            url =[NSString stringWithFormat:@"/api/user/%@%@/%d/20",@"agentfilter",url,page];
            break;
        case 1003:
            _lableForCommitSum.text = @"0";
            _lableForNoCommit.text = @"0";
            url = @"/api/user/realtimeinfo";//[NSString stringWithFormat:@"/api/user/realtimeinfo",url,page];
            break;
     }
    
     ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"get_sell_data"];
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
            if (type==1001) {
            NSArray * data = [temp objectForKey:@"data"];
            if (data.count==0) {
            return;
            }
            if(ChannelManagerList){
               [ChannelManagerList addObjectsFromArray:data];
            }else{
               ChannelManagerList = [[NSMutableArray alloc]initWithArray:data];
                if (loginuser.roelId == 3 && [temp objectForKey:@"selfInfo"]) {
                    [ChannelManagerList insertObject:[temp objectForKey:@"selfInfo"] atIndex:0];//:[temp objectForKey:@""]];
                }
            }
            [((UITableView *) [mainScrollView viewWithTag:30000]) reloadData];
            }
            
            if (type == 1002) {
                 NSArray * data = [temp objectForKey:@"data"];
                if (data.count==0) {
                    return;
                }
                if(CuomstList){
                    [CuomstList addObjectsFromArray:data];
                }else{
                    CuomstList = [[NSMutableArray alloc]initWithArray:data];
                }
                [((UITableView *) [mainScrollView viewWithTag:30001]) reloadData];
            }
            
            if(type == 1003){
                NSArray * data = [temp objectForKey:@"data"];
                if (data.count==0) {
                    return;
                }
                if(CommitDataList){
                    [CommitDataList removeAllObjects];
                    CommitDataList = nil;
                  }
                 CommitDataList = [[NSMutableArray alloc]initWithArray:data];
                int sunnum = 0;
                int sunp = 0;
                for (int i = 0; i<CommitDataList.count; i++) {
                    NSDictionary * dic = [CommitDataList objectAtIndex:i];
                    int num = [[dic objectForKey:@"reportedComplete"]intValue];
                     sunnum +=num;
                    if (num<=0) {
                        sunp++;
                    }
                }
                _lableForCommitSum.text = [NSString stringWithFormat:@"%d",sunnum];
                _lableForNoCommit.text = [NSString stringWithFormat:@"%d",sunp];
                [self getCommitDataForServer];
                [((UITableView *) [mainScrollView viewWithTag:30002]) reloadData];
            }
        }
        @catch (NSException *exception) {
            showAlertBox(@"提示", exception.reason);
            return;
        }
        @finally {
            [self hideActivityIndicator];
            
        }
    }];
    [request setFailedBlock:^{ 
        [self hideActivityIndicator];
    }];
    [request startAsynchronous];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    mainView.frame = CGRectMake(0, 44, 320, self.view.frame.size.height-44);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    isLoadStart = 0;
    loginuser = [ConfigManage getLoginUser];
    if(loginuser.roelId<4){
        mainView = _CompView;
        numberOfTab = 3;
    }else{
        mainView = _CustomerView;
        numberOfTab = 2;
        _FilerAndCommit.hidden = YES;
    }
    numtoSelectUser ++;
    [self.view addSubview:mainView];
    [self getProducts];
    [self getStoreTypeInfo];
    [self getAresasInfo];
  //  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(intputshow:) name:UIKeyboardWillShowNotification object:nil];
 //   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(intputhide:) name:UIKeyboardWillHideNotification object:nil];
    
}
///api/products/{startIndex}/{count}
-(void)getProducts{
    NSString * products =  [ConfigManage getConfig:PRODUCTS_INFO_KEY];
    if(products && products.length>0){
        NSDictionary *temp = [products JSONValueNewMy];
        if(temp){
            getProductsList = [temp objectForKey:@"data"];
            if(loginuser.roelId == 4)
            [((UITableView *) [mainScrollView viewWithTag:20001]) reloadData];
//            UIView *commitpage= [_CommitMainPage viewWithTag:1000];
//            int tagpp = 5000;
//            int today = [NSDate new].day;
//           NSArray *data = [temp objectForKey:@"data"];
//            int maxp = 10;
//            if (data.count<10) {
//                maxp = data.count;
//            }
//            for (int i=1; i<=maxp; i++) {
//                UILabel * name = (UILabel *)[commitpage viewWithTag:tagpp+10+i];
//                UITextField * field = (UITextField *)[commitpage viewWithTag:tagpp+i];
//                NSDictionary *dic = [data objectAtIndex:i-1];
//                name.text = [dic objectForKey:@"productsName"];
//                field.tag = [[dic objectForKey:@"id"]intValue];
//                //给field添加值  今日已经上报
//                NSString * numofproductskey = [NSString stringWithFormat:@"products_num_for_commit_data_and_date_%d",field.tag];
//                NSString * numofproducts =[ConfigManage getConfig:numofproductskey];
//                if(numofproducts){
//                    NSArray * ar = [numofproducts componentsSeparatedByString:@":"];
//                    if(today == [[ar objectAtIndex:0]intValue]){
//                        field.text = [ar objectAtIndex:1];
//                    }
//                }
             return;
        }
     }
    NSString *url =@"/api/products/1/30";// [NSString stringWithFormat:@"/api/products/1/10"];
     ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"PRODUCTS_INFO_KEY"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSDictionary *temp = [reArg JSONValueNewMy];
            if(!temp){
                return;
            }
            getProductsList = [temp objectForKey:@"data"];
            if(loginuser.roelId == 4)
                [((UITableView *) [mainScrollView viewWithTag:20001]) reloadData];
//            UIView *commitpage= [_CommitMainPage viewWithTag:1000];
//            int tagpp = 5000;
//            int today = [NSDate new].day;
//            NSArray *data = [temp objectForKey:@"data"];
//            int maxp = 10;
//            if (data.count<10) {
//                maxp = data.count;
//            }
//            for (int i=1; i<=maxp; i++) {
//                UILabel * name = (UILabel *)[commitpage viewWithTag:tagpp+10+i];
//                UITextField * field = (UITextField *)[commitpage viewWithTag:tagpp+i];
//                NSDictionary *dic = [data objectAtIndex:i-1];
//                name.text = [dic objectForKey:@"productsName"];
//                field.tag = [[dic objectForKey:@"id"]intValue];
//                //给field添加值  今日已经上报
//                NSString * numofproductskey = [NSString stringWithFormat:@"products_num_for_commit_data_and_date_%d",field.tag];
//                NSString * numofproducts =[ConfigManage getConfig:numofproductskey];
//                if(numofproducts){
//                    NSArray * ar = [numofproducts componentsSeparatedByString:@":"];
//                    if(today == [[ar objectAtIndex:0]intValue]){
//                        field.text = [ar objectAtIndex:1];
//                    }
//                }
//                
//            }
            [ConfigManage setConfig:PRODUCTS_INFO_KEY Value:reArg];
        }
        @catch (NSException *exception) {
        }
        @finally {
    
        }
    }];
    [request setFailedBlock:^{
        showMessageBox(@"读取产品失败。");
    }];
    [request startAsynchronous];
}
///api/organizations/allareas
-(void)getStoreTypeInfo{
    NSString * products =  [ConfigManage getConfig:STORETYPE_INFO_KEY];
    if(products && products.length>0){
        NSDictionary *temp = [products JSONValueNewMy];
        if(temp){
            return;
        }
    }
    NSString *url =@"/api/dic/allhalltype";// [NSString stringWithFormat:@"/api/products/1/10"];
      ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"STORETYPE_INFO_KEY"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSDictionary *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                return;
            }
            [ConfigManage setConfig:STORETYPE_INFO_KEY Value:reArg];
        }
        @catch (NSException *exception) {
        }
        @finally {
            
        }
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}
///api/organizations/allareas
-(void)getAresasInfo{
    NSString * products =  [ConfigManage getConfig:DISTRICT_INFO_KEY];
    if(products && products.length>0){
        NSDictionary *temp = [products JSONValueNewMy];
        if(temp){
            return;
        }
    }
    NSString *url =@"/api/organizations/allareas";// [NSString stringWithFormat:@"/api/products/1/10"];
     ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"DISTRICT_INFO_KEY"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSDictionary *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                return;
            }
            [ConfigManage setConfig:DISTRICT_INFO_KEY Value:reArg];
        }
        @catch (NSException *exception) {
        }
        @finally {
        
        }
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}
//Table DataSoucre
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 30000) {
        if(ChannelManagerList)
            return ChannelManagerList.count;
    }
    if (tableView.tag== 30001) {
        if (CuomstList) {
            return CuomstList.count;
        }
    }
    if (tableView.tag == 30002) {
        if(CommitDataList){
        return CommitDataList.count;
        }
    }
    if (tableView.tag == 20001) {
        if (getProductsList) {
            return getProductsList.count;
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 20001) {
        return 55;
    }
    return 82;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%d",indexPath.row);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CUSTOM_CELL_IDENTIFIER];
    if(cell){
            //[cell addSubview:_commitData];
        if(tableView.tag == 20001){
         UILabel * textname = (UILabel *)[cell.contentView viewWithTag:5001];
         UILabel * textnum = (UILabel *)[cell.contentView viewWithTag:5002];
          textnum.layer.cornerRadius = 6;
            if (indexPath.row+1>= getProductsList.count) {
                
            }
            NSDictionary * dic = [getProductsList objectAtIndex:indexPath.row];
            textname.text = [dic objectForKey:@"productsName"];
            int ids = [[dic objectForKey:@"id"]intValue];
                     NSString * numofproductskey = [NSString stringWithFormat:@"products_num_for_commit_data_and_date_%d",ids];
                     NSString * numofproducts =[ConfigManage getConfig:numofproductskey];
                       int today = [NSDate new].day;
                    textnum.text = @"0";
                          if(numofproducts){
                           NSArray * ar = [numofproducts componentsSeparatedByString:@":"];
                         if(today == [[ar objectAtIndex:0]intValue]){
                                 textnum.text = [ar objectAtIndex:1];
                         }
                        }

        }
        if (tableView.tag == 30000) {
            if (ChannelManagerList) {
            int row = indexPath.row;
            NSDictionary *data= [ChannelManagerList objectAtIndex:row];
            LoginUser * user = [LoginUser getLoginUserFromDic:data];
            if(loginuser.roelId == 3) {
                if(row == 0)
                row = [[data objectForKey:@"rank"] intValue] * -1;
                }else{
                row+=1;
                }
                
            [((ManagerSellDataCell *)cell) setData:user.username Loaction:user.setString Row:row HeaderImages:user.headerImageUrl JobPlam:[NSString stringWithFormat:@"%d",user.task] OverJob:[NSString stringWithFormat:@"%d",user.complete] saleForJob:user.progressString];
            }
            if (ChannelManagerList.count == indexPath.row+1) {
                [self getDataForServer:1001 Page:ChannelManagerList.count+1];
            }
        }
        if (tableView.tag == 30001) {
            if (CuomstList) {
                NSDictionary *data= [CuomstList objectAtIndex:indexPath.row];
                LoginUser * user = [LoginUser getLoginUserFromDic:data];
                
                [((CuostmSellDataCell *)cell) setData:user.username headerImage:user.headerImageUrl SetString:user.setString  Row:indexPath.row+1 ValueForJob:user.progressFloat progress:user.progressString];
            }
            if (CuomstList.count == indexPath.row+1) {
                [self getDataForServer:1002 Page:CuomstList.count+1];
            }
        }
        if (tableView.tag == 30002) {
            if (CommitDataList) {
                NSDictionary *data = [CommitDataList objectAtIndex:indexPath.row];
                [((RealTimeCommitCell *)cell) setData:[data objectForKey:@"name"] Row:indexPath.row+1 headerImage:[data objectForKey:@"portraitUrl"] SetString:[data objectForKey:@"typeName"] valueForCommit:[[data objectForKey:@"reportedComplete"]intValue] valueForSale:[data objectForKey:@"timeSeq"]];
            }
            
            
        }
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 20001) {
        ChangeValueForCommitSellViewController * view = [[ChangeValueForCommitSellViewController alloc]initWithNibName:@"ChangeValueForCommitSellViewController" bundle:nil];
        NSDictionary * dic = [getProductsList objectAtIndex:indexPath.row];
        NSString * name= [dic objectForKey:@"productsName"];
         int ids = [[dic objectForKey:@"id"]intValue];
        [view setData:name ID:ids];
        [self.mm_drawerController.navigationController pushViewController:view animated:YES];
    }
    if (tableView.tag == 30000) {
        DetailedSellInfoViewController * detailview= [[DetailedSellInfoViewController alloc]initWithNibName:@"DetailedSellInfoViewController" bundle:nil];
        NSDictionary *data= [[ChannelManagerList objectAtIndex:indexPath.row] objectForKey:@"user"];
        detailview.userCode = [NSString stringWithFormat:@"%lli",[[data objectForKey:@"userCode"]longLongValue]];
        [self.mm_drawerController.navigationController pushViewController:detailview animated:YES];
    }
    if (tableView.tag == 30001) {
        DetailedSellInfoViewController * detailview= [[DetailedSellInfoViewController alloc]initWithNibName:@"DetailedSellInfoViewController" bundle:nil];
        NSDictionary *data= [[CuomstList objectAtIndex:indexPath.row]objectForKey:@"user"];
        detailview.userCode = [NSString stringWithFormat:@"%lli",[[data objectForKey:@"userCode"]longLongValue]];
        [self.mm_drawerController.navigationController pushViewController:detailview animated:YES];
    }
    if (tableView.tag == 30002) {
        NSDictionary *dic = [CommitDataList objectAtIndex:indexPath.row];
        if ( [[dic objectForKey:@"reportedComplete"]intValue] > 0) {
        RealCommitDetaileViewController * realview = [[RealCommitDetaileViewController alloc]initWithNibName:@"RealCommitDetaileViewController" bundle:nil];
        realview.ids = [[dic objectForKey:@"id"]longLongValue];
        [self.mm_drawerController.navigationController pushViewController:realview animated:YES];
        }else{
            showMessageBox(@"此条数据为未上报数据。");
        }
        }
   }
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)ChangePageToScroll:(int)buttonIndex{
    if (currInput) {
        [currInput resignFirstResponder];
    }
//    UIButton *slectbut = (UIButton *)[mainView viewWithTag:selectedIndex];
//    if(slectbut)
//    [slectbut setSelected:NO];
    
   UIButton * slectbut = (UIButton *)[mainView viewWithTag:buttonIndex];
    if(!slectbut)
        return;
    [slectbut setSelected:YES];
    
    if (selectedIndex>1000) {
        slectbut = (UIButton *)[mainView viewWithTag:selectedIndex];
        if(slectbut)
        [slectbut setSelected:NO];
    }
    
    
    CGFloat MainOffsetX = 0;
    CGFloat LableOffsetX = 0;
    _FilerAndCommit.hidden = NO;
    _FilerAndCommit.enabled = YES;
    [_FilerAndCommit setImage:[UIImage imageNamed:@"icon_w_filer"] forState:UIControlStateNormal];
    switch (buttonIndex) {
        case 1001:
            [_filerButtonView setHidden:NO];
            MainOffsetX = 0;
            LableOffsetX = 0;
            if(!ChannelManagerList)
            [self getDataForServer:buttonIndex Page:1];
            break;
        case 1002:
            [_filerButtonView setHidden:YES];
            MainOffsetX = 320;
            LableOffsetX = 107;
            if(!CuomstList)
            [self getDataForServer:buttonIndex Page:1];
            break;
        case 1003:
            [_filerButtonView setHidden:YES];
             [_FilerAndCommit setImage:[UIImage imageNamed:@"icon_w_commitOk"] forState:UIControlStateNormal];
            if (loginuser.roelId!=2) {
                _FilerAndCommit.hidden = YES;
            }
            [self getDataForServer:buttonIndex Page:1];
            MainOffsetX = 640;
            LableOffsetX = 214;
            break;
        case 1004:
            _FilerAndCommit.hidden = YES;
            _FilerAndCommit.enabled = NO;
            MainOffsetX = 0;
            LableOffsetX = 0;
            break;
        case 1005:
            _FilerAndCommit.hidden = YES;
            _FilerAndCommit.enabled = NO;
            [self getACommitData];
            MainOffsetX = 320;
            LableOffsetX = 160;
            break;
        default:
            break;
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = selectedLabelBackground.frame;
        rect.origin.x = LableOffsetX;
        selectedLabelBackground.frame= rect;
        [mainScrollView setContentOffset:CGPointMake(MainOffsetX, 0)];
    }];
    selectedIndex = buttonIndex;
}
- (IBAction)ChangePage:(id)sender {
    [self ChangePageToScroll:((UIView *)sender).tag];
    
}

- (IBAction)TextInputBegin:(id)sender {
    currInput = (UITextField *)sender;
}

- (IBAction)CommitDataToServer:(id)sender {
    [self showActivityIndicator];
    NSString * products =  [ConfigManage getConfig:PRODUCTS_INFO_KEY];
    NSString * commitData = @"[";
    // NSString *singerCommitData = @"{\"productID\":%d,\"productName\":\"%@\",\"count\":%d}";
    if(products && products.length>0){
        NSDictionary *temp = [products JSONValueNewMy];
        if(temp){
            UIView *commitpage= [_CommitMainPage viewWithTag:1000];
            int today = [NSDate new].day;
            NSArray *data = [temp objectForKey:@"data"];
            for (int i=0; i<data.count; i++) {
                NSDictionary *dic = [data objectAtIndex:i];
                int idcode = [[dic objectForKey:@"id"]intValue];
                UITextField * field = (UITextField *)[commitpage viewWithTag:idcode];
                if (field && [field.text intValue]) {
                    //给field添加值  今日已经上报
                    commitData = [NSString stringWithFormat:@"%@{\"productID\":%d,\"productName\":\"%@\",\"count\":%d},",commitData,idcode,[dic objectForKey:@"productsName"],[field.text intValue]];
                    NSString * numofproductskey = [NSString stringWithFormat:@"products_num_for_commit_data_and_date_%d",field.tag];
                    NSString * numofproducts =[NSString stringWithFormat:@"%d:%@",today,field.text];
                    [ConfigManage setConfig:numofproductskey Value:numofproducts];
                }
            }
            if (commitData.length < 10) {
                [self hideActivityIndicator];
                showMessageBox(@"至少需要填写一个产品销量！谢谢");
            }
          commitData = [[commitData substringToIndex:(commitData.length - 1)]stringByAppendingString:@"]"];
            if ([commitData JSONValueNewMy]) {
                NSString *url =@"/api/datareports/batch";
                 ASIFormDataRequest *requestx = [HttpApiCall requestCallPOST:url Params:[commitData JSONValueNewMy] Logo:@"selldata_commit_toServer"];
                __weak ASIFormDataRequest *request = requestx;

                [request setCompletionBlock:^{
                    [request setResponseEncoding:NSUTF8StringEncoding];
                    NSString *reArg = [request responseString];
                    @try {
                        [self hideActivityIndicator];
                        showMessageBox(reArg);
                    }
                    @catch (NSException *exception) {
                    }
                    @finally {
                        
                    }
                }];
                [request setFailedBlock:^{
                    [self hideActivityIndicator];
                    showMessageBox(@"提交失败，请重新提交数据。");
                }];
                [request startAsynchronous];
            }
        }
    }

    
    
}


- (IBAction)HideKeyborad:(id)sender {
 if(currInput)
   [currInput resignFirstResponder];
}
- (IBAction)ToFilterView:(id)sender {
    if (selectedIndex == 1003) {
        CommitDataViewController *commit = [[CommitDataViewController alloc]initWithNibName:@"CommitDataViewController" bundle:nil];
        [self.mm_drawerController.navigationController pushViewController:commit animated:YES];
    }else if(selectedIndex == 1001 || selectedIndex == 1002){
    SellFilterViewController * filter = [[SellFilterViewController alloc]initWithNibName:@"SellFilterViewController" bundle:nil];
    [self.mm_drawerController.navigationController pushViewController:filter animated:YES];
        isLoadStart = 2;//:filter animated:YES];
    }
}
- (IBAction)getUnreportedClick:(id)sender {
    //api/sms/unreported
    
    [self showActivityIndicator];
       NSString *url =@"/api/sms/unreported";
     ASIFormDataRequest *requestx = [HttpApiCall requestCallPOST:url Params:nil Logo:@"selldata_commit_unreported"];
    __weak ASIFormDataRequest *request = requestx;
                [request setCompletionBlock:^{
                    [request setResponseEncoding:NSUTF8StringEncoding];
                    NSString *reArg = [request responseString];
                    @try {
                        [self hideActivityIndicator];
                        showMessageBox([reArg isEqualToString:@"1"]?@"催报成功。":@"催报失败，请稍后再次提交。");
                    }
                    @catch (NSException *exception) {
                    }
                    @finally {
                        
                    }
                }];
                [request setFailedBlock:^{
                    [self hideActivityIndicator];
                    showMessageBox(@"提交失败，请重新提交数据。");
                }];
                [request startAsynchronous];
}
- (IBAction)toButtonClick:(id)sender {
    [self topButtonClick:sender];
}

-(void)getCommitDataForServer{
    
    //api/user/todayreported
    NSString *url = @"/api/user/todayreported";
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"get_todayreported_data_main"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            //            LoginUser * user = [LoginUser getLoginUserFromJson:reArg];
            NSDictionary *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                return;
            }
            NSString * data =[NSString stringWithFormat:@"%d",[[temp objectForKey:@"reportedSales"]intValue]];
            _lableForCommitSum.text=data;
            data = [NSString stringWithFormat:@"%d",[[temp objectForKey:@"unreportedNum"]intValue]];
            _lableForNoCommit.text = data;
                    }
        @catch (NSException *exception) {
            showAlertBox(@"提示", exception.reason);
            return;
        }
        @finally {
            
        }
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
    
}

-(void)getACommitData{
    if (loginuser.roelId!=4) {
        return;
    }
    //api/products/nameandid
    NSString *url = @"/api/products/nameandid";
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"getACommitData"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            //            LoginUser * user = [LoginUser getLoginUserFromJson:reArg];
            NSArray *temp = [reArg JSONValue];
            if(temp == nil){
                return;
            }
            for (int i= 0; i<temp.count; i++) {
                NSDictionary *dic = [temp objectAtIndex:i];
                int today = [NSDate new].day;
                int ids = [[dic objectForKey:@"id"]intValue];
                int num= [[dic objectForKey:@"productsReported"]intValue];
                NSString * numofproductskey = [NSString stringWithFormat:@"products_num_for_commit_data_and_date_%d",ids];
                NSString * numofproducts =[NSString stringWithFormat:@"%d:%d",today,num];
                [ConfigManage setConfig:numofproductskey Value:numofproducts];
            }
            [((UITableView *) [mainScrollView viewWithTag:20001]) reloadData];
            
        }
        @catch (NSException *exception) {
            showAlertBox(@"提示", exception.reason);
            return;
        }
        @finally {
            
        }
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}
@end
