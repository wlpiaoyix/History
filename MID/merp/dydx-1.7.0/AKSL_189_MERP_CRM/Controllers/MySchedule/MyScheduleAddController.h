//
//  MyScheduleAddController.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-7.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyScheduleDateTimeSetController.h"
#import "MyScheduleViewController.h"
@interface MyScheduleAddController : BaseViewController <UIAlertViewDelegate>
@property bool ifLockOpt;//如果是查看就是不能做数据操作
@property (retain, nonatomic) MyScheduleViewController *target;
@property (retain, nonatomic) IBOutlet UILabel *lableTitle;
@property bool switchFlag;
@property (retain, nonatomic) IBOutlet UIView *viewHead;
@property (retain, nonatomic) IBOutlet UIView *viewContext;
@property (retain, nonatomic) IBOutlet UIView *viewDate;
@property (retain, nonatomic) IBOutlet UIView *viewCustomer;
@property (retain, nonatomic) IBOutlet UITextView *textViewContext;
@property (retain, nonatomic) IBOutlet UILabel *lableDateTime;
@property (retain, nonatomic) IBOutlet UILabel *lableCustomers;
@property (retain, nonatomic) IBOutlet UIButton *buttonConfirm;
@property (retain, nonatomic) IBOutlet UISwitch *swtichAlert;
@property (retain, nonatomic) IBOutlet UIButton *buttonDel;

@property (retain, nonatomic) NSNumber *_ids;
@property (retain, nonatomic) id _type;
@property (retain, nonatomic) NSMutableArray *userNames;
@property (retain, nonatomic) NSMutableArray *userIds;
@property (retain, nonatomic) NSNumber *_isRemind;
@property (retain, nonatomic) NSString *_remindDate;
@property (retain, nonatomic) NSString *_contents;

@end
