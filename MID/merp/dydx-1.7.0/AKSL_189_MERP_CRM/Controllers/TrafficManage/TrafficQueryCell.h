//
//  TrafficQueryCell.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-4-28.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrafficQueryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *textPhoneNum;
@property (weak, nonatomic) IBOutlet UILabel *textAppCount;
@property (weak, nonatomic) IBOutlet UILabel *textPackCount;
@property (weak, nonatomic) IBOutlet UILabel *textPayment;
@property (weak, nonatomic) IBOutlet UIImageView *image03;
@property (weak, nonatomic) IBOutlet UIImageView *image02;
@property (weak, nonatomic) IBOutlet UILabel *textTime;
-(void)setData:(NSString *)phoneNum Date:(NSDate *)date AppCount:(int)app PackCount:(int)pack NumForSell:(double)sell;
@end
