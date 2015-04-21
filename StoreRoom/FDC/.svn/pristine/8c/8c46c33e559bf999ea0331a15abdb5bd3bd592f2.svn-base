//
//  CustomerBirthdayDetailViewController.m
//  FDC
//
//  Created by NewDoone on 15/1/22.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "CustomerBirthdayDetailViewController.h"
#import "CustomerBirthdayDetailTableViewCell.h"
#import "CustomerMainManager.h"
#import "ConfigManage+Expand.h"

@interface CustomerBirthdayDetailViewController ()
@property(nonatomic,strong)NSMutableArray* phoneNumbers;
@property(nonatomic,strong)NSMutableArray* customerBirthdayInfos;
@end
static NSInteger pressBtnCounts;
@implementation CustomerBirthdayDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.allowsSelection=NO;
    [self initView];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}
-(void)loadData{
    self.customerBirthdayInfos=nil;
    self.customerBirthdayInfos=[NSMutableArray array];
    UserEntity* user=[ConfigManage getLoginUser];
    CustomerMainManager* manager=[[CustomerMainManager alloc]init];
    [manager birthDayForCustomerWithObjectId:user.objectId success:^(id data, NSDictionary *userInfo) {
        NSLog(@"data===%@",data);
    } faild:^(id data, NSDictionary *userInfo) {
        
    }];
}
-(void)initView{
    CGRect frame=self.tableView.frame;
         frame=CGRectMake(0, self.btn_selectAll.frame.origin.y+self.btn_selectAll.frame.size.height+5, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-frame.origin.y-self.navigationController.toolbar.frameHeight-64);
 
    self.tableView.frame=frame;
}

- (IBAction)selectAllAction:(id)sender {
    pressBtnCounts++;
    self.tableView.allowsSelection=YES;
    self.tableView.allowsMultipleSelection=YES;
    NSArray* cells=[self.tableView visibleCells];
    for (UITableViewCell* cell in cells) {
        cell.selected=YES;
        if (pressBtnCounts%2==0) {
            cell.selected=NO;
            self.tableView.allowsSelection=NO;
            self.tableView.allowsMultipleSelection=NO;

        }
    }
}
- (IBAction)sendGroupMessageAction:(id)sender {
    for (NSString* phoneNumber in self.phoneNumbers) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",phoneNumber]]];
    }
}
#pragma tableViewDegelate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID=@"cell";
    CustomerBirthdayDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CustomerBirthdayDetailTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
       
        
//        cell=[[CustomerBirthdayDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        
    }
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
@end
