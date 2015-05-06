//
//  zeroApplicationCell.h
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-8-1.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"

@interface zeroApplicationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet EMAsyncImageView *heardImg;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblBureau;
@property (weak, nonatomic) IBOutlet UILabel *lblArea;
@property (weak, nonatomic) IBOutlet UILabel *lblHall;
-(void)setdata:(NSDictionary *)dataDic;

@end
