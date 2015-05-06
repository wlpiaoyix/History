//
//  SellSystemViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-6.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "SellSystemViewController.h"
#import "DAPagesContainer.h"
#import "DataViewController.h"
#import "CollectDataViewController.h"
#import "ChangeValueForCommitSellViewController.h"
#import "CommitListCell.h" 
#import "ASIFormDataRequest.h"
#import "HttpApiCall.h"
#import "SelectReportViewController.h"
#import "UMSocial.h"
#import "UIViewController+MMDrawerController.h"
#import "CommitDataViewController.h"
#import "ShareUtils.h"
#import "DataForCommitViewController.h"
#import "KxMenu.h"

#define type_1 @"移动业务"
#define type_2 @"宽带业务"

@interface SellSystemViewController (){
    NSMutableArray * listForAssess;
    NSMutableArray * listForOther;
    bool isTableData;
    NSDictionary * selectDics;
    LoginUser * loginuser;
    bool hideCommit;
    bool isLoding;
    bool isFristPage;
    NSArray * listForProGroup;
    NSDate * queryDate;
    NSArray *menuItems;
}
@property (strong, nonatomic) DAPagesContainer *pagesContainer;

@end

@implementation SellSystemViewController



-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isDataTable:(bool)istable SelectDic:(NSDictionary *)selectdic isFristPage:(bool)isfrist{
   self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
   if(self) {
    // Custom initialization
       isTableData = istable;
       selectDics = selectdic;
       isLoding = NO;
       _isSelectPage= NO;
       isFristPage = isfrist;
       _orgId = -1;
    }
   return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isTableData = NO;
        isLoding = NO;
        _isSelectPage= NO;
        isFristPage = NO;
        _orgId = -1;
    }
    return self;
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    showMessageBox(msg);
}
 
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0: {
            
            CGRect frame= self.view.frame;
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(frame.size.width, frame.size.height), YES, 0);
            [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            //        CGImageRef imageRef = viewImage.CGImage;
            //        CGRect rect =CGRectMake(0, 0,frame.size.width*2, frame.size.height*2);//这里可以设置想要截图的区域
            //        CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
            //        UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
            UIImageWriteToSavedPhotosAlbum(viewImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);//保存图片到照片库
            //        NSData *imageViewData = UIImagePNGRepresentation(sendImage);
            //
            //        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            //        NSString *documentsDirectory = [paths objectAtIndex:0];
            //        NSString *pictureName= [NSString stringWithFormat:@"screenShow_%d.png",i];
            //        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:pictureName];
            //        NSLog(@"%@", savedImagePath);
            //        [imageViewData writeToFile:savedImagePath atomically:YES];//保存照片到沙盒目录
            //        CGImageRelease(imageRefRect);
        }
        break;
        case 1:{
            //如果需要分享回调，请将delegate对象设置self，并实现下面的回调方法
            CGRect frame= self.view.frame;
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(frame.size.width, frame.size.height), YES, 0);
            [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
          
            //如果需要分享回调，请将delegate对象设置self，并实现下面的回调方法
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:UMENG_APPKEY
                                              shareText:[ShareUtils getShareTypeString:0 Url:[NSString stringWithFormat:@"http://aksl.net/%@",TITLE_APP_EN] Title:@"分享数据图片"]
                                             shareImage:viewImage
                                        shareToSnsNames:[ShareUtils getSharePlatforms]
                                               delegate:nil];
   
        }
            break;
         default:
            break;
    }
}

