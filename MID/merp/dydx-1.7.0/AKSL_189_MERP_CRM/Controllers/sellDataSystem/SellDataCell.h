//
//  SellDataCell.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-7.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellDataCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *planValue;
@property (weak, nonatomic) IBOutlet UILabel *todayValue;
@property (weak, nonatomic) IBOutlet UILabel *monthValue;
@property (weak, nonatomic) IBOutlet UILabel *overValue;
@property (weak, nonatomic) IBOutlet UIImageView *tagCommit;

-(void)setData:(NSString *)namestr Plan:(int)plan Today:(int)today Month:(int)month Over:(NSString *)over isCommit:(bool)isCommit;

@end
