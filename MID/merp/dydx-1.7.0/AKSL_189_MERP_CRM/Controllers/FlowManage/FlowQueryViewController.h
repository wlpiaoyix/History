//
//  FlowQueryViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-2-21.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SwitchSelected.h"

@interface FlowQueryViewController : BaseViewController{
     SwitchSelected* startDate;
    SwitchSelected* endDate;
    int selectPepleType;
    int selectBusType;
}
@property (weak, nonatomic) IBOutlet UIButton *butToQuery;
@property (weak, nonatomic) IBOutlet UIView *viewForPeple;
@property (weak, nonatomic) IBOutlet UIView *viewForBus;
@property (weak, nonatomic) IBOutlet UIView *dateSelectView;
- (IBAction)busButClick:(id)sender;
- (IBAction)pepleButClick:(id)sender;
- (IBAction)selectDateClick:(id)sender;

@end
