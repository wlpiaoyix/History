//
//  LikeCommentTableViewCell.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-3-31.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "LikeCommentTableViewCell.h"

@implementation LikeCommentTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}
-(void)setData:(NSString *)dataString{
    [_textForData setText:dataString];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
