//
//  dydxTrafficManagementViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-8-1.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface dydxTrafficManagementViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableData;
@property (weak, nonatomic) IBOutlet UIView *huizongView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserCount;
@property (weak, nonatomic) IBOutlet UILabel *lblPakageCount;
@property (weak, nonatomic) IBOutlet UILabel *lblPakagePayment;
@property (weak, nonatomic) IBOutlet UILabel *lblAppCount;
@property (weak, nonatomic) IBOutlet UILabel *lblAppPayment;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblHuiZong;

- (IBAction)zeroApplication:(id)sender;
- (IBAction)zeroSale:(id)sender;
- (IBAction)Screening:(id)sender;
- (IBAction)backUpInslde:(id)sender;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil :(BOOL)_falog;
-(void)setOrgId:(long)_orgId ;
-(void)setDate:(NSString *)date;

@end
