//
//  dydxTrafficManageCell.h
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-8-6.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dydxTrafficManageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblUserCount;
@property (weak, nonatomic) IBOutlet UILabel *lblPakageCount;
@property (weak, nonatomic) IBOutlet UILabel *lblPakagePayment;
@property (weak, nonatomic) IBOutlet UILabel *lblAppCount;
@property (weak, nonatomic) IBOutlet UILabel *lblAppPayment;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak,nonatomic) IBOutlet UIView * mainView;
-(void)setdata:(NSDictionary *)datadic;

@end
