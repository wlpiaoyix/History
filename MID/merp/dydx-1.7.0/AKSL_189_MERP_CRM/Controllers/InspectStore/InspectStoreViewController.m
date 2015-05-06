//
//  InspectStoreViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-17.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "InspectStoreViewController.h"
#import "InspectStoreCell.h"
#import "DAPagesContainer.h"
#import "InspectStoreListViewController.h"
#import "AddInspectStoreViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "HttpApiCall.h"
#import "InspectStoreSelectViewController.h"
#import "NotesImageViewController.h"
#import "InspectStoreInfo.h"
#import "SingeInspectStoreCell.h"
#import "MyTourroundViewController.h"

@interface InspectStoreViewController (){
    bool isLonding;
    NSMutableArray * listForData;
    int maxCount;
    UITableView *tableViewForQuery;
    LoginUser * longinUser;
    long CurrInspectIdForZanPingjia;
    long CurrPepoleId;
    long CurrCommentId;
    NSString * CurrpepoleName;
    BOOL CurrIsZan;
    int indexForData;
    int CountForMsgData;
    bool isShowPingjiaInput;
}

@property (strong, nonatomic) DAPagesContainer *pagesContainer;

@end

@implementation InspectStoreViewController

-(NSArray *)getListType{
    return listForTypeName;
}
-(void)setChangeType:(long)typeId{
    changetypeId = typeId;
}
static InspectStoreViewController * inspectstore;
static NSArray * listForTypeName;
static long changetypeId;
+(InspectStoreViewController *)getInspectStoreMain{
    if (!inspectstore) {
        inspectstore = [[InspectStoreViewController alloc]initWithNibName:@"InspectStoreViewController" bundle:nil];
        inspectstore.isQueryRest = NO;
    }
    return inspectstore;

}
+(void)newInspectStore{
    if(inspectstore){
        [inspectstore removeFromParentViewController];
        inspectstore = nil;
    }
    inspectstore = [[InspectStoreViewController alloc]initWithNibName:@"InspectStoreViewController" bundle:nil];

}

-(void)clearNotReadMsg{
    CountForMsgData = 0;
    NSArray * views = self.pagesContainer.viewControllers;
    for (InspectStoreListViewController *view in views) {
        view.CountForMsg = 0;
        [view reloadData];
    }

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!isLonding) {
        if (_isQueryRest) {
            [self updataFromServer:NO];
        }else{
            [self getCountForMsgData];
            CGRect farmes = _MainPage.frame;
            farmes.origin.y = 0;
            farmes.size.height+=5;
            self.pagesContainer.view.frame = farmes;
        }
    }else if(changetypeId>0){
        NSArray * views = self.pagesContainer.viewControllers;
        for (InspectStoreListViewController *view in views) {
            if (view.ids == changetypeId) {
                view.isChangeData = YES;
                [view reloadData:NO];
            }
        }
        changetypeId =-1;
    }
}

-(void)DidSelectedIndex:(NSUInteger)selectedIndex{
    InspectStoreListViewController *view = (InspectStoreListViewController *) self.pagesContainer.viewControllers[selectedIndex];
    [self hideZanpingjia];
    [view reloadData:YES];
}
-(void)hideZanpingjia{
    _viewZanpingjia.hidden = YES;
    [_TextInputPingjia resignFirstResponder];
    [_viewPingjiaInput setHidden:YES];
    isShowPingjiaInput = NO;
}

