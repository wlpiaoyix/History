//
//  TrafficOrgInfoViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-5-16.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface TrafficOrgInfoViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *textFroApp;
@property (weak, nonatomic) IBOutlet UILabel *textForPayment;
@property (weak, nonatomic) IBOutlet UILabel *textForpnum;
@property (weak, nonatomic) IBOutlet UILabel *textForUseage;
@property (weak, nonatomic) IBOutlet UILabel *textForPack;
@property (weak, nonatomic) IBOutlet UILabel *textForTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *butForMenu;
@property (weak, nonatomic) IBOutlet UIButton *butForSelect;
+(id) getNewInstance;
+(void)newInstance;
-(void)setQueryDate:(NSString *)queryDate;
@end
