//
//  MyScheduleAddController.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-7.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "MyScheduleAddController.h"
#import "MyScheduleCustomerViewController.h"
#import "NSDate+convenience.h"
#import "ASIFormDataRequest.h"
#import "HttpApiCall.h"
#import "NSDate+convenience.h"
#import "MyScheduleAlertOPT.h"
@interface MyScheduleAddController ()
@property float ory;
@property float ory2;
@property bool flag;
@end

@implementation MyScheduleAddController

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
    
    [self cornerRadius2:self.viewContext];
    [self cornerRadius2:self.viewHead];
    [self cornerRadius:self.textViewContext];
    self.lableDateTime.text = [NSDate dateFormateDate:[NSDate new] FormatePattern:@"yyyy-MM-dd HH:mm"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(intputshow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(intputhide:) name:UIKeyboardWillHideNotification object:nil];
    if(self._ids){
        self.lableTitle.text = @"修改日程";
    }else{
        [self.buttonDel removeFromSuperview];
    }
    if(self._remindDate){
        self.lableDateTime.text = self._remindDate;
    }
    if(self._contents){
        self.textViewContext.text = self._contents;
        
    }
    if([[NSNull null] isEqual:self._isRemind]||self._isRemind.intValue==0){
        [self.swtichAlert setOn:NO];
        self.switchFlag = true;
    }
    if(self.userNames &&![[NSNull null] isEqual:self._isRemind]){
        self.lableCustomers.text = @",";
        for (NSString *temps in self.userNames) {
            
            self.lableCustomers.text = [[self.lableCustomers.text stringByAppendingString:temps]
                stringByAppendingString:@","];
        }
    }
    if(self.ifLockOpt){
        [self lockOpt];
    }
//    UITapGestureRecognizer *tapGestureTel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickDateTime:)];
//    UITapGestureRecognizer *tapGestureTel2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCustomer:)];
//    [self.lableDateTime addGestureRecognizer:tapGestureTel];
//    [self.lableCustomers addGestureRecognizer:tapGestureTel2];
}
-(void) lockOpt{
    [self.swtichAlert setEnabled:NO];
    [self.buttonDel setHidden:YES];
    [self.textViewContext setEditable:NO];
    [self.buttonConfirm setHidden:YES];
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)intputshow:(NSNotification *)notification{
    if(self.flag){
        return;
    }
    //键盘显示，设置toolbar的frame跟随键盘的frame
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect r = self.viewContext.frame;
        CGRect r2 = self.viewHead.frame;
        if(self.ory == 0) self.ory = r.origin.y;
        if(self.ory2 == 0) self.ory2 = r2.origin.y;
//        CGRect screenR = [[UIScreen mainScreen] applicationFrame];
        r.origin.y = keyBoardFrame.origin.y-r.size.height-40;
        r2.origin.y -= self.ory-r.origin.y;
        self.viewHead.frame = r2;
        self.viewContext.frame = r;
        self.flag = true;
    }];
}

