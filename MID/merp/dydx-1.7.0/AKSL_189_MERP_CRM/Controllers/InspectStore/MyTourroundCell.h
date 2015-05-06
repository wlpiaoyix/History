//
//  MyTourroundCell.h
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-5-29.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"

@interface MyTourroundCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UILabel *lblMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblCheckLocation;
@property (weak, nonatomic) IBOutlet UITextView *textCheckTypeName;
@property (weak, nonatomic) IBOutlet UITextView *textOrgName;
@property (weak, nonatomic) IBOutlet EMAsyncImageView *imgDefaultPic;
-(void)setTourroundData:(NSDictionary *)tourroundDic ISDate:(BOOL)isDate IsCheckType:(BOOL)isCheckType;
@end
