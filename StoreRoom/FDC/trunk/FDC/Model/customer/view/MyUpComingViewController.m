//
//  MyUpComingViewController.m
//  FDC
//
//  Created by NewDoone on 15/1/22.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "MyUpComingViewController.h"
#import "CustomerBirthdayDetailViewController.h"
#import "CustomerTrackViewController.h"
#import "SiginOverTimeViewController.h"
#import "CustomerMainManager.h"
#import "UserEntity.h"
#import "ConfigManage+Expand.h"
#import "CustomerBirthdayEntity.h"
#import "SignOverdueEntity.h"

@interface MyUpComingViewController ()
@property(nonatomic,strong) NSMutableArray* birthdayInfos;
@property(nonatomic,strong) NSMutableArray* trackInfos;
@property(nonatomic,strong) NSMutableArray* signOverInfos;
@property(nonatomic,strong) NSMutableArray* unPayInfos;
@property(nonatomic,strong) NSMutableArray* willOnInfos;
@end

@implementation MyUpComingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    [self addTapActionOnViews];
    self.upComingCount.text=self.totalCount;
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}
-(void)initDatas{
    self.birthdayInfos=nil;
    self.birthdayInfos=[NSMutableArray array];
    self.trackInfos=nil;
    self.trackInfos=[NSMutableArray array];
    self.signOverInfos=nil;
    self.signOverInfos=[NSMutableArray array];
    self.unPayInfos=nil;
    self.unPayInfos=[NSMutableArray array];
    self.willOnInfos=nil;
    self.willOnInfos=[NSMutableArray array];
}
-(void)addTapActionOnViews{
    UITapGestureRecognizer* tap_birthday=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToCustomerBirthday)];
    UITapGestureRecognizer* tap_track=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToTrackDetails)];
    UITapGestureRecognizer* tap_sigin=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToSignDetails)];
    UITapGestureRecognizer* tap_unpay=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToUnPayDetails)];
    UITapGestureRecognizer* tap_willontime=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToWillOnTimeDetails)];
    [self.customerBirthdayView addGestureRecognizer:tap_birthday];
    [self.customerTrackView addGestureRecognizer:tap_track];
    [self.overTimeSiginView addGestureRecognizer:tap_sigin];
    [self.unPayView addGestureRecognizer:tap_unpay];
    [self.willOnTimeView addGestureRecognizer:tap_willontime];
}
-(void)goToCustomerBirthday{
    NSLog(@"goToCustomerBirthday");
    CustomerBirthdayDetailViewController* vc=[[CustomerBirthdayDetailViewController alloc]init];
    vc.title=@"客户生日";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)goToTrackDetails{
    NSLog(@"goToTrackDetails");
    NSLog(@"goToCustomerBirthday");
    CustomerTrackViewController* vc=[[CustomerTrackViewController alloc]init];
    vc.title=@"客户跟踪";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)goToSignDetails{
    SiginOverTimeViewController* vc=[[SiginOverTimeViewController alloc]init];
    vc.title=@"签约逾期";
    vc.signInfos=self.signOverInfos;
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"goToSignDetails");
}
-(void)goToUnPayDetails{
    SiginOverTimeViewController* vc=[[SiginOverTimeViewController alloc]init];
    vc.title=@"到期未付";
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"goToUnPayDetails");
}
-(void)goToWillOnTimeDetails{
    SiginOverTimeViewController* vc=[[SiginOverTimeViewController alloc]init];
    vc.title=@"即将到期";
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"goToWillOnTimeDetails");
}
- (IBAction)birthdayAction:(id)sender {
    [self goToCustomerBirthday];
}
- (IBAction)trackAction:(id)sender {
    [self goToTrackDetails];
}
- (IBAction)siginAction:(id)sender {
    [self goToSignDetails];
}
- (IBAction)unPayAction:(id)sender {
    [self goToUnPayDetails];
}
- (IBAction)onTimeAction:(id)sender {
    [self goToWillOnTimeDetails];
}
-(void)loadData{
    [Utils showLoading:nil];
    //客户生日
    UserEntity* user=[ConfigManage getLoginUser];
    CustomerMainManager* manager=[[CustomerMainManager alloc]init];
    [manager birthDayForCustomerWithObjectId:user.objectId success:^(id data, NSDictionary *userInfo) {
        NSLog(@"birthdayData===%@",data);
        NSArray* datas=(NSArray*)data;
        for (CustomerBirthdayEntity* entity in datas) {
            [self.birthdayInfos addObject:entity];
        }
        [Utils hiddenLoading];
    } faild:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
    }];
    //签约逾期
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    [comp setMonth:1];
    [comp setDay:1];
    [comp setYear:2014];
    NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *startDate = [myCal dateFromComponents:comp];
    [comp setMonth:3];
    [comp setDay:3];
    [comp setYear:2015];
    NSDate *endDate = [myCal dateFromComponents:comp];
    NSDateFormatter * frm=[[NSDateFormatter alloc]init];
    [frm setDateFormat:@"yyyy-mm-dd"];
    NSString* start=[frm stringFromDate:startDate];
    NSString* end=[frm stringFromDate:endDate];
    [manager singedOverdueForCustomer:user.userId objectId:user.objectId startTime:start endTime:end success:^(id data, NSDictionary *userInfo) {
         NSLog(@"SignOverData===%@",data);
        NSArray* datas=(NSArray*)data;
        self.lb_siginCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)datas.count];
        for (SignOverdueEntity* entity in datas) {
            [self.signOverInfos addObject:entity];
        }
        [Utils hiddenLoading];
    } faild:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
    }];
    //到期未付
    
    
}
@end
