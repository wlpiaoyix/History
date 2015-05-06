//
//  UseCell.h
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-4-18.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblPrompt;
@property (weak, nonatomic) IBOutlet UIImageView *imgMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;
-(void)setData:(NSDictionary *)dic;
@end
