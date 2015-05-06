//
//  TrafficSummaryCell.h
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-5-19.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrafficSummaryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *_lblPnum;
@property (weak, nonatomic) IBOutlet UILabel *_lblPack;
@property (weak, nonatomic) IBOutlet UILabel *_lblApp;
@property (weak, nonatomic) IBOutlet UILabel *_lblUsage;
@property (weak, nonatomic) IBOutlet UILabel *_lblPayment;
@property (weak, nonatomic) IBOutlet UILabel *lbSetString;
@property (weak, nonatomic) IBOutlet UIView *viewMain;

-(void)setData:(NSString *)setString Pnum:(int)pnum Pack:(int)pack App:(int)app Useage:(int)useage Payment:(double)payment;
@end
