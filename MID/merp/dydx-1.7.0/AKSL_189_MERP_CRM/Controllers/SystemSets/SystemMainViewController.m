//
//  SystemMainViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-5-8.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "SystemMainViewController.h"
#import "SystemMainCell.h"
#import "SystemSetsExtsCell.h"
#import "IndividualCenterViewController.h"
#import "UpdatePwdViewController.h"
#import "FeedbackViewController.h"
#import "AboutSoftwareViewController.h"


@interface SystemMainViewController ()
{
    NSArray *dataArray;
}

@end

@implementation SystemMainViewController

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
    
    // Do any additional setup after loading the view from its nib.
    [self.systable registerNib:[UINib nibWithNibName:@"SystemMainCell" bundle:nil] forCellReuseIdentifier:@"sysCell"];
    [self.systable registerNib:[UINib nibWithNibName:@"SystemSetsExtsCell" bundle:nil] forCellReuseIdentifier:@"systemExtsCell"];
    [self setData];
    self.systable.delegate = self;
    self.systable.dataSource = self;
}
-(void)setData
{
   // NSString *str = @"{\"data\":[{\"gerenzhongxin\":\"个人中心\"},{\"xiugaimima\":\"修改密码\"},{\"yijianfankui\":\"意见反馈\"},{\"guanyuruanjian\":\"关于软件\"},{\"ruanjiangengxin\":\"软件更新:1.6.0\"},{\"qingchuhuancun\":\"清除缓存\"}]}";
    NSString *str = @"{\"data\":[{\"type\":[\"个人中心\",\"修改密码\"]},{\"type\":[\"意见反馈\",\"关于软件\",\"软件更新:1.6.0\"]},{\"type\":[\"清除缓存\"]}]}";
    NSDictionary *dic = [str JSONValueNewMy];
    dataArray = [dic objectForKey:@"data"];
    [self.systable reloadData];
    

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger index = 0;
    if ([dataArray count] == 0) {
        index = 0;
    }
    else if (section == 0) {
         index = [[[dataArray objectAtIndex:0] objectForKey:@"type"] count];
    }
    else if (section == 1) {
        index = [[[dataArray objectAtIndex:1] objectForKey:@"type"] count];
    }
    else if (section == 2)
    {
        index = [[[dataArray objectAtIndex:2] objectForKey:@"type"] count];
    }
    else if (section == 3)
    {
        index = 1;
    }
    return index;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dataArray count]+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger index = [indexPath section];
    id cellx;
    if (index == 0)
    {
        SystemMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sysCell"];
        if(!cell)
        {
            cell = [[SystemMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sysCell"];
        }
        cell.lblsystemName.text = [[[dataArray objectAtIndex:0] objectForKey:@"type"] objectAtIndex:indexPath.row];
         cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.lblsystemName.font = [UIFont systemFontOfSize:14];
        cellx = cell;
    }
    else if (index == 1)
    {
        SystemMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sysCell"];
        if(!cell)
        {
            cell = [[SystemMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sysCell"];
        }
        cell.lblsystemName.text = [[[dataArray objectAtIndex:1] objectForKey:@"type"] objectAtIndex:indexPath.row];
         cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.lblsystemName.font = [UIFont systemFontOfSize:14];
        cellx = cell;
    }
    else if (index == 2)
    {
        SystemMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sysCell"];
        if(!cell)
            
        {
            cell = [[SystemMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sysCell"];
        }
        cell.lblsystemName.text = [[[dataArray objectAtIndex:2] objectForKey:@"type"] objectAtIndex:indexPath.row];
         cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.lblsystemName.font = [UIFont systemFontOfSize:14];
        cellx = cell;
    }
    else if (index == 3)
    {
        SystemSetsExtsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"systemExtsCell"];
        if(!cell)
        {
            cell = [[SystemSetsExtsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"systemExtsCell"];
        }
         cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cellx = cell;
    }
    return cellx;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSUInteger index = [indexPath section];
    if (index == 3) {
        index = 58;
    }
    else
    {
        index = 44;
    }
    return index;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0 alpha:0.1];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0 alpha:0.1];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = [indexPath section];
    if (index == 0 && indexPath.row == 0) {
        [self.navigationController pushViewController:[[IndividualCenterViewController alloc] init] animated:YES];
    }
    else if (index == 0 && indexPath.row ==1)
    {
        [self.navigationController pushViewController:[[UpdatePwdViewController alloc] init] animated:YES];
    }
    else if (index == 1 && indexPath.row ==0)
    {
        [self.navigationController pushViewController:[[FeedbackViewController alloc] init] animated:YES];
    }
    else if (index == 1 && indexPath.row ==1)
    {
        [self.navigationController pushViewController:[[AboutSoftwareViewController alloc] init] animated:YES];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
