//
//  CommentInfoCell.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-3-28.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentInfo.h"

@interface CommentInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *textFormUserName;
@property (weak, nonatomic) IBOutlet UILabel *textCommentBackLabel;
@property (weak, nonatomic) IBOutlet UILabel *textToUserName;
@property (weak, nonatomic) IBOutlet UILabel *textTime;
@property (weak, nonatomic) IBOutlet UILabel *textConent;

-(void)setData:(CommentInfo *)info;

@end
