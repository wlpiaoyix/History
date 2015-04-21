//
//  CustomerTrackDetailViewController.m
//  FDC
//
//  Created by NewDoone on 15/1/26.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "CustomerTrackDetailViewController.h"
#import "CustomerCallBackHistroyTableViewCell.h"
#import "CustomerCallBackReminderTableViewCell.h"
#import "ConfigManage+Expand.h"
#import "CustomerMainManager.h"

@interface CustomerTrackDetailViewController ()
@property(nonatomic,strong) CustomerFollowUpDetailEnity* detailCustomerInfo;
@end

@implementation CustomerTrackDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}
-(void)loadData{
    UserEntity* user=[ConfigManage getLoginUser];
    CustomerMainManager* manager=[[CustomerMainManager alloc]init];
    [manager followUpDetailForCustomerWithObjectId:user.objectId customerId:self.customer.customerId success:^(id data, NSDictionary *userInfo) {
        self.detailCustomerInfo=(CustomerFollowUpDetailEnity*)data;
        self.userName.text=self.customer.customerName;
        self.callBackType.text=self.customer.followUpType;
        self.firstInterviewTime.text=self.customer.visteDate;
        self.houseAddress.text=self.detailCustomerInfo.houseNum;
        self.payStatus.text=self.customer.dealStatu;
        self.interViewCount.text=[NSString stringWithFormat:@"%@",self.detailCustomerInfo.visitRecordTimes];
        self.callBackCount.text=[NSString stringWithFormat:@"%@",self.detailCustomerInfo.visitPhoneRecordTimes];
        self.callBackReminderCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)self.detailCustomerInfo.followUpRecords.count];
        
    } faild:^(id data, NSDictionary *userInfo) {
        
    }];
}
-(void)initView{
    CGRect callFrame=self.callBackHistroyTableView.frame;
    callFrame.size.height=180;
    self.callBackHistroyTableView.frame=callFrame;
    
    self.scrollView.frame=[UIScreen mainScreen].bounds;
    CGRect frame =self.scrollView.frame;
    frame.size.height=frame.size.height-self.navigationController.toolbar.frameHeight;
    self.scrollView.frame=frame;
    if ([UIScreen mainScreen].bounds.size.height>480.0) {
        self.scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, self.callBackHistroyTableView.frameY+self.callBackHistroyTableView.frameHeight+80);
    }else{
        self.scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, self.callBackHistroyTableView.frameY+self.callBackHistroyTableView.frameHeight*2-100);
    }
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.showsVerticalScrollIndicator =NO;
    self.scrollView.bounces=NO;
}
- (IBAction)addTrackAction:(id)sender {
    
}
- (IBAction)addCallBackAction:(id)sender {
    
}
#pragma tableViewDegelate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* callBackID=@"callBackID";
    static NSString* callBackHisID=@"callBackHisID";
    if (tableView==self.callBackTableView) {
        CustomerCallBackReminderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:callBackID];
        if (cell == nil)
        {
            [tableView registerNib:[UINib nibWithNibName:@"CustomerCallBackReminderTableViewCell" bundle:nil] forCellReuseIdentifier:callBackID];
            cell=[tableView dequeueReusableCellWithIdentifier:callBackID];
        }
        return cell;
    }
    else{
        CustomerCallBackHistroyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:callBackHisID];
        if (cell == nil)
        {
            [tableView registerNib:[UINib nibWithNibName:@"CustomerCallBackHistroyTableViewCell" bundle:nil] forCellReuseIdentifier:callBackHisID];
            cell=[tableView dequeueReusableCellWithIdentifier:callBackHisID];
        }
        return cell;
    }
//        return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}





@end