- (void) handleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state ==
        UIGestureRecognizerStateBegan) {
        NSLog(@"UIGestureRecognizerStateBegan");
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"图表"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"保存为图片",@"分享",nil];
        [actionSheet showInView:self.view];
        
         }
    if (gestureRecognizer.state ==
        UIGestureRecognizerStateChanged) {
        NSLog(@"UIGestureRecognizerStateChanged");
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
    }
    
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
   
    if (isLoding) {
        [_CommitList reloadData];
        return;
    }
    if (hideCommit){
    CGRect farmes = _MainPage.frame;
    farmes.origin.y = 0;
    farmes.size.height+=5;
    self.pagesContainer.view.frame = farmes;
    [self getDataForServer];
        
    }else{
    [self getProductFromServer];
    }
}
-(void)getProductFromServer{
 [self showActivityIndicator];
 // /api/products/checkproducts/{hallType}/{startDate}/{endDate}
    NSString *url = @"/api/products/group";
    
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"get_products_data_main"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [self hideActivityIndicator];
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSMutableDictionary *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                showMessageBox(@"暂无数据");
                return;
            }
            listForAssess = [temp valueForKey:type_1];
            listForOther = [temp valueForKey:type_2];
            for (int i= 0; i<listForAssess.count; i++) {
                NSDictionary *dic = [listForAssess objectAtIndex:i];
                int today = [NSDate new].day;
                int ids = [[dic objectForKey:@"id"]intValue];
                int num= [[dic objectForKey:@"count"]intValue];
                NSString * numofproductskey = [NSString stringWithFormat:@"products_num_for_commit_data_and_date_%d",ids];
                NSString * numofproducts =[NSString stringWithFormat:@"%d:%d",today,num];
                [ConfigManage setConfig:numofproductskey Value:numofproducts];
            }
            for (int i= 0; i<listForOther.count; i++) {
                NSDictionary *dic = [listForOther objectAtIndex:i];
                int today = [NSDate new].day;
                int ids = [[dic objectForKey:@"id"]intValue];
                int num = [[dic objectForKey:@"count"]intValue];
                NSString * numofproductskey = [NSString stringWithFormat:@"products_num_for_commit_data_and_date_%d",ids];
                NSString * numofproducts =[NSString stringWithFormat:@"%d:%d",today,num];
                [ConfigManage setConfig:numofproductskey Value:numofproducts];
            }
            [_CommitList reloadData];
            [_commitView setHidden:NO];
            isLoding = YES;
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
-(void)getDataForServer{
    [self showActivityIndicator];
     //获取系统数据
    //api/data/default/{dataType}
    NSString *url =[NSString stringWithFormat:@"/api/data/default/%@/%ld/default/default",isTableData?@"system":@"report",_orgId];
    
    if (_isSelectPage) {
        //添加筛选数据
        url = [NSString stringWithFormat:@"/api/data%@",(isTableData?@"/system":@"")];

        //api/data/{dataType}/{tdType}/{products}/{area}/{fzz}/{tdName}/{startDate}/{endDate}
        NSString *data = [ConfigManage getConfig:DEF_tdType];
        if (data&&data.length>0) {
            url = [[url stringByAppendingString:@"/"]stringByAppendingString:data];
        }else if(loginuser.roelId == 4){
          url = [[url stringByAppendingString:@"/"]stringByAppendingString:[NSString stringWithFormat:@"%d",loginuser.organizationType]];
        }else{
          url = [[url stringByAppendingString:@"/"]stringByAppendingString:@"default"];
        }
        data = [ConfigManage getConfig:DEF_products];
        if (data&&data.length>0) {
            url = [[url stringByAppendingString:@"/"]stringByAppendingString:data];
        }else{
            url = [[url stringByAppendingString:@"/"]stringByAppendingString:@"default"];
        }
        data = [ConfigManage getConfig:DEF_Area];
        if (data&&data.length>0) {
            url = [[url stringByAppendingString:@"/"]stringByAppendingString:data];
        }else{
            url = [[url stringByAppendingString:@"/"]stringByAppendingString:@"default"];
        }
        data = [ConfigManage getConfig:DEF_Area_Fzz];
        if (data&&data.length>0) {
            url = [[url stringByAppendingString:@"/"]stringByAppendingString:data];
        }else{
            url = [[url stringByAppendingString:@"/"]stringByAppendingString:@"default"];
        }
        data = [ConfigManage getConfig:DEF_Area_TdName];
        if (data&&data.length>0) {
            url = [[url stringByAppendingString:@"/"]stringByAppendingString:data];
        }else if(loginuser.roelId == 4){
            url = [[url stringByAppendingString:@"/"]stringByAppendingString:loginuser.organizationID];
        }else{
         url = [[url stringByAppendingString:@"/"]stringByAppendingString:@"default"];
        }
        NSDate * start= [selectDics objectForKey:@"startDate"];
        NSDate * end = [selectDics objectForKey:@"endDate"];
        if (!start) {
            start = [NSDate new];
        }
        if (!end) {
            end = [NSDate new];
        }
        url =[[url stringByAppendingString:@"/"]stringByAppendingString:[NSDate dateFormateDate:start FormatePattern:@"yyyy-MM-dd"]];
        url =[[url stringByAppendingString:@"/"]stringByAppendingString:[NSDate dateFormateDate:end FormatePattern:@"yyyy-MM-dd"]];
    }
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"get_todayreported_data_main"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [self hideActivityIndicator];
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSDictionary *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                return;
            }
            NSMutableArray * viewAry =  [NSMutableArray new];
            queryDate =[NSDate dateFormateString:[temp valueForKey:@"queryDate"] FormatePattern:@"yyyy-MM-dd"];
            NSArray * productsName = [temp objectForKey:(isTableData?@"productsName":@"productsGroup")];
            listForProGroup = productsName;
            if (!productsName||productsName.count==0) {
                isLoding = YES;
                return;
            }
            
            for (int i=0;i<productsName.count;i++) {
                NSDictionary *dic = [productsName objectAtIndex:i];
                 NSString * nameTitle = [dic objectForKey:@"name"];
                if (!isTableData) {
                   
                   NSArray * header = [[temp valueForKey:@"headers"]valueForKey:nameTitle];
                     NSMutableArray * data = [[temp valueForKey:@"data"]valueForKey:nameTitle];
                    NSArray * total = [[temp valueForKey:@"total"]valueForKey:nameTitle];
                    DataForCommitViewController * view = [[DataForCommitViewController alloc]initWithNibName:@"DataForCommitViewController" bundle:nil];
                    view.title = nameTitle;
                    NSString * strId = [dic valueForKey:@"id"];
                    view.pid = [strId intValue];
                    view.fristName = header;
                    view.sellpage = self;
                    if (data&&data.count>0) {
                        
                        NSMutableDictionary * dic = [NSMutableDictionary new];
                        [dic setValue:@"合计" forKey:@"area"];
                        if (total.count>0)
                        [dic setValue:[NSNumber numberWithInt:[total[0]intValue]] forKey:@"completeOne"];
                        if (total.count>1)
                        [dic setValue:[NSNumber numberWithInt:[total[1]intValue]] forKey:@"completeTwo"];
                        if (total.count>2)
                        [dic setValue:[NSNumber numberWithInt:[total[2]intValue]] forKey:@"completeThree"];
                        if (total.count>3)
                        [dic setValue:[NSNumber numberWithInt:[total[3]intValue]] forKey:@"completeFour"];
                        [data addObject:dic];
                        view.listForData = data;
                    }
                    [viewAry addObject:view];
                }else if (_isSelectPage) {
                    NSMutableArray * data = [temp valueForKey:@"data"];
                    NSArray * total = [temp valueForKey:@"total"];
                    NSArray * header = [temp valueForKey:@"header"];
                    //判断是否为筛选结果
                   CollectDataViewController * view = [[CollectDataViewController alloc]initWithNibName:@"CollectDataViewController" bundle:nil];
                    view.title = nameTitle;
                    view.pid = [[dic valueForKey:@"id"]longValue];
                    view.fristName = header;
                    view.sellpage = self;
                    if (data&&data.count>0) {
                    view.listForData = [data objectAtIndex:i];
                    view.listForTotal = [[total objectAtIndex:i]integerValue];
                    }
                    NSDate * start= [selectDics objectForKey:@"startDate"];
                    NSDate * end = [selectDics objectForKey:@"endDate"];
                    if (!start) {
                        start = [NSDate new];
                    }
                    if (!end) {
                        end = [NSDate new];
                    }
                    view.startTimeStr = [NSDate dateFormateDate:start FormatePattern:@"yyyy-MM-dd"];
                    view.endTimeStr =[NSDate dateFormateDate:end FormatePattern:@"yyyy-MM-dd"];
                    [viewAry addObject:view];
                }else if (isTableData){
                     NSMutableArray * data = [temp valueForKey:@"data"];
                    NSArray * total = [temp valueForKey:@"total"];
                    NSArray * header = [temp valueForKey:@"header"];
                    //如果是系统数据
                        DataViewController * view = [[DataViewController alloc]initWithNibName:@"DataViewController" bundle:nil];
                        view.title = nameTitle;
                        view.pid = [[dic valueForKey:@"id"]longValue];
                        view.fristName = header;
                        view.sellpage = self;
                        if (data&&data.count>0) {
                            view.listForData = [data objectAtIndex:i];
                            view.listForTotal = [total objectAtIndex:i];
                        }
                        [viewAry addObject:view];
                }
            }
            
            if(viewAry.count>0){
                self.pagesContainer.viewControllers = viewAry;
            }
            isLoding = YES;
            [_MainPage setHidden:NO];
            
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (isFristPage) {
        [_toButtonLeft setImage:[UIImage imageNamed:@"icon_w_menu.png"] forState:UIControlStateNormal];
        
    }
    _TitleName.text = self.title;
    loginuser = [ConfigManage getLoginUser];
     hideCommit = isTableData||loginuser.roelId!=4||_isSelectPage;
    
    [_commitView setHidden:YES];
    [_MainPage setHidden:YES];
    // Do any additional setup after loading the view from its nib.
    if (hideCommit) {
        UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(handleTableviewCellLongPressed:)];
        //代理
        longPress.delegate = self;
        longPress.minimumPressDuration = 1.0;
        //将长按手势添加到需要实现长按操作的视图里
        [self.MainPage addGestureRecognizer:longPress];
    //配置滑动页面
    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.pagesContainer.topBarBackgroundColor = [UIColor whiteColor];
    [_MainPage addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];
    }
    
    if (loginuser.roelId == 3 && !isTableData) {
        [_buttonForSum setImage:[UIImage imageNamed:@"icon_w_commitOk.png"] forState:UIControlStateNormal];
        [KxMenu setTintColor: [UIColor colorWithRed:0.518 green:0.714 blue:0.078 alpha:1]];
      menuItems=  @[
          
          [KxMenuItem menuItem:@"  确认上报  "
                         image:nil
                        target:self
                        action:@selector(pushMenuItem:)
                           key:@"com"],
          
          [KxMenuItem menuItem:@"  筛选  "
                         image:nil
                        target:self
                        action:@selector(pushMenuItem:)
                           key:@"sel"],

          ];

    }
    //配置上报页面
    [self setCornerRadiusAndBorder:_CommitList];
    UINib *nib = [UINib nibWithNibName:@"CommitListCell" bundle:nil];
    [_CommitList registerNib:nib forCellReuseIdentifier:@"CommitDataCell"];
    //配置筛选按钮
    if (selectDics) {
        [_buttonForSum setHidden:YES];
        [_buttonForSum setEnabled:NO];
    }
}

