//
//  CTM_MainController.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-13.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "CTM_MainController.h"
#import "CTM_RightController.h"
#import "UIViewController+MMDrawerController.h"
#import "CTM_RecordDetailController.h"
#import "CTM_RecordCell.h"
#import "EntityCallRecord.h"
#import "CTM_CallKeyBord.h"
#import "SABFromDataBaseService.h"
#import "SerCallService.h"
#import "EntityPhone.h"
#import "CTM_AddContentController.h"
#import "CTM_RecordFromUserCell.h"
static CTM_MainController *xmainController;
@interface CTM_MainController ()
@property (strong, nonatomic) IBOutlet UIButton *buttonCall;
@property bool isCanhidden;
@property (strong, nonatomic) NSArray *recordData;
@property (strong, nonatomic) NSMutableArray *recordDataShow;
@property (strong, nonatomic) NSMutableArray *recordDataDetail;

@property (strong, nonatomic) NSMutableDictionary *currentSelectedDic;

@property (strong, nonatomic) NSMutableArray *isCallFlags;
@property (strong, nonatomic) SABFromDataBaseService *fdbs;
@property (strong, nonatomic) CTM_CallKeyBord *keyBorde;
@property (strong, nonatomic) NSArray* phones;
@property int index;
@property NSString *tableCurSelectephone;
@property int statusIndex;
@end

