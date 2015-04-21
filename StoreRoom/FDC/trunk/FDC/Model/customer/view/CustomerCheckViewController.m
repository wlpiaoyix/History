//
//  CustomerCheckViewController.m
//  FDC
//
//  Created by NewDoone on 15/1/29.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "CustomerCheckViewController.h"
#import "VerifyIDCardNumberManagerTool.h"
#import "CustomerCheckTableViewCell.h"
#import "ConfigManage+Expand.h" 
#import "CustomerMainManager.h"
@interface CustomerCheckViewController ()

@end

@implementation CustomerCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
    // Do any additional setup after loading the view from its nib.
}
-(void)loadData{
    UserEntity* user=[ConfigManage getLoginUser];
    CustomerMainManager* manager=[[CustomerMainManager alloc]init];
    [manager verificationForCustomerWithObjectId:user.objectId customerName:nil customerPhone:nil certificate:nil success:^(id data, NSDictionary *userInfo) {
        
    } faild:^(id data, NSDictionary *userInfo) {
        
    }];
     
}
-(void)initView{
    CGRect frame=self.tableView.frame;
    frame.size.height=[UIScreen mainScreen].bounds.size.height-self.tf_customerID.frame.size.height-self.tf_customerID.frame.origin.y-104;
    self.tableView.frame=frame;
}
-(void)initData{
    self.projectName.text=@"金牛万达";
    self.projectNames=@[@"金牛万达",@"春熙路"];
}
- (IBAction)checkCustomerIDNumber:(id)sender {
    if (self.tf_customerID.text.length<=0) {
        UIAlertView* al=[[UIAlertView alloc]initWithTitle:@"提示" message:@"号码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [al show];
    }else{
        if (![VerifyIDCardNumberManagerTool verifyIDCardNumber:self.tf_customerID.text]) {
            UIAlertView* al=[[UIAlertView alloc]initWithTitle:@"提示" message:@"号码不正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [al show];
        }else{
            UIAlertView* al=[[UIAlertView alloc]initWithTitle:@"提示" message:@"验证通过" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [al show];
        
        }
    
    }
    
}
- (IBAction)showProjetNameList:(id)sender {
    LeveyPopListView* view=[[LeveyPopListView alloc]initWithTitle:@"请选择" options:self.projectNames];
    view.delegate=self;
    [view showInView:self.view.window animated:YES];
    
}
#pragma popListViewDelegate
- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex{
    self.projectName.text=[self.projectNames objectAtIndex:anIndex];
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
    CustomerCheckTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CustomerCheckTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
        
        
        //        cell=[[CustomerBirthdayDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 162;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

@end
