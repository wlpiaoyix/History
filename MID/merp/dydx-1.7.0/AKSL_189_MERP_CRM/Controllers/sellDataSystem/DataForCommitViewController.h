//
//  DataForCommitViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-2-27.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SellSystemViewController.h"

@interface DataForCommitViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
 
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign,nonatomic) long pid;

@property (strong,nonatomic) NSArray * listForData;
@property (strong,nonatomic) NSArray *fristName;

@property (weak,nonatomic) SellSystemViewController * sellpage;

@property (weak,nonatomic) IBOutlet UILabel *textForOne;
@property (weak,nonatomic) IBOutlet UILabel *textForTow;
@property (weak,nonatomic) IBOutlet UILabel *textForThree;
@property (weak,nonatomic) IBOutlet UILabel *textForFrou;

@end
