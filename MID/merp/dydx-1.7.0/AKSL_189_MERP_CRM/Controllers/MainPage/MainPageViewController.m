//
//  MainPageViewController.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-10-21.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "MainPageViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "SellDataViewController.h"
#import "LeftMenuViewController.h"
#import "MyScheduleViewController.h"
#import "ChatViewController.h"
#import "LoginUser.h"
#import "ASIFormDataRequest.h"
#import "HttpApiCall.h"
#import "PublicInfo.h"
#import "Schedule.h"
#import "SVPullToRefresh.h"
#import "MainNotesCell.h"
#import "CountForMsgCell.h"
#import "JSON.h" 
#import "SellSystemViewController.h"
#import "KnowledgeBaseViewController.h"
#import "MessageListViewController.h"
#import "CompulsoryUpdateController.h"

@interface MainPageViewController (){

    int countForXunyixunTitle;
    int updateType;
}

@end

@implementation MainPageViewController

static MainPageViewController * mainpage;

+(id)getMainPage{
    if (!mainpage) {
        mainpage = [[MainPageViewController alloc]initWithNibName:@"MainPageViewController" bundle:nil];
    }
    return mainpage;
}

+(void)NewMainPage{
    if(mainpage){
        [mainpage removeFromParentViewController];
        mainpage = nil;
    }
    mainpage = [[MainPageViewController alloc]initWithNibName:@"MainPageViewController" bundle:nil];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         
    }
    return self;
}
- (IBAction)commitDataClick:(id)sender {
    [self changeCommitDataViewHided:0.5];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    LoginUser *user = [ConfigManage getLoginUser];
    _pageContrl.hidden = YES;
    // Do any additional setup after loading the view from its nib.
    //头像设置
    _userHeaderImg.layer.cornerRadius = 25;
    _userHeaderImg.imageUrl = nil;
    _userHeaderImg.imageUrl = user.headerImageUrl; 
    [self getRefreshData];
    if(user.roelId != 4&&user.roelId!=6){
    [self getCommitDataForServer];
     _toXiaoShouZC.enabled = NO;
    }
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
               // showMessageBox(@"暂无数据");
                return;
            }
        UIButton * but = (UIButton *)[_dataForSell viewWithTag:1001];
            NSString * data =[NSString stringWithFormat:@"%d",[[temp objectForKey:@"reportedSales"]intValue]];
        [but setTitle:data forState:UIControlStateNormal];
            but = (UIButton *)[_dataForSell viewWithTag:1002];
            int s = [[temp objectForKey:@"reportedNum"]intValue];
            data =[NSString stringWithFormat:@"%d",[[temp objectForKey:@"reportedNum"]intValue]];// [temp objectForKey:@"reportedNum"];
            [but setTitle:data forState:UIControlStateNormal];
            but = (UIButton *)[_dataForSell viewWithTag:1003];
            data = [NSString stringWithFormat:@"%d",[[temp objectForKey:@"unreportedNum"]intValue]];// [temp objectForKey:@"unreportedNum"];
            [but setTitle:data forState:UIControlStateNormal];
            but = (UIButton *)[_dataForSell viewWithTag:1004];
            data =[NSString stringWithFormat:@"%d",[[temp objectForKey:@"yesterdaySales"]intValue]];// [temp objectForKey:@"yesterdaySales"];
            [but setTitle:data forState:UIControlStateNormal];
            if(commitDataViewIsHide && s>0){
                [self changeCommitDataViewHided:0.3];
            }else if(!commitDataViewIsHide && s<=0){
                [self changeCommitDataViewHided:0.3];
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
-(void)getNewNotesData:(NSString *)type{
    
    NSString *url = [NSString stringWithFormat:@"/api/publicinfo/%d/%d/%@",1,3,type];
    
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
            if ([type isEqualToString:@"notice"]) {
            NSArray * data = [temp objectForKey:@"data"];
            if (data.count==0) {
                return;
            }
            if(!notelist){
                notelist = [NSMutableArray new];
            }
            [notelist removeAllObjects];
            for (int i=0; i<data.count; i++) {
                PublicInfo *info = [PublicInfo getPulicInfoByDic:[data objectAtIndex:i]];
                [notelist addObject:info];
            }
            [_myDayli reloadData];
            }
            
            if([type isEqualToString:@"ad"]){
                NSArray * data = [temp objectForKey:@"data"];
                if (data.count==0) {
                    return;
                }
                CGRect farme = _ScrollImageView.frame;
                farme.origin.x = 0;
                farme.origin.y = 0;
                for (int i = 0; i<data.count; i++) {
                    EMAsyncImageView * image = [[EMAsyncImageView alloc]initWithFrame:farme];
                    image.layer.cornerRadius = 0;
                    PublicInfo *info = [PublicInfo getPulicInfoByDic:[data objectAtIndex:i]];
                    image.imageUrl = nil;
                    image.imageUrl = info.picUrl;
                    [_ScrollImageView addSubview:image];
                    farme.origin.x += farme.size.width;
                }
                [self setCornerRadiusAndBorder:_ScrollImageView];
                _ScrollImageView.contentSize = CGSizeMake(farme.size.width*data.count, farme.size.height);
                [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(ontimer:) userInfo:nil repeats:YES];
                
                
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
-(void)getNewScheduleData{
  ///api/schedules/schedulesandnotice
   
   NSString * url= @"/api/schedules/schedulesandnotice";
      ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"get_current_month_schedules"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSDictionary * data = [reArg JSONValueNewMy];
            if (!data) {
                return;
            }
            countForXunyixunTitle =[[data valueForKey:@"unreadCommentCount"]intValue];
            if(!mydaylistData){
                mydaylistData = [NSMutableArray new];
            }
            [mydaylistData removeAllObjects];
            NSArray * ary = [data valueForKey:@"schedules"];
            int row = ary.count>3?3:ary.count;
            for (int i=0; i<row; i++) {
                Schedule *info =[Schedule getScheduleByDic:[ary objectAtIndex:i]];
                [mydaylistData addObject:info];
            }
            NSArray * noteAry = [data valueForKey:@"notice"];
            if(!notelist){
                notelist = [NSMutableArray new];
            }
            [notelist removeAllObjects];
            for (int i=0; i<noteAry.count; i++) {
                PublicInfo *info = [PublicInfo getPulicInfoByDic:[noteAry objectAtIndex:i]];
                [notelist addObject:info];
            }

            [_myDayli reloadData];
        }
        @catch (NSException *exception) {
            
            showAlertBox(@"提示", exception.reason);
        }
        @finally {
            [self hideActivityIndicator];
        }
        
    }];
    [request setFailedBlock:^{
        
    }];
    
    [request startAsynchronous];
    
}
-(void)getRefreshData{
   // [self getNewNotesData:@"notice"];
    [self getNewScheduleData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateVer];
    commitDataViewIsHide =NO;
    
    LoginUser *user = [ConfigManage getLoginUser];
    _pageContrl.hidden = YES;
    // 进度条显示
    [self setCornerRadiusAndBorder:_progress_label];
    [self setCornerRadiusAndBorder:_progress_label_bg];
    if(user.roelId>=3){
    [UIView animateWithDuration:1 animations:^{
        CGRect frame = _progress_label.frame;
        float ta =user.progressFloat;
        if (ta>1) {
            frame.size.width=_progress_label_bg.frame.size.width;
        }else{
          frame.size.width=_progress_label_bg.frame.size.width*ta;
        }
        _progress_label.frame = frame;
    }];
    _rankSet.text = user.rankString;
    _progress_label_all.text = user.progressString;
    _progress_label.text = [NSString stringWithFormat:@"%d ",user.complete];
    }
    //销售上报数据
    [self setCornerRadiusAndBorder:_dataForSell];

    [self setCornerRadiusAndBorder:_ScrollImageView];
    
    //我的日程提醒
    [self setCornerRadiusAndBorder:_titleMyDayli];
    [_myDayli addPullToRefreshWithActionHandler:^{
        [self getRefreshData];
        [_myDayli.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
    }];
   
    nibsRegistered = NO;
    
    self.lableProf.text = user.type;
    self.lableUserName.text = user.username;
    _progressView.hidden = YES;
//    [self.lableProf setFrame:CGRectMake(self.lableProf.frame.origin.x, self.lableProf.frame.origin.y+15, self.lableProf.frame.size.width, self.lableProf.frame.size.height)];
//    [self.lableUserName setFrame:CGRectMake(self.lableUserName.frame.origin.x, self.lableUserName.frame.origin.y+15, self.lableUserName.frame.size.width, self.lableUserName.frame.size.height)];
    
    switch (user.roelId) {
        case 1:
        case 2:
            _ScrollImageView.hidden  =YES;
            
            break;
        case 3:
            _ScrollImageView.hidden = YES;
          
            [self changeCommitDataViewHided:0.1];
            break;
        case 4:
        case 6:
            _dataForSell.hidden = YES;
            _pageContrl.hidden = NO;
            
            [self getNewNotesData:@"ad"];
            mainpage = self;
            break;
        default:
            break;
    }
    
}

-(void)ontimer:(id)sender{
    if(mainpage !=self){
        return ;
    }
    if(_pageContrl.currentPage == 2){
        _pageContrl.currentPage = 0;
    }else{
        _pageContrl.currentPage++;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [_ScrollImageView setContentOffset:CGPointMake(_pageContrl.currentPage*_ScrollImageView.frame.size.width , 0)];
    }];
   
}

