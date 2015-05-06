//
//  UIFlowYestodayCell.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-3-10.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFlowYestodayCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lablePhone;
@property (strong, nonatomic) IBOutlet UIImageView *image01;
@property (weak, nonatomic) IBOutlet UILabel *textPayment01;
@property (strong, nonatomic) IBOutlet UIImageView *image02;
@property (weak, nonatomic) IBOutlet UILabel *textPayment02;
@property (strong, nonatomic) IBOutlet UIImageView *image03;
@property (weak, nonatomic) IBOutlet UILabel *textPayment03;
@property (strong, nonatomic) IBOutlet UILabel *lableDate;

-(void)setData:(NSDictionary *)dic;
@end
