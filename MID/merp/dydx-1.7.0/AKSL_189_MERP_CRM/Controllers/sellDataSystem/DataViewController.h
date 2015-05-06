//
//  DataViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-6.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SellSystemViewController.h"

@interface DataViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *sunOfMonth;
@property (weak, nonatomic) IBOutlet UILabel *sumOfToday;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign,nonatomic) long pid;
@property (weak, nonatomic) IBOutlet UILabel *textDayTotalCount;


@property (weak,nonatomic) SellSystemViewController * sellpage;
@property (strong,nonatomic) NSArray * listForData;
@property (strong,nonatomic) NSArray * listForTotal;
@property (strong,nonatomic) NSArray *fristName;
@end
