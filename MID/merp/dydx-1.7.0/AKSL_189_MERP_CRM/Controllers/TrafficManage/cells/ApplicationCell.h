//
//  ApplicationCell.h
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-4-18.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"

@interface ApplicationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet EMAsyncImageView *imgApplication;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@end
