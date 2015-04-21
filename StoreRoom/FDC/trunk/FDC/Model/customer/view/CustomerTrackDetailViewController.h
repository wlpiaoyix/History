//
//  CustomerTrackDetailViewController.h
//  FDC
//
//  Created by NewDoone on 15/1/26.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "FDCController.h"
#import "CustomerFollowUpEntity.h"

@interface CustomerTrackDetailViewController : FDCController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *photoIV;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoBtn;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *stars;
@property (weak, nonatomic) IBOutlet UILabel *callBackType;
@property (weak, nonatomic) IBOutlet UILabel *firstInterviewTime;
@property (weak, nonatomic) IBOutlet UILabel *houseAddress;
@property (weak, nonatomic) IBOutlet UILabel *payStatus;
@property (weak, nonatomic) IBOutlet UILabel *interViewCount;
@property (weak, nonatomic) IBOutlet UILabel *callBackCount;
@property (weak, nonatomic) IBOutlet UILabel *callBackReminderCount;
@property (weak, nonatomic) IBOutlet UITableView *callBackTableView;
@property (weak, nonatomic) IBOutlet UITableView *callBackHistroyTableView;

@property(nonatomic,strong) CustomerFollowUpEntity* customer;
@end
