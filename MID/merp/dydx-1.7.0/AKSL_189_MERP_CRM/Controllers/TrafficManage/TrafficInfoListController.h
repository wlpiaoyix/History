//
//  TrafficInfoListController.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-4-22.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TraffincInfoViewController.h"

@interface TrafficInfoListController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *viewHeaderForTable;
@property (weak, nonatomic) IBOutlet UILabel *textForTitle;
@property (weak, nonatomic) IBOutlet UILabel *textForTotal;
@property (weak, nonatomic) IBOutlet UIImageView *ImageForIconType;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) TraffincInfoViewController * pViewController;
@property (assign) int type;

-(void)reloadData:(BOOL)isFrist;
@end
