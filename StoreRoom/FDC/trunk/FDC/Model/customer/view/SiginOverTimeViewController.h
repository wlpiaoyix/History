//
//  SiginOverTimeViewController.h
//  FDC
//
//  Created by NewDoone on 15/1/28.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "FDCController.h"

@interface SiginOverTimeViewController : FDCController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segementControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSMutableArray* signInfos;
@end
