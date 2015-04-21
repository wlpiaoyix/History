//
//  CustomerTrackViewController.m
//  FDC
//
//  Created by NewDoone on 15/1/23.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "CustomerTrackViewController.h"
#import "CustomerTrackTableViewCell.h"
#import "CustomerTrackDetailViewController.h"
#import "CustomerMainManager.h"
#import "ConfigManage+Expand.h"
#import "CustomerFollowUpEntity.h"
@interface CustomerTrackViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tf_searchContent;
@property(nonatomic,strong) NSMutableArray* customerInfos;

@end

@implementation CustomerTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self loadData];
//    self.tableView.allowsSelection=NO;
    // Do any additional setup after loading the view from its nib.
}
-(void)loadData{
    [Utils showLoading:nil];
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
//    NSString* start=[frm stringFromDate:startDate];
//    NSString* end=[frm stringFromDate:endDate];
    self.customerInfos=nil;
    self.customerInfos=[NSMutableArray array];
    UserEntity* user=[ConfigManage getLoginUser];
    CustomerMainManager* manager=[[CustomerMainManager alloc]init];
    [manager followUpForCustomerWithName:user.userName visitDate:endDate orderLevel:2.0 customerType:nil objectId:user.objectId success:^(id data, NSDictionary *userInfo) {
        NSLog(@"trackData===%@",data);
        NSArray* datas=(NSArray*)data;
        for (CustomerFollowUpEntity* entity in datas) {
            [self.customerInfos addObject:entity];
        }
        [Utils hiddenLoading];
    } faild:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
    }];
}
-(void)initView{
    [self.segementControl setBackgroundImage:[UIImage imageNamed:@"blue_unit.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segementControl setBackgroundImage:[UIImage imageNamed:@"yellow_unit.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    self.segementControl.frameHeight=40;
    self.segementControl.layer.cornerRadius=0.0;
    self.segementControl.tintColor=[UIColor whiteColor];
    NSDictionary* textAttribute = @{NSForegroundColorAttributeName:[UIColor blackColor]};
     [self.segementControl setTitleTextAttributes:textAttribute forState:UIControlStateSelected];
    //config TableView
    
        CGRect frame=CGRectZero;
        frame=CGRectMake(0, self.tf_searchContent.frame.origin.y+self.tf_searchContent.frame.size.height+10, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-self.tf_searchContent.frame.origin.y-10-self.tf_searchContent.frame.size.height-64-self.navigationController.toolbar.frameHeight);
        
        self.tableView.frame=frame;

    
}

- (IBAction)showOptionRank:(id)sender {
//    NSLog(@"showOptionRank");
    switch (self.segementControl.selectedSegmentIndex ) {
        case 0:
            NSLog(@"name");
            self.tf_searchContent.placeholder=@"请输入客户姓名";
            break;
            case 1:
            self.tf_searchContent.placeholder=@"请输入时间";
            NSLog(@"time");
            break;
            case 2:
              self.tf_searchContent.placeholder=@"请输入意向";
            NSLog(@"mind");
            break;
            case 3:
              self.tf_searchContent.placeholder=@"请输入类型";
            NSLog(@"type");
            break;
        default:
            break;
    }
}
- (IBAction)searchAction:(id)sender {
    
}
#pragma tableViewDegelate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.customerInfos.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID=@"cell";
    CustomerTrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CustomerTrackTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
        
        
//        cell=[[CustomerTrackTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        
    }
    CustomerFollowUpEntity* entity=[self.customerInfos objectAtIndex:indexPath.row];
    cell.lb_userName.text=entity.customerName;
    cell.lb_callBackType.text=entity.followUpType;
    cell.lb_lastTime.text=entity.visteDate;
    cell.starsCount=[entity.customerLevel integerValue];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomerTrackDetailViewController* vc=[[CustomerTrackDetailViewController alloc]init];
    vc.title=@"客户跟踪";
    if (self.customerInfos.count>0) {
        CustomerFollowUpEntity* customer=[self.customerInfos objectAtIndex:indexPath.row];
        vc.customer=customer;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
