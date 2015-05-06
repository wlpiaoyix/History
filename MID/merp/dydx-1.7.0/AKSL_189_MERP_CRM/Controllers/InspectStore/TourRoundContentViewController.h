//
//  TourRoundContentViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-6-23.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TourRoundContentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
- (IBAction)back:(id)sender;

- (IBAction)xundian_chaodian:(id)sender;

- (IBAction)zan_pinglun:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *_table;
@property (weak,nonatomic) IBOutlet UIView * mainView;

@end
