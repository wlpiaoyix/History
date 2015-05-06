//
//  CommentInfoDetailedCell.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-4-16.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"
#import "CommentInfo.h"


@interface CommentInfoDetailedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *textFormUserName;
@property (weak, nonatomic) IBOutlet UILabel *textCommentBackLabel;
@property (weak, nonatomic) IBOutlet UILabel *textToUserName;
@property (weak, nonatomic) IBOutlet UILabel *textTime;
@property (weak, nonatomic) IBOutlet UILabel *textConent;
@property (weak, nonatomic) IBOutlet EMAsyncImageView *userImageHeader;
-(void)setData:(CommentInfo *)info;

@end
