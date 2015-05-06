//
//  InspectStoreDetailInfoCell.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-Apple on 14/6/26.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"
#import "InspectStoreInfoListPage.h"
#import "InspectStoreInfo.h"

@interface InspectStoreDetailInfoCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *textUserName;
@property (weak, nonatomic) IBOutlet UILabel *textStoreName;
@property (weak, nonatomic) IBOutlet UILabel *textAddr;
@property (weak, nonatomic) IBOutlet EMAsyncImageView *imageUrl;
@property (weak, nonatomic) IBOutlet EMAsyncImageView *userHaderImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak,nonatomic) IBOutlet UILabel * textForDate;
@property (weak,nonatomic) IBOutlet UITextView * textForInfo;
@property (weak,nonatomic) IBOutlet UITextView * textForType;
@property (weak,nonatomic) IBOutlet UIView * listView;
-(void)setData:(InspectStoreInfo *)data inspectView:(InspectStoreInfoListPage *)inspectview indexInListData:(int)indexInList;

@end
