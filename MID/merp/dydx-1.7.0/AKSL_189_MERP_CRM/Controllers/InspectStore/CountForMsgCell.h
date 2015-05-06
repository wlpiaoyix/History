//
//  CountForMsgCell.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-4-3.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountForMsgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *MainLableView;
@property (weak, nonatomic) IBOutlet UILabel *textForCount;
-(void)setData:(int)count;

@end