-(void)showPingjia:(long)inspectID indexForData:(int)index pId:(long)p_id pname:(NSString *)pname cId:(long)c_id{
    
    if (isShowPingjiaInput) {
        [self hideZanpingjia];
        return;
    }else{
    [self hideZanpingjia];
    }
  CurrInspectIdForZanPingjia = inspectID;
  indexForData = index;
    CurrPepoleId = p_id;
    CurrpepoleName = pname;
    CurrCommentId = c_id;
    [_TextInputPingjia setText:@""];
    [_TextInputPingjia setPlaceholder:[@"回复" stringByAppendingString:pname]];
    [_viewPingjiaInput setHidden:NO];
    [_TextInputPingjia becomeFirstResponder];
    isShowPingjiaInput = YES;
}
-(void)showZanpingjia:(long)inspectID isZan:(BOOL)isZan Top:(CGFloat)top indexForData:(int)index{
    isShowPingjiaInput = YES;
    CurrInspectIdForZanPingjia = inspectID;
    _viewZanpingjia.hidden = NO;
    CurrIsZan = isZan;
    indexForData = index;
    CGRect farme = _viewZanpingjia.frame;
    farme.size.width = 0;
    farme.origin.y = top;
    if (_isQueryRest) {
        farme.origin.y +=130-tableViewForQuery.contentOffset.y;
        if (_isSingeInfo) {
            farme.origin.y+= 62;
        }
    }else{
        farme.origin.y +=166 -((InspectStoreListViewController *)self.pagesContainer.viewControllers[self.pagesContainer.selectedIndex]).tableView.contentOffset.y;
    }
    [_butZanOrCans setImage:[UIImage imageNamed:(CurrIsZan?@"icon_g_like_quxiao.png":@"icon_g_like_zan.png")] forState:UIControlStateNormal];
    [_butZanOrCans setTitle:(CurrIsZan?@"取消":@"赞") forState:UIControlStateNormal];
    _viewZanpingjia.frame = farme;
   
    [UIView animateWithDuration:0.2 animations:^{
        CGRect farme = _viewZanpingjia.frame;
        farme.size.width = 170;
        _viewZanpingjia.frame = farme;
    }];
}

