//
//  TrafficInfoQueryViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-4-25.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface TrafficInfoQueryViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSString * urlForData;
@property (nonatomic,strong) NSString * noteForTableTitle;
@property (assign) bool isCanToFlier;
@property (assign) int type;
@end
