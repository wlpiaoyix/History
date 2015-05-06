//
//  TrafficQueryStaffCell.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-4-29.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrafficQueryStaffCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *textAppCount;
@property (weak, nonatomic) IBOutlet UILabel *textPackCount;
@property (weak, nonatomic) IBOutlet UILabel *textUseCount;
@property (weak, nonatomic) IBOutlet UILabel *textPayment;
@property (weak, nonatomic) IBOutlet UILabel *textUserName;
@property (weak, nonatomic) IBOutlet UIImageView *image01;
@property (weak, nonatomic) IBOutlet UIImageView *image02;
@property (weak, nonatomic) IBOutlet UIImageView *image03;

-(void)setData:(NSString *)userName AppCount:(int)app PackCount:(int)pack UseCount:(int)use NumForSell:(double)sell;
@end
