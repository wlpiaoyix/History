//
//  TrafficTodayReportCell.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-4-21.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrafficTodayReportCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *textForPhoneNum;
@property (weak, nonatomic) IBOutlet UIImageView *imageForIconType;
@property (weak, nonatomic) IBOutlet UIImageView *imageForIconMeony;
@property (weak, nonatomic) IBOutlet UILabel *textForTime;
@property (weak, nonatomic) IBOutlet UILabel *textForNum;
@property (weak, nonatomic) IBOutlet UILabel *textForTotal;

-(void)setData:(NSString *)phoneNum Date:(NSDate*)date;
-(void)setData:(NSString *)phoneNum Type:(int)type Date:(NSDate *)date NumForTotal:(int)total NumForSell:(double)sell;
@end
