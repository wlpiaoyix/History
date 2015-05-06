//
//  TrafficReportController.h
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-4-21.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface TrafficReportController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *reportView;

- (IBAction)back:(id)sender;
- (IBAction)report:(id)sender;
- (IBAction)postReport:(id)sender;



@end
