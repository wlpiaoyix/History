//
//  InspectStoreCell.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-17.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"
#import "InspectStoreViewController.h"
#import "InspectStoreInfo.h"

@interface InspectStoreCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *textDay;
@property (weak, nonatomic) IBOutlet UILabel *textMonth;
@property (weak, nonatomic) IBOutlet UILabel *textTime;
@property (weak, nonatomic) IBOutlet UILabel *textUserName;
@property (weak, nonatomic) IBOutlet UILabel *textStoreName;
@property (weak, nonatomic) IBOutlet UILabel *textAddr;
@property (weak, nonatomic) IBOutlet EMAsyncImageView *imageUrl;
@property (weak, nonatomic) IBOutlet UILabel *textYear;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(void)setData:(InspectStoreInfo *)data isShowDate:(bool)isShowDate inspectView:(InspectStoreViewController *)inspectview indexInListData:(int)indexInList;
 
@end
