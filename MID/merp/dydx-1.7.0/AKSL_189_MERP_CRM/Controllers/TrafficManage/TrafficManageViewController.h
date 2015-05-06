//
//  TrafficManageViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-4-18.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface TrafficManageViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIControl *viewForTotal;
@property (weak, nonatomic) IBOutlet UIControl *viewForReport;
@property (weak, nonatomic) IBOutlet UIControl *viewForToReport;
@property (weak, nonatomic) IBOutlet UIControl *butToUseFlow;
@property (weak, nonatomic) IBOutlet UIControl *butToAId;
@property (weak, nonatomic) IBOutlet UIControl *butToSell;
@property (strong, nonatomic) IBOutlet UIView *viewHaderForTable;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)butClickToInfoPage:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *textForMonthTrafficSell;
@property (weak, nonatomic) IBOutlet UILabel *textForMonthTrafficApp;
@property (weak, nonatomic) IBOutlet UILabel *textForMonthTrafficUse;

@end
