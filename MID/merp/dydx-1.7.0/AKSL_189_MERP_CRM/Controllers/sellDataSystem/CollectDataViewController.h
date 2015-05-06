//
//  CollectDataViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-7.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellSystemViewController.h"

@interface CollectDataViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *statrTime;
@property (weak, nonatomic) IBOutlet UILabel *SumSellData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSArray * listForData;
@property(assign,nonatomic) int listForTotal;
@property (strong,nonatomic) NSArray *fristName;
@property (strong,nonatomic) NSString *endTimeStr;
@property (strong,nonatomic) NSString *startTimeStr;
@property (assign,nonatomic) long pid;

@property (weak,nonatomic) SellSystemViewController * sellpage;

@end
