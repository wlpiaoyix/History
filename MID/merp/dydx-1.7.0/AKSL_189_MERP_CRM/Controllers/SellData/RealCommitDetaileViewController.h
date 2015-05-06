//
//  RealCommitDetaileViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 13-12-12.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RealCommitDetaileViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray * listDataForTable;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (assign,nonatomic)long long ids;
@end
