//
//  MyScheduleCustomerCell.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-10.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"
@interface MyScheduleCustomerCell : UITableViewCell
@property (retain, nonatomic) IBOutlet EMAsyncImageView *imageHead;
@property (retain, nonatomic) IBOutlet UILabel *lableUserName;
@property (retain, nonatomic) IBOutlet UILabel *lableInfo;


@end
