//
//  zeroApplicationViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-8-1.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface zeroApplicationViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableData;

@property (weak, nonatomic) IBOutlet UILabel *lblTongji;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

-(void)setOrgOrTime:(int)orgId :(NSString *)time :(NSString *)title;
- (IBAction)back:(id)sender;

@end
