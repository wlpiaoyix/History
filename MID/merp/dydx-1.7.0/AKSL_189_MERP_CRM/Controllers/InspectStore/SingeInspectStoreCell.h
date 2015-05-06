//
//  SingeInspectStoreCell.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-4-14.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"
#import "InspectStoreInfo.h"
#import "InspectStoreViewController.h"


@interface SingeInspectStoreCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *textTime;
@property (weak, nonatomic) IBOutlet UILabel *textUserName;
@property (weak, nonatomic) IBOutlet UILabel *textStoreName;
@property (weak, nonatomic) IBOutlet UILabel *textAddr;
@property (weak, nonatomic) IBOutlet EMAsyncImageView *imageUrl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *textContent;
@property (weak, nonatomic) IBOutlet EMAsyncImageView *userImageHeader;

-(void)setData:(InspectStoreInfo *)data  inspectView:(InspectStoreViewController *)inspectview indexInListData:(int)indexInList;

@end
