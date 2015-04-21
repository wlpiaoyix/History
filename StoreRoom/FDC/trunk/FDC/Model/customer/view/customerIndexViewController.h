//
//  customerIndexViewController.h
//  FDC
//
//  Created by NewDoone on 15/1/20.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "FDCController.h"
#import "MCProgressBarView.h"

@interface customerIndexViewController : FDCController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UILabel *lb_userName;
@property (weak, nonatomic) IBOutlet UILabel *lb_buildingName;
@property (weak, nonatomic) IBOutlet UIView *sellPlanView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