-(void)changeCommitDataViewHided:(float)animatetime{
    [UIView animateWithDuration:animatetime animations:^{
    CGRect viewframe;
    if(!commitDataViewIsHide){
        viewframe = _dataForSell.frame;
        viewframe.size.height = 28;
        _dataForSell.frame = viewframe;
        //我的日程提醒
        //移动Title
        viewframe = _titleMyDayli.frame;
        viewframe.origin.y -=100;
        _titleMyDayli.frame=viewframe;
        //移动Title图片
        viewframe = _titleMyDayliImage.frame;
        viewframe.origin.y -=100;
        _titleMyDayliImage.frame=viewframe;
        //移动Table
        viewframe = _myDayli.frame;
        viewframe.size.height += 100;
        viewframe.origin.y -=100;
        _myDayli.frame=viewframe;
    }
    else{
        viewframe = _dataForSell.frame;
        viewframe.size.height = 128;
        _dataForSell.frame = viewframe;
        //我的日程提醒
        viewframe = _titleMyDayli.frame;
        viewframe.origin.y +=100;
        _titleMyDayli.frame=viewframe;
        viewframe = _titleMyDayliImage.frame;
        viewframe.origin.y +=100;
        _titleMyDayliImage.frame=viewframe;
        viewframe = _myDayli.frame;
        viewframe.size.height -= 100;
        viewframe.origin.y +=100;
        _myDayli.frame=viewframe;
    
    }
    }];
    commitDataViewIsHide =!commitDataViewIsHide;
}

