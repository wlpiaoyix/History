//
//  FlowQueryRestViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-2-24.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface FlowQueryRestViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>{
    NSString * urlForQueryFlow;
    NSString * timeString;
    NSArray * listForData;
}
@property (weak, nonatomic) IBOutlet UILabel *textTimeString;
@property (weak, nonatomic) IBOutlet UILabel *textFirstDayActiveTotalNum;
@property (weak, nonatomic) IBOutlet UILabel *textTrafficAppTotalNum;
@property (weak, nonatomic) IBOutlet UILabel *textTrafficPackTotalNum;
@property (weak, nonatomic) IBOutlet UILabel *textTotalPayment;
@property (weak, nonatomic) IBOutlet UIView *TopView;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (assign) int selectPepleType;
-(void)setUrlForQuery:(NSString *)url;
-(void)setTimeString:(NSString *)str;
@end
