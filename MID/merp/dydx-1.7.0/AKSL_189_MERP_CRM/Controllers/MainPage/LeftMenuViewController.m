//
//  LeftMenuViewController.m
//  Anbaby－V2.0.0
//
//  Created by AKSL-td on 13-10-5.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MainPageViewController.h"
#import "MyScheduleViewController.h"
#import "NotesViewController.h"
#import "SellDataViewController.h" 
#import "ScanQRViewController.h"
#import "SystemSetsMainController.h"
#import "SellSystemViewController.h"
#import "KnowledgeBaseViewController.h"
#import "InspectStoreViewController.h"
#import "FlowManageViewController.h"
#import "FlowSubOrgViewController.h"
#import "TrafficOrgInfoViewController.h"
#import "TrafficManageViewController.h"
#import "dydxTrafficManagementViewController.h"

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController

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
    UILabel *label;
    for (int i = 2001; i<=2005; i++) {
        label = (UILabel *)[_viewForOp viewWithTag:i];
        label.hidden = YES;
        label.layer.cornerRadius = 8;
        label.layer.borderWidth = 0.7;
        label.layer.borderColor = [[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1] CGColor];
    }
    if ([TITLE_APP_EN isEqualToString:@"zylt"]) {
        [self hideButton:1004];
    }
     [self hideButton:1007];
    switch ([ConfigManage getLoginUser].roelId) {
        case 4:
            [self hideButton:1005];
            [self hideButton:1007];
            break;
        case 6:
            [self hideButton:1002];
            [self hideButton:1003];
            [self hideButton:1005];
            [self hideButton:1007];
            break;
       // case 3:
         // [self hideButton:1004];
       //     break;
       // case 2:
      //  case 1:
          //  if (![ConfigManage getLoginUser].isTrafficAdmin) {
          //      [self hideButton:1004];
         //   }
        default:
            break;
    }
    //_test1.layer.cornerRadius = 5;
    //_test1.layer.borderWidth = 0.5;
    //_test1.layer.borderColor = [[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1] CGColor];
}

-(void)showBadge:(int)num Set:(int)set{
    if(set>4||set<1||num>999){
        return;
    }
    UILabel *label = (UILabel *)[_viewForOp viewWithTag:set+2000];
    label.hidden = NO;
    label.text = [NSString stringWithFormat:@"%d",num];
    
}
-(void)hideBadge:(int)set{
    if(set>5||set<1){
        return;
    }
    UILabel *label = (UILabel *)[_viewForOp viewWithTag:set+2000];
    label.hidden = YES;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setSelectButton:(int)setindex{
    UIButton *but;
    for (int i = 1001; i<=1009; i++) {
        but = (UIButton *)[_viewForOp viewWithTag:i];
        [but setSelected:NO];
        if (i==setindex) {
            [but setSelected:YES];
        }
    }
}
- (IBAction)mainButtonCilck:(id)sender {
    UIButton *but;
    for (int i = 1001; i<=1009; i++) {
        but = (UIButton *)[_viewForOp viewWithTag:i];
        [but setSelected:NO];
    }
    but =(UIButton *)sender;
    [but setSelected:YES];
    [self hideBadge:but.tag-1000];
    UIViewController * view = nil;
    switch (but.tag) {
        case 1001:
            view = [MainPageViewController getMainPage];
            break;
        case 1002:
            view = [[SellSystemViewController alloc]initWithNibName:@"SellSystemViewController" bundle:nil isDataTable:NO SelectDic:nil isFristPage:YES];
            view.title = @"手工上报";
           
            break;
        case 1003:
            view = [[SellSystemViewController alloc]initWithNibName:@"SellSystemViewController" bundle:nil isDataTable:YES SelectDic:nil isFristPage:YES];
            view.title = @"系统日报";
            
            break;
        case 1004:
            if ([ConfigManage getLoginUser].roelId!=4 && [ConfigManage getLoginUser].roelId!=6) {
                //                 view = [TrafficOrgInfoViewController getNewInstance];//
                //                [[TrafficOrgInfoViewController getNewInstance] setQueryDate:@"day"];
                view = [[dydxTrafficManagementViewController alloc] initWithNibName:@"dydxTrafficManagementViewController" bundle:nil];
            }else{
                view = [[TrafficManageViewController alloc]initWithNibName:@"TrafficManageViewController" bundle:nil];
                
            }
            break;
        case 1005:
            view = [InspectStoreViewController getInspectStoreMain];
                    break;
        case 1006:
            view = [KnowledgeBaseViewController getKnowledgeBase];
            break;
        case 1007:
             view = [[ScanQRViewController alloc]initWithNibName:@"ScanQRViewController" bundle:nil];
            //[[SystemSetsMainController alloc]initWithNibName:@"SystemSetsMainController" bundle:nil];
            break;
        case 1008:
            view = [[MyScheduleViewController alloc]initWithNibName:@"MyScheduleViewController" bundle:nil];
            break;
        case 1009:
            view = [SystemSetsMainController initForReturnList];
            break;
    }
     
    
    
    if(view!=nil){
     
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:view];
     nav.navigationBar.hidden = YES;
    [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
    }
}

-(void)hideButton:(int)setindex{

    UIButton *but;
    but = (UIButton *)[_viewForOp viewWithTag:setindex];
    if (but.hidden) {
        return;
    }
    but.hidden = YES;
    but.enabled = NO;
    CGRect frameButtonForChange;
    
    for (int i = setindex+1; i<=1009; i++) {
        but = (UIButton *)[_viewForOp viewWithTag:i];
        frameButtonForChange = but.frame;
        frameButtonForChange.origin.y -= 45;
        but.frame = frameButtonForChange;
        
    }
    frameButtonForChange = _viewForOp.frame;
    frameButtonForChange.size.height -= 45;
    _viewForOp.frame = frameButtonForChange;
}
@end
