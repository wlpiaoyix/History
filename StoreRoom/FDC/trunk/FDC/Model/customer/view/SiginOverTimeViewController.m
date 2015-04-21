//
//  SiginOverTimeViewController.m
//  FDC
//
//  Created by NewDoone on 15/1/28.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "SiginOverTimeViewController.h"
#import "SiginOverTimeTableViewCell.h"
#import "ConfigManage+Expand.h"
#import "CustomerMainManager.h"
#import "SignOverdueEntity.h"

@interface SiginOverTimeViewController ()

@end

@implementation SiginOverTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view from its nib.
}
-(void)loadData{
    UserEntity* user=[ConfigManage getLoginUser];
    CustomerMainManager* manager=[[CustomerMainManager alloc]init];
    [manager singedOverdueForCustomer:user.userName objectId:user.objectId startTime:nil endTime:nil success:^(id data, NSDictionary *userInfo) {
        
    } faild:^(id data, NSDictionary *userInfo) {
        
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

    CGRect frame=self.tableView.frame;
    frame.size.height=[UIScreen mainScreen].bounds.size.height-frame.origin.y-108;
    self.tableView.frame=frame;
}
#pragma tableViewDegelate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.signInfos.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID=@"cell";
    SiginOverTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        [tableView registerNib:[UINib nibWithNibName:@"SiginOverTimeTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
        
        
        //        cell=[[CustomerBirthdayDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        
    }
    SignOverdueEntity* entity=[self.signInfos objectAtIndex:indexPath.row];
    cell.userName.text=entity.customerName;
    cell.phoneNumber.text=entity.signPhone;
    cell.lastTrackDate.text=entity.signSubscriptionDate;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

@end
