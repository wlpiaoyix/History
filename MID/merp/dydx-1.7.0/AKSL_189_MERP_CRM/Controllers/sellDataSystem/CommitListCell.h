//
//  CommitListCell.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-8.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommitListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *NumberForCommit;
@property (weak, nonatomic) IBOutlet UILabel *name;

-(void)setData:(NSString *)name Value:(int)value;
@end