- (void) pushMenuItem:(KxMenuItem *)sender
{
    NSLog(@"%@", sender.keyValue);
   NSString * sortSelect = sender.keyValue;
    if ([@"com" isEqualToString:sortSelect] ) {
        NSString * strtoday =  [ConfigManage getConfig:[@"today_commit_text_ok_" stringByAppendingString:loginuser.userId]];
        
        NSString * notestr =@"确定上报数据后，将致使厅店今日无法再上报或修改上报数据，您是否要确认上报短信。";
        if (strtoday&&[strtoday intValue] == [NSDate new].day){
            notestr =@"您已经确认过上报数据，厅店已经无法上报数据。";
        }
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"温馨提示" message:notestr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        [alert show];
    }
     if ([@"sel" isEqualToString:sortSelect] ) {
         SelectReportViewController * view = [[SelectReportViewController alloc]initWithNibName:@"SelectReportViewController" bundle:nil];
         view.isTableData = isTableData;
         view.queryDate = queryDate;
         if (isFristPage) {
             [self.mm_drawerController.navigationController pushViewController:view animated:YES];
         }else{
             [self.navigationController pushViewController:view animated:YES];
         }
     }
   // [self updataFromServer:NO];
}

- (IBAction)goBack:(id)sender {
    if (isFristPage) {
        [self topButtonClick:sender];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}


//Table DataSoucre
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //考核产品
    if(section==0&&listForAssess){
        return listForAssess.count;
    }
    //非考核产品
    if (section==1&&listForOther) {
        return listForOther.count;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (listForOther&&listForOther.count>0) {
        return 2;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  28;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [@"    " stringByAppendingString:type_1];
        case 1:
            return  [@"    " stringByAppendingString:type_2];
    }
    return @"";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommitListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommitDataCell"];
   NSDictionary *dic;
    if (indexPath.section==0) {
        dic =  [listForAssess objectAtIndex:indexPath.row];
    }else if(indexPath.section == 1){
        dic =  [listForOther objectAtIndex:indexPath.row];
    }
    
    NSString * numofproductskey = [NSString stringWithFormat:@"products_num_for_commit_data_and_date_%d",[[dic objectForKey:@"id"]intValue]];
    NSString * numofproducts =[ConfigManage getConfig:numofproductskey];
    int today = [NSDate new].day;
    int sum = 0;
    if(numofproducts){
        NSArray * ar = [numofproducts componentsSeparatedByString:@":"];
        if(today == [[ar objectAtIndex:0]intValue]){
            sum = [[ar objectAtIndex:1]intValue];
        }
    }

    [cell setData:[dic objectForKey:@"name"] Value:sum];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChangeValueForCommitSellViewController * view = [[ChangeValueForCommitSellViewController alloc]initWithNibName:@"ChangeValueForCommitSellViewController" bundle:nil];
    NSDictionary *dic;
    if (indexPath.section==0) {
        dic =  [listForAssess objectAtIndex:indexPath.row];
    }else if(indexPath.section == 1){
        dic =  [listForOther objectAtIndex:indexPath.row];
    }
    NSString * name= [dic objectForKey:@"name"];
    int ids = [[dic objectForKey:@"id"]intValue];
    [view setData:name ID:ids];
    [self.mm_drawerController.navigationController pushViewController:view animated:YES];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        CommitDataViewController * commit = [[CommitDataViewController alloc]initWithNibName:@"CommitDataViewController" bundle:Nil];
        commit.isTableData = isTableData;
        commit.selectDic =nil;
        [self.mm_drawerController.navigationController pushViewController:commit animated:YES];
    }
}
 

- (IBAction)goFiler:(UIButton *)sender {
    if (loginuser.roelId == 3&&!isTableData) {
        [KxMenu showMenuInView:self.view
                      fromRect:sender.frame
                     menuItems:menuItems];
    }else{
    SelectReportViewController * view = [[SelectReportViewController alloc]initWithNibName:@"SelectReportViewController" bundle:nil];
    view.isTableData = isTableData;
        view.queryDate = queryDate;
        if (isFristPage) {
            [self.mm_drawerController.navigationController pushViewController:view animated:YES];
        }else{
        [self.navigationController pushViewController:view animated:YES];
        }
    
    }
}

-(void)toNextPage:(long)NextOrgId Title:(NSString *)title{
    if (NextOrgId == -1 || _isSelectPage) {
        return;
    }
    SellSystemViewController * sell = [[SellSystemViewController alloc]initWithNibName:@"SellSystemViewController" bundle:nil isDataTable:isTableData SelectDic:nil isFristPage:NO];
    sell.isSelectPage = NO;
    sell.orgId = NextOrgId;
    sell.title =title;
    if (isFristPage) {
      [self.mm_drawerController.navigationController pushViewController:sell animated:YES];
    }else{
    [self.navigationController pushViewController:sell animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