-(void)intputshow:(NSNotification *)notification{
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
       CGRect frame = _viewPingjiaInput.frame;
        frame.origin.y = self.view.frame.size.height - keyBoardFrame.size.height - frame.size.height;
        _viewPingjiaInput.frame = frame;
    }];
    
}
-(void)intputhide:(NSNotification *)notification{
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect frmeimage = _viewPingjiaInput.frame;
        frmeimage.origin.y =self.view.frame.size.height - frmeimage.size.height;
        _viewPingjiaInput.frame = frmeimage;
    }];

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(intputshow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(intputhide:) name:UIKeyboardWillHideNotification object:nil];
    isShowPingjiaInput =NO;
    isLonding = NO;
    changetypeId = -1;
    longinUser = [ConfigManage getLoginUser];
    [self setCornerRadiusAndBorder:_viewZanpingjia];
    [self setCornerRadiusAndBorder:_butSendPingjia];
    
    if (_isQueryRest) {
        _textForTitle.text =_isSingeInfo?@"详情":@"巡一巡查询结果";
        [_toQueryButton setHidden:YES];
        [_toQueryButton setEnabled:NO];
        CGRect frame = _MainPage.frame;
        frame.size.height+=45;
        _MainPage.frame = frame;
        tableViewForQuery = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _MainPage.frame.size.width,_MainPage.frame.size.height)];
        tableViewForQuery.delegate = self;
        tableViewForQuery.dataSource = self;
        tableViewForQuery.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableViewForQuery.backgroundColor = [UIColor clearColor];
        tableViewForQuery.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        if(IOS7_OR_LATER)
            tableViewForQuery.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        NSString *CustomCellNibName = @"InspectStoreCell";
        UINib *nib = [UINib nibWithNibName:CustomCellNibName bundle:nil];
        [tableViewForQuery registerNib:nib forCellReuseIdentifier:CustomCellNibName];
        CustomCellNibName  = @"SingeInspectStoreCell";
        UINib *nib1 = [UINib nibWithNibName:CustomCellNibName bundle:nil];
        [tableViewForQuery registerNib:nib1 forCellReuseIdentifier:CustomCellNibName];
        [_MainPage addSubview:tableViewForQuery];
    }else{
     [_toLeftButton setImage:[UIImage imageNamed:@"icon_w_menu.png"] forState:UIControlStateNormal];
        //配置滑动页面
        self.pagesContainer = [[DAPagesContainer alloc] init];
        [self.pagesContainer willMoveToParentViewController:self];
        self.pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.pagesContainer.topBarBackgroundColor = [UIColor whiteColor];
        [_MainPage addSubview:self.pagesContainer.view];
        self.pagesContainer.delegate = self;
        [self.pagesContainer didMoveToParentViewController:self];
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)reloadData{
    if (_isQueryRest) {
        [tableViewForQuery reloadData];
    }else{
        [((InspectStoreListViewController *)self.pagesContainer.viewControllers[self.pagesContainer.selectedIndex]) reloadData];
    }
}
-(void)getCountForMsgData{
    
    NSString * url =@"/api/like/messagecount";
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"getCountForMsgData_main"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [self hideActivityIndicator];
         [self getServerType];
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSDictionary *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                showMessageBox(@"暂无数据");
                return;
            }
            CountForMsgData = 0;
            if ([[temp valueForKey:@"status"]isEqualToString:@"success"]) {
            CountForMsgData = [[[temp valueForKey:@"data"]valueForKey:@"count"]intValue];
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
         [self getServerType];
    }];
    [request startAsynchronous];
    
}
-(void)getSingerData{
    if (listForData) {
        return;
    }
    NSString * url =[NSString stringWithFormat:@"/api/attendances/messages/%ld",_QueryInspectId];
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
            
            if (!listForData) {
                listForData = [NSMutableArray new];
            }
            [listForData addObject:[InspectStoreInfo getInspectStoreInfo:[temp valueForKey:@"data"][0]]];
            isLonding = YES;
            [tableViewForQuery reloadData];
            
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
   
    [[HttpApiCall requestCallGET:@"/api/clientlogs/1" Params:nil Logo:@"study_detail_log"] startAsynchronous];
    
}
-(void)updataFromServer:(bool)isAdd{
    if (_isSingeInfo) {
        [self getSingerData];
        return;
    }
    int pageSize = 11;
    int startIndex = 1;
    if(isAdd&&listForData){
        if (listForData.count>=maxCount){
            return;
        }else{
            startIndex = listForData.count+1;
        }
    }
    [self showActivityIndicator];
    //api/attendances/{startIndex}/{count}/{area}/{fzz}/{td}
    NSString *url = [NSString stringWithFormat:@"/api/attendances/flatmessages/%d/%d",startIndex,pageSize];
   NSString * data = [ConfigManage getConfig:DEF_Area_inspect];
    if (data&&data.length>0) {
        url = [[url stringByAppendingString:@"/"]stringByAppendingString:data];
    }else{
        url = [[url stringByAppendingString:@"/"]stringByAppendingString:@"default"];
    }
    data = [ConfigManage getConfig:DEF_Area_Fzz_inspect];
    if (data&&data.length>0) {
        url = [[url stringByAppendingString:@"/"]stringByAppendingString:data];
    }else{
        url = [[url stringByAppendingString:@"/"]stringByAppendingString:@"default"];
    }
    data = [ConfigManage getConfig:DEF_Area_TdName_inspect];
    if (data&&data.length>0) {
        url = [[url stringByAppendingString:@"/"]stringByAppendingString:data];
    }else if(longinUser.roelId == 4){
        url = [[url stringByAppendingString:@"/"]stringByAppendingString:longinUser.organizationID];
    }else{
        url = [[url stringByAppendingString:@"/"]stringByAppendingString:@"default"];
    }

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
            isLonding = YES;
            [tableViewForQuery reloadData];
            
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

-(void)getServerType{
  ///api/dic/attendancestypes
         NSString *url = @"/api/dic/attendancestypes";
    
         ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"get_attendancestypes_data_main"];
        __weak ASIFormDataRequest *request = requestx;
         [request setCompletionBlock:^{
             [request setResponseEncoding:NSUTF8StringEncoding];
             NSString *reArg = [request responseString];
             @try {
                 NSMutableArray *temp = [reArg JSONValueNewMy];
                if(temp == nil){
                    showMessageBox(@"暂无数据");
                    return;
                }
                 listForTypeName = temp;
                 NSMutableArray * aryView = [NSMutableArray new];
                 for (int i =0 ; i<listForTypeName.count; i++) {
                     InspectStoreListViewController * list = [[InspectStoreListViewController alloc]initWithNibName:@"InspectStoreListViewController" bundle:nil];
                     list.title = listForTypeName[i][1];
                     list.ids = [(listForTypeName[i][0])longValue];
                     list.CountForMsg = CountForMsgData;
                     [list setMainView:self];
                     [aryView addObject:list];
                 }
                 if (aryView.count>0) { 
                     self.pagesContainer.viewControllers = aryView;
                     isLonding = YES;
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
         }];
      [request startAsynchronous];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)toLeftClick:(id)sender {
    if (_isQueryRest) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [self topButtonClick:sender];
}
- (IBAction)toAdd:(id)sender {
    AddInspectStoreViewController * view = [[AddInspectStoreViewController alloc]initWithNibName:@"AddInspectStoreViewController" bundle:nil];
    [self.mm_drawerController.navigationController pushViewController:view animated:YES];
}
- (IBAction)toFiler:(id)sender {
    InspectStoreSelectViewController * view = [[InspectStoreSelectViewController alloc]initWithNibName:@"InspectStoreSelectViewController" bundle:nil];
    [self.mm_drawerController.navigationController pushViewController:view animated:YES];
}


//Table DataSoucre
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(listForData){
        return listForData.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     InspectStoreInfo * info = listForData[indexPath.row];
    if (_isSingeInfo) {
        return info.hieghtForZanpingjia + 72;
    }
    return info.hieghtForZanpingjia;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   InspectStoreInfo * info = listForData[indexPath.row];
    if (_isSingeInfo) {
        SingeInspectStoreCell * singer = [tableView dequeueReusableCellWithIdentifier:@"SingeInspectStoreCell"];
        [singer setData:info inspectView:self indexInListData:indexPath.row];
        return singer;
    }
    
    InspectStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InspectStoreCell"];
    
    NSDate * date = info.date;
    bool isshowdate = YES;
    if (indexPath.row>0) {
        NSDate * pdate = [(InspectStoreInfo *)listForData[indexPath.row-1] date];
        if (![pdate compareDate:0 compareDate:date]) {
            isshowdate = NO;
        }
    }
    [cell setData:info isShowDate:isshowdate inspectView:self indexInListData:indexPath.row];
    if (indexPath.row==listForData.count-1) {
        [self updataFromServer:YES];
    }
    return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self hideZanpingjia];
}
//数据项被选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isShowPingjiaInput) {
        [self hideZanpingjia];
        return;
    }
    
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
                [self.navigationController pushViewController:l animated:YES];
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    NSString *url = @"/api/comment";
    NSMutableString * conent =[[NSMutableString alloc]initWithString:_TextInputPingjia.text];
    [conent replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [conent length])];
   NSString * commitData =[NSString stringWithFormat:@"{\"attendencesId\": %ld,\"parentId\": %ld,\"content\": \"%@\",\"toUserId\":%ld}",CurrInspectIdForZanPingjia,CurrCommentId,conent,CurrPepoleId];
    
    ASIFormDataRequest *requestx = [HttpApiCall requestCallPOST:url Params:[commitData JSONValue] Logo:@"yunyiyun_pingjia_main"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSMutableArray *temp = [reArg JSONValueNewMy];
            if(temp == nil ){
                
                return;
            }
            if ([[temp valueForKey:@"status"]isEqualToString:@"success"]) {
                
                InspectStoreInfo * info;
                if (_isQueryRest) {
                    info = listForData[indexForData];
                }else{
                    info = [((InspectStoreListViewController *)self.pagesContainer.viewControllers[self.pagesContainer.selectedIndex]) getInspectStroeInfo:indexForData];
                }
                
                NSMutableDictionary * tempD = [temp valueForKey:@"comments"];
                
                CommentInfo * comment = [CommentInfo getCommentInfo:[[tempD valueForKey:@"id"]longValue] Content:[tempD valueForKey:@"content"] ToUserName:CurrpepoleName];
                [info addComment:comment];
                if (_isQueryRest) {
                    [tableViewForQuery reloadData];
                }else{
                    [((InspectStoreListViewController *)self.pagesContainer.viewControllers[self.pagesContainer.selectedIndex]) reloadData];
                }

            }else{
                showMessageBox(@"评价失败，请重新提交。");
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
    }];
    [request startAsynchronous];
    [self hideZanpingjia];

    return YES;
}

