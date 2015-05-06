//
//  NotesViewController.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-10-25.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "NotesViewController.h"
#import "ManagerInspectListCell.h"
#import "UIViewController+MMDrawerController.h"
#import "ASIFormDataRequest.h"
#import "HttpApiCall.h"
#import "NSDate+convenience.h"
#import "NSString+Convenience.h"
#import "NotesImageViewController.h"
#import "NotesForOrganizationController.h"
#import "NotesLeaderShipViewCell.h"
#import "SVPullToRefresh.h"
#define NOTESVIEWCELLREG @"NotesViewCellReg"
static int NOTESPAGESIZE = 5;
@interface NotesViewController ()
@property (retain, nonatomic) NSMutableArray *jsonData;
@property bool shouldLoadDataWhenAppear;//当显示时是否能加载数据(只有在新增或修改了数据 后才加载数据)
@property int nextStartPage;//下一页数
@property bool ifLeader;//是否是领导，
@property bool isLastRow;//是否是最后一条数据
@property (strong, nonatomic) NSLock *lock;// 在加载其它数据时的锁
@property (strong, nonatomic) UIView *u;//cell的背景
@property long long currentDateFlag;
@end

@implementation NotesViewController
@synthesize jsonData;
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
    
    self.u.backgroundColor = [UIColor colorWithRed:0.396 green:0.408 blue:0.459 alpha:1];
    self.lock = [[NSLock alloc]init];
    nibsRegistered = NO;
    self.nextStartPage = 1;
    self.shouldLoadDataWhenAppear = YES;
    self.jsonData = [[NSMutableArray alloc]init];
    LoginUser *u = [ConfigManage getLoginUser];
    if(u.roelId!=3){
        self.ifLeader = YES;
        [self.buttonConfirm setHidden:YES];
    }
    __weak typeof (self) weakself = self;//这样使用是为了防止相互引用出现内存泄漏
    [self.tableViewNotes addPullToRefreshWithActionHandler:^{
        weakself.nextStartPage=1;
        [weakself requestData:NO];
        weakself.currentDateFlag = 0l;
        [weakself.tableViewNotes.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
    }];
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(!self.shouldLoadDataWhenAppear)return;
    self.nextStartPage=1;
    [self.jsonData removeAllObjects];
    [self requestData:YES];
    self.shouldLoadDataWhenAppear = NO;
    self.currentDateFlag = 0l;
    [self.tableViewNotes.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
}
/**
    ifshowAct: 在加载数据之前清除掉忆有的数据
 */
-(void) requestData:(bool) ifshowAct{
    bool flag;
    NSThread *t = [[NSThread alloc]initWithTarget:self selector:@selector(unlockthereqeust:) object:self.lock];
    [self.lock lock];
    self.isLastRow = NO;
    NSLog(@"lock sdfsdfsdf");
    @try {
        if(self.nextStartPage==-1)return;
        ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:[@"/api/attendances/" stringByAppendingString:[NSString stringWithFormat:@"%d/%d",self.nextStartPage,NOTESPAGESIZE]] Params:nil Logo:@"get_attendances"];
        __weak ASIFormDataRequest *request = requestx;
        if([self.jsonData count]%NOTESPAGESIZE!=0&&ifshowAct){
            return;
        }
        [request setCompletionBlock:^{
            @try {
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *reArg = [request responseString];
                id temp = [reArg JSONValueNewMy];
                if(temp){
                    id temp2 = [temp objectForKey:@"data"];
                    int i=0;
                    if(!ifshowAct){
                        [self.jsonData removeAllObjects];
                    }
                    for (NSMutableDictionary *json in (NSArray*)temp2) {
                        NSDate *d = [NSDate dateFormateString:[json objectForKey:@"checkTime"] FormatePattern:nil];
                        long long curDateflag = d.year*10000+(d.month>9?d.month*10:d.month*100)+d.day;
                        if(self.currentDateFlag != curDateflag){
                            self.currentDateFlag = curDateflag;
                            [json setValue:@"" forKey:@"curDateFlag"];
                        }
                        [self.jsonData addObject:json];
                        i++;
                    }
                    [self.tableViewNotes reloadData];
                    if(i==0) self.nextStartPage = -1;
                    else self.nextStartPage += i;
                }else{
                }
            }
            @catch (NSException *exception) {
                showMessageBox(WEB_BASE_MSG_SYSTEMERROR);
            }
            @finally {
                self.isLastRow = YES;
                [self hideActivityIndicator];
            }
            
        }];
        [request setFailedBlock:^{
            [self hideActivityIndicator];
            self.isLastRow = YES;
            showMessageBox(WEB_BASE_MSG_REQUESTOUTTIME);
        }];
        [self showActivityIndicator];
        [t start];
        flag = YES;
        [request startAsynchronous];
    }
    @finally {
        if(!flag)[t start];
    }
}
-(void) unlockthereqeust:(NSLock*) lock{
    int i = 0;
    while (YES) {
        [NSThread sleepForTimeInterval:0.5];
        if(self.isLastRow){
            break;
        }
        i++;
        if(i==20) break;
    }
    
    [self.lock unlock];
}
//Table DataSoucre
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.jsonData?[self.jsonData count]:0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.ifLeader?92:117;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!nibsRegistered) {
        UINib *nib ;
        if(self.ifLeader){
            nib = [UINib nibWithNibName:@"NotesLeaderShipViewCell" bundle:nil];
        }else{
            nib = [UINib nibWithNibName:@"ManagerInspectListCell" bundle:nil];
        }
        [tableView registerNib:nib forCellReuseIdentifier:NOTESVIEWCELLREG];
        nibsRegistered = YES;
    }
    UITableViewCell *_cell;
    NSDictionary *json = self.jsonData[[indexPath row]];
    if(self.ifLeader){
        
        NotesLeaderShipViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NOTESVIEWCELLREG];
        NSDictionary *toUser = [json objectForKey:@"toUser"];
        NSString *checkTime = [json objectForKey:@"checkTime"];
        NSDictionary *organization = [json objectForKey:@"organization"];
        NSString *checkLocation = [json objectForKey:@"checkLocation"];
        if(!checkLocation||checkLocation==nil||[[NSNull null] isEqual:checkLocation]){
            checkLocation = @"地址不详";
        }
        cell.lableDate.text = checkTime;
       // NSString *userCode = [NSString stringWithFormat:@"%d",[[toUser objectForKey:@"userCode"]intValue]];
        NSString *attachUrl = [[toUser objectForKey:@"portrait"] objectForKey:@"attachUrl"];
        if([NSString isEnabled:attachUrl]){
            cell.imageHead.imageUrl = nil;
            cell.imageHead.imageUrl = API_IMAGE_URL_GET2(attachUrl);
            cell.imageHead.layer.cornerRadius = cell.imageHead.frame.size.width/2;
            cell.imageHead.layer.masksToBounds = YES;
        }else{
            cell.imageHead.imageUrl = nil;
        }
        
        if(toUser&&toUser!=nil&&![[NSNull null] isEqual:toUser]){
            cell.lableUserName.text = [toUser objectForKey:@"userName"];
        }
        if(organization&&organization!=nil&&![[NSNull null] isEqual:organization]){
            cell.lableNotesShopName.text = [organization objectForKey:@"fullName"];
        }
        cell.lableAdress.text = checkLocation;
        _cell = cell;
    }else{
        ManagerInspectListCell *cell = [tableView dequeueReusableCellWithIdentifier:NOTESVIEWCELLREG];
        if(cell){
            NSDate *d = [NSDate dateFormateString:[json objectForKey:@"checkTime"] FormatePattern:nil];
            NSString *checkLocation = [json objectForKey:@"checkLocation"];
            NSString *photos = [json objectForKey:@"defaultPic"];
            if(!checkLocation||checkLocation==nil||[[NSNull null] isEqual:checkLocation]){
                checkLocation = @"地址不详";
            }
            NSString *orgName = [((NSDictionary*)[json objectForKey:@"organization"]) objectForKey:@"fullName"];
            if([json objectForKey:@"curDateFlag"]){
                [cell setData:d DateFlag:YES ShopName:orgName   Set:checkLocation];
            }else{
                [cell setData:d DateFlag:NO ShopName:orgName   Set:checkLocation];
            }
            if([NSString isEnabled:photos]){
               cell.imagePhones.imageUrl =  [ConfigManage getImageSamll:API_IMAGE_URL_GET2(photos)];

                cell.imagePhones.layer.cornerRadius = 0;
                cell.imagePhones.layer.masksToBounds = YES;
            }else{
                cell.imagePhones.imageUrl = nil;
            }
            
        }
        _cell = cell;
    }
    if(self.nextStartPage!=-1&&[indexPath row] ==self.nextStartPage-2&&self.nextStartPage%NOTESPAGESIZE==1){
        [self requestData:YES];
    }
    [_cell setSelectedBackgroundView:self.u];
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *json = self.jsonData[[indexPath row]];
    NSString *attamentsIds = [json objectForKey:@"attamentsIds"];
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
                [jsonDatas setValue:[json objectForKey:@"checkContents"] forKey:@"imageInfo"];
                [jsonDatas setValue: temp2 forKey:@"data"];
                NotesImageViewController *l = [[NotesImageViewController alloc]initWithNibName:@"NotesImageViewController" bundle:nil];
                l.jsonData = jsonDatas;
                NSDictionary *organization = [json objectForKey:@"organization"];
                l.title= [organization objectForKey:@"fullName"];
                [self.mm_drawerController.navigationController pushViewController:l animated:YES];
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
-(NSArray*)DataListForOptions:(NSInteger)optionsIndex{
    return  [[NSArray alloc]initWithObjects:[NSNumber numberWithDouble:100.123],[NSNumber numberWithDouble:200.1],[NSNumber numberWithDouble:150.23],[NSNumber numberWithDouble:120.23],[NSNumber numberWithDouble:190.23],[NSNumber numberWithDouble:170.23], nil];
}
-(NSArray*)DataNameList{
    return [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"2",@"3",@"4",@"5",@"6",@"7", nil];
}
-(void)AKUIChartView:(AKUIChartView *)chartView selectedNode:(NSInteger)nodeIndex{
    NSLog(@"我选中了第%d条数据。",nodeIndex);
}
- (IBAction)clickAddNotes:(id)sender {
    self.shouldLoadDataWhenAppear = YES;
    NotesForOrganizationController *l = [[NotesForOrganizationController alloc]initWithNibName:@"NotesForOrganizationController" bundle:nil];
    [self.mm_drawerController.navigationController pushViewController:l animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)topButClick:(id)sender {
    [self topButtonClick:sender];
}
@end