//Table DataSoucre
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0 && countForXunyixunTitle>0) {
        return 1;
    }
    if (section == 1 && notelist) {
        return notelist.count;
    }
   if(section == 2 && mydaylistData){
       return  mydaylistData.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 50;
    }
    return 70;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CustomCellIdentifier = @"MainNotesCell";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"MainNotesCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
        nib = [UINib nibWithNibName:@"CountForMsgCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"CountForMsgCell"];
        nibsRegistered = YES;
    }
    if (countForXunyixunTitle>0 && indexPath.section == 0){
        CountForMsgCell *countcell = [tableView dequeueReusableCellWithIdentifier:@"CountForMsgCell"];
        [countcell setData:countForXunyixunTitle];
        return countcell;
    }
    
    MainNotesCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if(cell){
        if (indexPath.section == 1) {
            PublicInfo * info =  (PublicInfo *)[notelist objectAtIndex:indexPath.row];
            [cell setData:info.contents Type:0 Time:nil];
        }
        if(indexPath.section == 2){
            Schedule *info = (Schedule *)[mydaylistData objectAtIndex:indexPath.row];
            [cell setData:info.contents Type:1 Time:info.start];
        }
        //cell.Content.text = @"对某某店家进行巡视，检查其销售情况，指导工作。";
    }
    return cell;
}
- (IBAction)goXiaoShouzhence:(id)sender {
    UIViewController *  view =[KnowledgeBaseViewController getKnowledgeBase];
    [self.navigationController pushViewController:view animated:YES];
    [(LeftMenuViewController *)self.mm_drawerController.leftDrawerViewController setSelectButton:1006];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MessageListViewController * messageview = [[MessageListViewController alloc]initWithNibName:@"MessageListViewController" bundle:nil];
        [self.mm_drawerController.navigationController pushViewController:messageview animated:YES];
    
    }
    
    if (indexPath.section==2) {
        MyScheduleViewController *view = [[MyScheduleViewController alloc]initWithNibName:@"MyScheduleViewController" bundle:nil];
        [self.navigationController pushViewController:view animated:YES];
        [(LeftMenuViewController *)self.mm_drawerController.leftDrawerViewController setSelectButton:1008];
    }
    if(indexPath.section == 1){
        ChatViewController *view = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
        [view setTitleLabelString:@"通知"];
        [self.mm_drawerController.navigationController pushViewController:view animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 

- (IBAction)toXiaoShouDataView:(id)sender {
    UIView * senderview = sender;
    
   
    UIViewController * view ;
    
    if (senderview.tag==1004){
        view = [[SellSystemViewController alloc]initWithNibName:@"SellSystemViewController" bundle:nil isDataTable:YES SelectDic:nil isFristPage:YES];
        view.title = @"系统日报";
         [(LeftMenuViewController *)self.mm_drawerController.leftDrawerViewController setSelectButton:1003];
    }else{
        view = [[SellSystemViewController alloc]initWithNibName:@"SellSystemViewController" bundle:nil isDataTable:NO SelectDic:nil isFristPage:YES];
        view.title = @"手工上报";
         [(LeftMenuViewController *)self.mm_drawerController.leftDrawerViewController setSelectButton:1002];
    }
    [self.navigationController pushViewController:view animated:YES];
}

-(void)updateVer{
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:@"/api/upgrades/ver/latest" Params:nil Logo:@"upload"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        @try {
            [request setResponseEncoding:NSUTF8StringEncoding];
            NSString *reArg = [request responseString];
            NSMutableDictionary *temp = [reArg JSONValueNewMy];
            NSString *version = [temp objectForKey:@"version"];
            if([NSString isEnabled:version] && ![version isEqualToString:SYSTEM_VERSION_NUMBER]){
                NSArray *tempx1 = [version componentsSeparatedByString:@"."];
                NSArray *tempx2 = [SYSTEM_VERSION_NUMBER componentsSeparatedByString:@"."];
                int speca = 0;
                int specatemp = 10000;
                updateType = 0;
                for(int i=0;i<[tempx1 count];i++){
                    specatemp /= 10;
                    int tempx3 = [((NSString*)tempx1[i]) intValue];
                    int tempx4 = [tempx2[i] intValue];
                    if(tempx3>tempx4){
                        speca += specatemp;
                        break;
                    }else if(tempx3==tempx4){
                        continue;
                    }else{
                        return;
                    }
                }
                updateType = speca;
                
                NSString *tempx = [NSString stringWithFormat:@"版本更新:%@",[temp objectForKey:@"content"]];
                [temp setValue:[NSNumber numberWithInt:updateType] forKey:@"updateType"];
                [ConfigManage setConfig:@"update-Notification-Dic" Value:temp];
                CompulsoryUpdateController * view = [[CompulsoryUpdateController alloc]initWithNibName:@"CompulsoryUpdateController" bundle:nil];
                view.noteString = tempx;
                view.updateType = updateType;
                [self.mm_drawerController presentModalViewController:view animated:YES];
            }
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:API_BASE_URL(@"/app/yxb/")]];
            break;
        default:
            break;
    }
}


@end
