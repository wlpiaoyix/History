//
//  MyScheduleCustomerViewController.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-8.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface MyScheduleCustomerViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
@property (retain, nonatomic) NSArray *datas;
@property (retain, nonatomic) NSMutableArray *selected;
@property (retain, nonatomic) id targets;
@property  SEL methods;

@end
