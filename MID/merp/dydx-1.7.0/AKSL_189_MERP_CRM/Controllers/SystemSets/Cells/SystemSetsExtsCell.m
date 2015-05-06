//
//  SystemSetsExtsCell.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-5.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "SystemSetsExtsCell.h"
#import "LoginViewController.h"
#import "ConfigManage.h"
#import "MainPageViewController.h"
#import "SellDataViewController.h"
#import "FlowManageViewController.h"
#import "InspectStoreViewController.h"
#import "KnowledgeBaseViewController.h"
#import "TrafficOrgInfoViewController.h"
#import "BPush.h"

@interface SystemSetsExtsCell()
@property NSTimeInterval curtv;
@end;
@implementation SystemSetsExtsCell

+(id)init{
    SystemSetsExtsCell *ssc = [[[NSBundle mainBundle] loadNibNamed:@"SystemSetsExtsCell" owner:self options:nil] lastObject];
    ssc.backgroundColor = [UIColor colorWithRed:0.914 green:0.914 blue:0.914 alpha:1];
    ssc.contentView.backgroundColor = [UIColor colorWithRed:0.914 green:0.914 blue:0.914 alpha:1];
    return ssc;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)exitSystems:(UIButton *)sender {
    [ConfigManage clearAllData];
    [MainPageViewController NewMainPage];
    [SellDataViewController newSellData];
    [TrafficOrgInfoViewController newInstance];
    [KnowledgeBaseViewController newKnowledgeBase];
    [BPush delTag:[ConfigManage getLoginUser].userCode];
    LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
    [nav.navigationBar setHidden:YES];
    [UIApplication sharedApplication].keyWindow.rootViewController = login;
//    UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认要退出登录?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
//    [alert show];
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            if (YES) {
                NSLog(@"==========================ffff");

            }
            break;
        default:
            break;
    }
}

@end
