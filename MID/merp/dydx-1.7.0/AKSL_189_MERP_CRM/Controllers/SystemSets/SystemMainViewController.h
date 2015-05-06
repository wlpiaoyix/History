//
//  SystemMainViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-5-8.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SystemMainViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *systable;

- (IBAction)back:(id)sender;
@end
