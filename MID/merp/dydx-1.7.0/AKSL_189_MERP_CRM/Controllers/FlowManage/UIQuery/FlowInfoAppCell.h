//
//  FlowInfoAppCell.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-2-25.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowInfoAppCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *textNum;

@property (weak, nonatomic) IBOutlet UILabel *textName;
-(void)setData:(NSString *)name Number:(NSNumber *)num;
@end
