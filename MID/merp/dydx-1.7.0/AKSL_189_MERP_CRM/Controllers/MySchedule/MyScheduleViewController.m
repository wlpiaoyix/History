//
//  MyScheduleViewController.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-10-24.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "MyScheduleViewController.h"
#import "VRGCalendarView.h"
#import "NSDate+convenience.h"
#import "SingleDateScheduleCell.h"
#import "MyScheduleAddController.h"
#import "UIViewController+MMDrawerController.h"
#import "ASIFormDataRequest.h"
#import "HttpApiCall.h"
#import "NSDate+convenience.h"
#import "NSString+Convenience.h"

@interface MyScheduleViewController ()
@property (strong,nonatomic) NSDictionary *jsonDate;
@property (strong,nonatomic) NSMutableArray *jsonDateDay;
@property bool flag;
@end

@implementation MyScheduleViewController
- (IBAction)clickAdd:(id)sender {
    MyScheduleAddController *l = [[MyScheduleAddController alloc]initWithNibName:@"MyScheduleAddController" bundle:nil];
    l.target = self;
    NSDate *d = self.calendarView.selectedDate;
    NSDate *d2 = [NSDate new];
    l._remindDate = [[NSDate dateFormateDate:d FormatePattern:@"yyyy-MM-dd "] stringByAppendingString:[NSDate dateFormateDate:d2 FormatePattern:@"HH:mm"]];
    [self.mm_drawerController.navigationController pushViewController:l animated:YES];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) getScheduleByMonth:(NSDate*) startDate EndDate:(NSDate*) endDate{
    if(self.flag){return;}
    NSString *startStr = [[[[NSNumber alloc]initWithDouble:startDate.timeIntervalSince1970]stringValue]stringByAppendingString:@"000"];
    NSString *endStr = [[[[NSNumber alloc]initWithDouble:endDate.timeIntervalSince1970]stringValue]stringByAppendingString:@"000"];
    NSString *url = [[[[@"/api/schedules/managerschedules" stringByAppendingString:@"/"]
                     stringByAppendingString:startStr]
                     stringByAppendingString:@"/"]
                     stringByAppendingString:endStr];
    __weak ASIFormDataRequest *request = [HttpApiCall requestCallGET:url Params:nil Logo:@"get_current_month_schedules"];
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            self.jsonDate = [reArg JSONValueNewMy];
            [self.calendarView reDisplay];
            [self.listViewForDateli reloadData];
        }
        @catch (NSException *exception) {
            self.jsonDate = NO;
            showAlertBox(@"提示", exception.reason);
        }
        @finally {
            [self hideActivityIndicator];
            self.flag = NO;
        }
        
    }];
    [request setFailedBlock:^{
        self.jsonDate = NO;
        [self hideActivityIndicator];
        self.flag = NO;
//        showAlertBox(@"错误", @"服务器没有响应！");
    }];
    [self showActivityIndicator];
    self.flag = YES;
    [request startAsynchronous];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    VRGCalendarView * view = [[VRGCalendarView alloc]init];
    [view setFrame:CGRectMake(0, 41, 320, view.frame.size.height)];
    view.delegate = self;
    self.calendarView = view;
    [self.view addSubview:self.calendarView];
    
}
-(NSArray*) getDatas:(NSArray*) jsons{
    NSMutableArray *data = [[NSMutableArray alloc]init];
    bool flag = YES;
    for(NSDictionary *json in jsons){
        NSString *ds = [json objectForKey:@"remindDate"];
        NSDate *dd = [NSDate dateFormateString:ds FormatePattern:nil];
        for (NSNumber *v in data) {
            if(v.intValue==dd.day){
                flag = NO;
                break;
            }else{
                flag = YES;
            }
        }
        [data addObject:[[NSNumber alloc] initWithInt:dd.day]];
    }
    return  data;
}
-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated {
    //if (month==[[NSDate date] month]) {
    //}
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _listViewForDateli.frame;
        frame.origin.y = targetHeight+42;
        frame.size.height =  self.view.frame.size.height - frame.origin.y;
        _listViewForDateli.frame = frame;
    }];
    NSDate *startDate = [NSDate monthStartOfDay:calendarView.currentMonth];
    NSDate *endDate = [NSDate monthEndOfDay:calendarView.currentMonth];
    if(!self.flag){
        [self getScheduleByMonth:startDate EndDate:endDate];
    }
    NSArray *dates = [self getDatas:(NSArray*)self.jsonDate];
    [calendarView markDates:dates];
    if(self.jsonDate&&self.jsonDate!=nil&&self.jsonDate.count>0){
        NSDate *d = [NSDate new];
        [self setJsonDateDays:d.day];
    }else{
        self.jsonDateDay = NO;
    }
    [self.listViewForDateli reloadData];
}
-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    [self setJsonDateDays:date.day];
    [self.listViewForDateli reloadData];
}
-(void) setJsonDateDays:(int) day{
    self.jsonDateDay = [[NSMutableArray alloc]init];
    for (NSDictionary *json in (NSArray*)self.jsonDate) {
        NSDate *d = [NSDate dateFormateString:[json objectForKey:@"remindDate"] FormatePattern:nil];
        if(d.day == day){
            [self.jsonDateDay addObject:json];
        }
    }
}

//Table DataSoucre
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.jsonDateDay?[(NSArray*)self.jsonDateDay count]:0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CustomCellIdentifier = @"SingleDateScheduleCell";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"SingleDateScheduleCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
        nibsRegistered = YES;
    }
    SingleDateScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if(cell){
        NSDictionary *json = ((NSArray*)self.jsonDateDay)[[indexPath row]];
        NSDate *d = [NSDate dateFormateString:(NSString*)[json objectForKey:@"remindDate"] FormatePattern:nil];
        NSString *info = [json objectForKey:@"title"];
        cell.timeLabel.text = [NSDate dateFormateDate:d FormatePattern:@"HH:mm"];
        cell.infoLable.text = info;
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyScheduleAddController *l = [[MyScheduleAddController alloc]initWithNibName:@"MyScheduleAddController" bundle:nil];
    NSDictionary *json = ((NSArray*)self.jsonDateDay)[[indexPath row]];
    l._ids = [json objectForKey:@"id"];
    l._contents = [json objectForKey:@"title"];
    l._isRemind = [json objectForKey:@"isRemind"];
    l._remindDate = [json objectForKey:@"remindDate"];
    l._type = [json objectForKey:@"type"];
    l._remindDate = [l._remindDate substringToIndex:l._remindDate.length-3];
    NSArray *toUserCodes =[json objectForKey:@"toUserCodes"];
    LoginUser *u = [ConfigManage getLoginUser];
    if(u.userkey!=((NSNumber*)[json objectForKey:@"userId"]).longLongValue){
        l.ifLockOpt = YES;
    }
    l.userIds = [[NSMutableArray alloc]init];
    l.userNames = [[NSMutableArray alloc]init];
    for (NSDictionary *temp in toUserCodes) {
        [l.userIds addObject:[[NSNumber alloc] initWithLongLong:[[temp objectForKey:@"userCode"] longLongValue]]];
        [l.userNames addObject:[temp objectForKey:@"userName"]];
    }
    l.target = self;
    [self.mm_drawerController.navigationController pushViewController:l animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 
- (IBAction)topbarbutton:(id)sender {
    [self topButtonClick:sender];
}
@end