-(void)intputhide:(NSNotification *)notification{
    //键盘显示，设置toolbar的frame跟随键盘的frame
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect r = self.viewContext.frame;
        r.origin.y = self.ory;
        self.viewContext.frame = r;
        CGRect r2 = self.viewHead.frame;
        r2.origin.y = self.ory2;
        self.viewHead.frame = r2;
        self.flag = false;
    }];
    
}
-(void) cornerRadius:(UIView*) tvt{
    tvt.layer.cornerRadius = 5;
    tvt.layer.masksToBounds = YES;
    tvt.layer.borderWidth = 0.5;
    tvt.layer.borderColor = [[UIColor colorWithRed:0.580 green:0.784 blue:0.200 alpha:1]CGColor];
}
-(void) cornerRadius2:(UIView*) tvt{
    
    tvt.layer.cornerRadius = 5;
    tvt.layer.masksToBounds = YES;
    tvt.layer.borderWidth = 0.5;
    tvt.layer.borderColor = [[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor];
}
- (IBAction)clickBack:(id)sender {
    [self.textViewContext resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)toucheControll:(id)sender {
    [self.textViewContext resignFirstResponder];
}
- (IBAction)clickCustomer:(id)sender {
    if(self.ifLockOpt)return;
    MyScheduleCustomerViewController *l = [[MyScheduleCustomerViewController alloc]initWithNibName:@"MyScheduleCustomerViewController" bundle:nil];
    l.targets = self;
    l.methods = @selector(setCustomers:UserNames:);
    l.selected =[[NSMutableArray alloc]initWithArray: self.userIds];
    [self.navigationController pushViewController:l animated:YES];
}
- (IBAction)clickDateTime:(id)sender {
    if(self.ifLockOpt)return;
    MyScheduleDateTimeSetController *l = [[MyScheduleDateTimeSetController alloc]initWithNibName:@"MyScheduleDateTimeSetController" bundle:nil];
    l.targets = self;
    l.methods = @selector(setDateAndTime:);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    l.date = [dateFormatter dateFromString:self.lableDateTime.text];
    [self.navigationController pushViewController:l animated:YES];
}
-(void) setDateAndTime:(NSString*) dateAndTime{
    self.lableDateTime.text = dateAndTime;
}
-(void) setCustomers:(NSMutableArray*) ids UserNames:(NSMutableArray*) userNames{
    self.userIds = ids;
    self.userNames = userNames;
    NSString *info=@"";
    if(self.userNames&&self.userNames.count > 0){
        self.lableCustomers.text = @"";
        for (NSString *userName in self.userNames) {
            info = [info stringByAppendingString:[NSString stringWithFormat:@"%@,",userName]];
        }
    }
    self.lableCustomers.text = info;
}
- (IBAction)clickConfirm:(id)sender {
    [self.textViewContext resignFirstResponder];
    NSNumber *isRemind = [[NSNumber alloc]initWithInt:self.switchFlag?0:1];
    NSString *startDate = [self.lableDateTime.text stringByAppendingString:@":00"];
    NSDate *tempDate = [NSDate dateFormateString:startDate FormatePattern:nil];
//    tempDate = [tempDate offsetHours:-2];
    NSString *remindDate = [NSDate dateFormateDate:tempDate FormatePattern:nil];
    NSString *contents = self.textViewContext.text;
    NSString *toUserCodes = @",";
    LoginUser *u = [ConfigManage getLoginUser];
    if(!self.userIds||self.userIds==nil){
        self.userIds = [[NSMutableArray alloc]init];
    }else{
        long long t = [u.userId longLongValue];
        for (NSNumber *code in self.userIds) {
            if(code.longLongValue==t){
                [self.userIds removeObject:code];
                break;
            }
        }
    }
    for (NSNumber *_id in self.userIds) {
        toUserCodes = [[toUserCodes stringByAppendingString:[_id stringValue]]stringByAppendingString:@","];
    }
    toUserCodes = [[toUserCodes stringByAppendingString:u.userId]
        stringByAppendingString:@","];
    if(!remindDate||remindDate==nil||[@"" isEqual:remindDate]){
        showMessageBox(@"请输入日程时间");
        return;
    }
    
    if(!contents||contents==nil||[@"" isEqual:contents]){
        showMessageBox(@"请输入日程内容");
        return;
    }
    if(contents.length>200){
        showMessageBox(@"日程内容最多能输入200字!");
        return;
    }
    NSDictionary *params = [[NSMutableDictionary alloc]init];
    if(self._ids){
        [params setValue:self._ids forKey:@"id"];
    }
    NSLog(@"===%@==%@",startDate,remindDate);
    [params setValue:isRemind forKey:@"isRemind"];
    [params setValue:remindDate forKey:@"remindDate"];
    [params setValue:[[NSNumber alloc] initWithInt:2] forKey:@"status"];
    [params setValue:startDate forKey:@"setTime"];
    [params setValue:contents forKey:@"contents"];
    [params setValue:toUserCodes forKey:@"toUserCodes"];
    [params setValue:(self._type&&self._type!=nil&&![[NSNull null] isEqual:self._type])?self._type:[NSNull null] forKey:@"type"];
    ASIFormDataRequest *requestx;
    if(self._ids){
        requestx = [HttpApiCall requestCallPUT:@"/api/schedules" Params:params Logo:@"put_schedules"];
        __weak ASIFormDataRequest *request = requestx;
        [request setCompletionBlock:^{
            [request setResponseEncoding:NSUTF8StringEncoding];
            NSString *reArg = [request responseString];
            @try {
                id temp = [reArg JSONValueNewMy];
                if(temp){
//                    showMessageBox(@"修改成功！");
                    NSDate *d = [NSDate new];
                    NSDate *startDate = [NSDate monthStartOfDay:d];
                    NSDate *endDate = [NSDate monthEndOfDay:d];
                    [self.target getScheduleByMonth:startDate EndDate:endDate];
                    [MyScheduleAlertOPT getAlertInfo];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    showMessageBox(@"修改失败！");
                }
            }
            @catch (NSException *exception) {
            }
            @finally {
                [super hideActivityIndicator];
            }
            
        }];
        [request setFailedBlock:^{
            [super hideActivityIndicator];
        }];
    }else{
        requestx = [HttpApiCall requestCallPOST:@"/api/schedules" Params:params Logo:@"put_schedules"];
        __weak ASIFormDataRequest *request = requestx;
        [request setCompletionBlock:^{
            [request setResponseEncoding:NSUTF8StringEncoding];
            NSString *reArg = [request responseString];
            @try {
                id temp = [reArg JSONValueNewMy];
                if(temp){
//                    showMessageBox(@"新增成功！");
                    NSDate *d = [NSDate new];
                    NSDate *startDate = [NSDate monthStartOfDay:d];
                    NSDate *endDate = [NSDate monthEndOfDay:d];
                    [self.target getScheduleByMonth:startDate EndDate:endDate];
                    [MyScheduleAlertOPT getAlertInfo];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    showMessageBox(@"新增失败！");
                    
                }
            }
            @catch (NSException *exception) {
            }
            @finally {
                [super hideActivityIndicator];
            }
            
        }];
        [request setFailedBlock:^{
            [super hideActivityIndicator];
        }];
    }
    [requestx startAsynchronous];
    [super showActivityIndicator];
}
- (IBAction)clickSwtich:(id)sender {
    self.switchFlag = !self.switchFlag;
}
- (IBAction)clickDel:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定删除数据？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil]show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            if(YES){
                
                NSString *url = [@"/api/schedules/" stringByAppendingString:[self._ids stringValue]];
              ASIFormDataRequest *requestx = [HttpApiCall requestCallDELET:url Logo:@"delete_schedules"];
                __weak  ASIFormDataRequest *request  =  requestx;
                [request setCompletionBlock:^{
                    [request setResponseEncoding:NSUTF8StringEncoding];
//                    NSString *reArg = [request responseString];
                    @try {
                        NSDate *d = [NSDate new];
                        NSDate *startDate = [NSDate monthStartOfDay:d];
                        NSDate *endDate = [NSDate monthEndOfDay:d];
                        [self.target getScheduleByMonth:startDate EndDate:endDate];
                        [MyScheduleAlertOPT getAlertInfo];
                        [self.navigationController popToRootViewControllerAnimated:YES];
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
                [super showActivityIndicator];
                [request startAsynchronous];
            }
            break;
        default:
            break;
    }
}
- (IBAction)swichAlert:(id)sender {
}
@end