- (IBAction)ZanClick:(id)sender {
    [self hideZanpingjia];
    if (CurrIsZan) {
        [self quxiaoZanToServer];
    }else{
    [self zanToServer];
    }
}

-(void)quxiaoZanToServer{
    InspectStoreInfo * info;
    if (_isQueryRest) {
     info = listForData[indexForData];
    }else{
    info = [((InspectStoreListViewController *)self.pagesContainer.viewControllers[self.pagesContainer.selectedIndex]) getInspectStroeInfo:indexForData];
    }
    NSString *url = [NSString stringWithFormat:@"/api/like/%ld",info.selfZanId];
    [self showActivityIndicator];
    ASIFormDataRequest *requestx = [HttpApiCall requestCallDELET:url Logo:@"yunyiyun_quxiaozan_main"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [self hideActivityIndicator];
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSMutableArray *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                
                return;
            }
            if ([[temp valueForKey:@"status"]isEqualToString:@"success"]) {
                //  showMessageBox(@"评价成功！");
                [info removeSelfZan];
                if (_isQueryRest) {
                    [tableViewForQuery reloadData];
                }else{
                    [((InspectStoreListViewController *)self.pagesContainer.viewControllers[self.pagesContainer.selectedIndex]) reloadData];
                }
            
            }else{
                showMessageBox(@"评价失败，请重新提交。");
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

-(void)zanToServer{
    NSString *url = [NSString stringWithFormat:@"/api/like/%ld",CurrInspectIdForZanPingjia];
    [self showActivityIndicator];
    ASIFormDataRequest *requestx = [HttpApiCall requestCallPOST:url Params:nil Logo:@"yunyiyun_zan_main"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
         [self hideActivityIndicator];
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSMutableArray *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                
                return;
            }
            if ([[temp valueForKey:@"status"]isEqualToString:@"success"]) {
                //  showMessageBox(@"评价成功！");
                InspectStoreInfo * info;
                if (_isQueryRest) {
                    info = listForData[indexForData];
                }else{
                    info = [((InspectStoreListViewController *)self.pagesContainer.viewControllers[self.pagesContainer.selectedIndex]) getInspectStroeInfo:indexForData];
                }
                
             NSMutableDictionary * likenew = [temp valueForKey:@"like"];
            [likenew setObject:[NSNumber numberWithLong:longinUser.userDataId] forKey:@"userId"];
            [likenew setObject:longinUser.username forKey:@"userName"];
                [info addZan:likenew];
                if (_isQueryRest) {
                    [tableViewForQuery reloadData];
                }else{
                    [((InspectStoreListViewController *)self.pagesContainer.viewControllers[self.pagesContainer.selectedIndex]) reloadData];
                }

            }else{
                showMessageBox(@"评价失败，请重新提交。");
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
- (IBAction)PingjiaClick:(id)sender {
    [self hideZanpingjia];
    CurrPepoleId = -1;
    CurrCommentId = -1;
    CurrpepoleName = nil;
    [_TextInputPingjia setText:@""];
    [_TextInputPingjia setPlaceholder:@"评价内容"];
    [_viewPingjiaInput setHidden:NO];
    [_TextInputPingjia becomeFirstResponder];
    isShowPingjiaInput = YES;
    
    
}
- (IBAction)CancelPingjia:(id)sender {
    [self hideZanpingjia];
}
-(BOOL)isShowPingjiaInput{
    return isShowPingjiaInput;
}
-(void)showPeopleList:(NSString *)userCode{
    MyTourroundViewController * view = [[MyTourroundViewController alloc]initWithNibName:@"MyTourroundViewController" bundle:nil];
    [view setUserCode:userCode];
    if (self.isQueryRest) {
        [self.navigationController pushViewController:view animated:YES];
    }else{
        [self.mm_drawerController.navigationController pushViewController:view animated:YES];
    }
}
@end