@implementation CTM_MainController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
+(id) getSingleInstance{
    @synchronized(xmainController){
        if(!xmainController){
            xmainController = [[CTM_MainController alloc]initWithNibName:@"CTM_MainController" bundle:nil];
            xmainController.fdbs = COMMON_FDBS;
            xmainController.recordDataDetail = [[NSMutableArray alloc]init];
            xmainController.recordDataShow = [[NSMutableArray alloc]init];
           [xmainController refreshRecord];
        }
    }
    return xmainController;
}
-(void) refreshRecord{
    [self refreshRecordByParams:nil];
}
-(void) refreshRecordByParams:(NSString*) params{
    NSMutableArray *entityUserArray = nil;
    if([NSString isEnabled:params]){
        entityUserArray = [[NSMutableArray alloc]initWithArray:[_fdbs queryEntityUserByParams:params IfChekNum:true]];
    }
    @try {
        [_isCallFlags removeAllObjects];
        _recordData = [_fdbs queryRecordByParams: params];
        [_recordDataDetail removeAllObjects];
        [_recordDataShow removeAllObjects];
        if (![_recordData count]&&![entityUserArray count]) {
            return;
        }
        NSMutableArray *temp1 = [NSMutableArray new];
        NSMutableArray *temp4;
        EntityCallRecord *temp2;
        int index = 0;
        for (EntityCallRecord *temp3 in _recordData) {
            if(!temp2){
                index = 1;
                temp2 = temp3;
                temp4  = [NSMutableArray new];
                [temp4 addObject:temp3];
                continue;
            }
            if(![temp3.callPhoneNum isEqual:temp2.callPhoneNum]){
                NSMutableDictionary *dic = [NSMutableDictionary new];
                [dic setValue:temp2 forKey:@"data"];
                [dic setValue:[[NSNumber alloc] initWithInt:index] forKey:@"count"];
                [dic setValue:temp4 forKey:@"detail"];
                [temp1 addObject:dic];
                index = 1;
                temp2 = temp3;
                temp4  = [NSMutableArray new];
                [temp4 addObject:temp3];
                continue;
            }
            [temp4 addObject:temp3];
            ++index;
        }
        if(temp2){
            NSMutableDictionary *dic = [NSMutableDictionary new];
            [dic setValue:temp2 forKey:@"data"];
            [dic setValue:[[NSNumber alloc] initWithInt:index] forKey:@"count"];
            [dic setValue:temp4 forKey:@"detail"];
            [temp1 addObject:dic];
            [_recordDataShow addObjectsFromArray:temp1];
        }
    }
    @catch (NSException *exception) {
        COMMON_SHOWALERT(@"刷新过程中出现异常情况");
    }
    @finally {
        if(entityUserArray&&[entityUserArray count])
            [_recordDataShow addObjectsFromArray:entityUserArray];
        [_tableViewRecord reloadData];
    }
}
-(void) viewDidAppear:(BOOL)animated{
    if(dox){
        __weak typeof(self) tempself = self;
        dox(tempself);
        dox = false;
    }
    [super viewDidAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak typeof(self) tempSelf = self;
    _tableViewRecord.dataSource = tempSelf;
    _tableViewRecord.delegate = tempSelf;

    UINib *nib = [UINib nibWithNibName:@"CTM_RecordCell" bundle:nil];
    [_tableViewRecord registerNib:nib forCellReuseIdentifier:@"CTM_RecordCell"];
    UINib *nib2 = [UINib nibWithNibName:@"CTM_RecordFromUserCell" bundle:nil];
    [_tableViewRecord registerNib:nib2 forCellReuseIdentifier:@"CTM_RecordFromUserCell"];
    _keyBorde = [CTM_CallKeyBord getInsatnce];
    [_keyBorde setPhoneCallValueChangeMethod:^(NSString *chanageValue) {
        [tempSelf refreshRecordByParams:chanageValue];
    }];
    CGRect r = _buttonCall.frame;
    r.origin.y = COMMON_SCREEN_H-r.size.height;
    _buttonCall.frame = r;
    _isCallFlags = [[NSMutableArray alloc]init];
}
- (IBAction)clickCall:(id)sender {
    [self showKeyBord];
}
- (IBAction)clickReturn:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
-(void) showKeyBord{
    if(_isCanhidden) return;
    _isCanhidden = true;
    CGRect r3 = _tableViewRecord.frame;
    r3.size.height -= _keyBorde.frame.size.height;
    _tableViewRecord.frame = r3;
    CGRect r = _keyBorde.frame;
    r.origin.x=0;
    r.origin.y=COMMON_SCREEN_H;
    _keyBorde.frame = r;
    //键盘显示，设置toolbar的frame跟随键盘的frame
    [UIView animateWithDuration:0.5 animations:^{
        CGRect r2 = _keyBorde.frame;
        r2.origin.y = COMMON_SCREEN_H - _keyBorde.frame.size.height;
        _keyBorde.frame = r2;
    }];
    [self.view addSubview:_keyBorde];
}
-(void) hiddenKeyBord{
    if(!_isCanhidden) return;
    _isCanhidden = false;
    CGRect r3 = _tableViewRecord.frame;
    r3.size.height += _keyBorde.frame.size.height;
    _tableViewRecord.frame = r3;
    //键盘显示，设置toolbar的frame跟随键盘的frame
    [UIView animateWithDuration:0.5 animations:^{
        CGRect r2 = _keyBorde.frame;
        r2.origin.y = COMMON_SCREEN_H;
        _keyBorde.frame = r2;
    }];
    NSThread *t = [[NSThread alloc]initWithTarget:self selector:@selector(removeKeybord02) object:nil];
    [t start];

}
-(void) removeKeybord02{
    [NSThread sleepForTimeInterval:0.5];
    [_keyBorde removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_recordDataShow count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id temp =  [_recordDataShow objectAtIndex:[indexPath row]];
    if([temp isKindOfClass:[NSMutableDictionary class]]){
        CTM_RecordCell *crc  = [tableView dequeueReusableCellWithIdentifier:@"CTM_RecordCell"];
        NSMutableDictionary *dic = temp;
        int count = ((NSNumber*)[dic objectForKey:@"count"]).intValue;
        EntityCallRecord *r = [dic objectForKey:@"data"];
        //    [crc setComing:1];
        [crc setAction:count];
        [crc setRecord:r];
        [crc setComing:0];
        __weak typeof(self) tempself = self;
        [crc setClickCallM:^void *(id target) {
            [SerCallService call:r.callPhoneNum];
            [tempself.keyBorde clearPhone];
//            if([tempself hasCallFlags:[indexPath row]])
//                [SerCallService call:r.callPhoneNum];
//            else{
//                tempself.tableCurSelectephone = r.callPhoneNum;
//                COMMON_SHOWMSGDELEGATE(@"询问", tempself, @"新增联系人",@"添加到现有联系人");
//            }
            return nil;
        }];
        EntityUser *u = [r getEntityUser];
        if (u&&u.userId) {
            [self addCallFlags:[indexPath row]];
        }
        UIView *ux = [UIView new];
        UIImage *image = [UIImage imageNamed:@"record_select_bg.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [ux addSubview:imageView];
        [crc setSelectedBackgroundView:ux];
        return crc;
    }else{
        CTM_RecordFromUserCell *rfuc = [tableView dequeueReusableCellWithIdentifier:@"CTM_RecordFromUserCell"];
        [rfuc setEntityUser:temp];
        __weak typeof(self) tempself = self;
        [rfuc setExcueClickButton:^void (EntityUser *userx) {
            NSString *title = [NSString stringWithFormat:@"呼叫 %@",userx.userName];
            _phones= [userx getTelephones];
            NSString *phone1 = ((EntityPhone*)[_phones objectAtIndex:0]).phoneNum;
            NSString *phone2 = [_phones count]>=2?((EntityPhone*)[_phones objectAtIndex:1]).phoneNum:nil;
            NSString *phone3 = [_phones count]>=3?((EntityPhone*)[_phones objectAtIndex:2]).phoneNum:nil;
            NSString *phone4 = [_phones count]>=4?((EntityPhone*)[_phones objectAtIndex:3]).phoneNum:nil;
            NSString *phone5 = [_phones count]>=5?((EntityPhone*)[_phones objectAtIndex:4]).phoneNum:nil;
            _statusIndex = 2;
            COMMON_SHOWSHEET(title, tempself.view, tempself, phone1,phone2,phone3,phone4,phone5);
            
        }];
        UIView *ux = [UIView new];
        UIImage *image = [UIImage imageNamed:@"record_select_bg.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [ux addSubview:imageView];
        [rfuc setSelectedBackgroundView:ux];
        return rfuc;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hiddenKeyBord];
    id temp =  [_recordDataShow objectAtIndex:[indexPath row]];
    if(![temp isKindOfClass:[NSMutableDictionary class]]) return;
    _currentSelectedDic  = [_recordDataShow objectAtIndex:[indexPath row]];
    EntityCallRecord *record = [_currentSelectedDic objectForKey:@"data"];
   _tableCurSelectephone = record.callPhoneNum;
    _index = 0;
    if([record getEntityUser]&&[record getEntityUser].userId){
        _statusIndex = 0;
        COMMON_SHOWSHEET([record getEntityUser]?[record getEntityUser].userName:record.callPhoneNum, self.view, self, @"拨号",@"查看",@"删除");
    }else{
        _statusIndex = 1;
        COMMON_SHOWSHEET([record getEntityUser]?[record getEntityUser].userName:record.callPhoneNum, self.view, self, @"拨号",@"查看",@"新增联系人",@"添加到现有联系人",@"删除");
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self hiddenKeyBord];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (_statusIndex) {
        case 0:
        {
            switch (_index) {
                case 0:
                {
                    NSArray *detail = [_currentSelectedDic objectForKey:@"detail"];
                    switch (buttonIndex) {
                        case 0:{
                            EntityCallRecord *r = [_currentSelectedDic objectForKey:@"data"];
                            [SerCallService call:r.callPhoneNum];
                        }
                            break;
                        case 1: {
                            CTM_RecordDetailController *c = [[CTM_RecordDetailController alloc]initWithNibName:@"CTM_RecordDetailController" bundle:nil];
                            c.recordData = detail;
                            c.curRecord = detail[0];
                            [self.mm_drawerController.navigationController pushViewController:c animated:YES];
                        }
                            break;
                        
                        case 2: {
                            @try {
                                SABFromDataBaseService *fdbs = COMMON_FDBS;
                                for (EntityCallRecord *record in detail) {
                                    [fdbs removeEntityCallRecord:record];
                                }
                                [[CTM_RightController getSingleInstance] refreshData];
                                [[CTM_MainController getSingleInstance] refreshRecord];
                                COMMON_SHOWALERT(@"操作成功!")
                            }
                            @catch (NSException *exception) {
                                NSString *msg = exception.reason;
                                NSString *title = exception.name;
                                COMMON_SHOWMSG(title, msg);
                            }
                        }
                            break;
                        default:
                            break;
                    }
                }
                    break;
                default:
                    break;
            }
        
        }
            break;
        case 1:
        {
            switch (_index) {
                case 0:
                {
                    NSArray *detail = [_currentSelectedDic objectForKey:@"detail"];
                    switch (buttonIndex) {
                        case 0:{
                            EntityCallRecord *r = [_currentSelectedDic objectForKey:@"data"];
                            [SerCallService call:r.callPhoneNum];
                        }
                            break;
                        case 1: {
                            CTM_RecordDetailController *c = [[CTM_RecordDetailController alloc]initWithNibName:@"CTM_RecordDetailController" bundle:nil];
                            c.recordData = detail;
                            c.curRecord = detail[0];
                            [self.mm_drawerController.navigationController pushViewController:c animated:YES];
                        }
                            break;
                        case 2:
                        {
                            UIPasteboard *pb = [UIPasteboard generalPasteboard];
                            [pb setString:_tableCurSelectephone];
                            CTM_AddContentController *c = [CTM_AddContentController getNewInstance];
                            EntityUser *user = [EntityUser new];
                            user.defaultPhone = _tableCurSelectephone;
                            [c setEntityUser:user];
                            [c setTitleName:@"新增通信录"];
                            [c setCallBackSave:false];
                            [self.navigationController pushViewController:c animated:YES];
                        }
                            break;
                        case 3:
                        {
                            [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
                            COMMON_SHOWALERT(@"已经将你要添加的信息复制在粘贴板上!");
                        }
                            break;
                        case 4: {
                            @try {
                                SABFromDataBaseService *fdbs = COMMON_FDBS;
                                for (EntityCallRecord *record in detail) {
                                    [fdbs removeEntityCallRecord:record];
                                }
                                [[CTM_RightController getSingleInstance] refreshData];
                                [[CTM_MainController getSingleInstance] refreshRecord];
                                COMMON_SHOWALERT(@"操作成功!")
                            }
                            @catch (NSException *exception) {
                                NSString *msg = exception.reason;
                                NSString *title = exception.name;
                                COMMON_SHOWMSG(title, msg);
                            }
                        }
                            break;
                        default:
                            break;
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:{
            if(buttonIndex==[_phones count])break;
            [SerCallService call:((EntityPhone*)(_phones[buttonIndex])).phoneNum];
            [self.keyBorde clearPhone];
        }
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
            
        default:
            break;
    }
}

-(void) addCallFlags:(int) flag{
    if([self hasCallFlags:flag])return;
    [_isCallFlags addObject:[[NSNumber alloc] initWithInt:flag]];
}
-(void) deleteFlag:(int) flag{
    for (NSNumber *flagn in _isCallFlags) {
        if(flag == flagn.intValue){
            [_isCallFlags removeObject:flagn];
            break;
        }
    }
}

-(bool) hasCallFlags:(int) flag{
    for (NSNumber *flagn in _isCallFlags) {
        if(flag == flagn.intValue)return true;
    }
    return false;
}

-(void) setExcueViewAppearDo:(ExcueViewAppeardDo) appearDo{
    dox = appearDo;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) test{
    
}
@end
