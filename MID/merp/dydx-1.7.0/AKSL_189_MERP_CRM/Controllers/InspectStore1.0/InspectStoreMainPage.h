//
//  InspectStoreMainPage.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-Apple on 14/6/10.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface InspectStoreMainPage : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tabelViewForList;
@end
