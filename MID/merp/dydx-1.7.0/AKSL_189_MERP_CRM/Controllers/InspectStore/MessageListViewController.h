//
//  MessageListViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-3-27.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MessageListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *messageTalbleView;

- (IBAction)back:(id)sender;

@end
