//
//  CollectDataCell.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-7.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectDataCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *value;
-(void)setData:(NSString *)namestr Value:(int)valueforcollect;
@end
