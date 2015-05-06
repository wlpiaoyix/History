//
//  InspectStoreListViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-17.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "InspectStoreInfo.h"

@interface InspectStoreListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign,nonatomic) long ids;
@property (assign,nonatomic) bool isChangeData;
@property (assign) int CountForMsg;
-(void)setMainView:(UIViewController *)view;
-(void)reloadData:(bool)isFrist;
-(void)reloadData;
-(InspectStoreInfo *)getInspectStroeInfo:(int)index;
@end
