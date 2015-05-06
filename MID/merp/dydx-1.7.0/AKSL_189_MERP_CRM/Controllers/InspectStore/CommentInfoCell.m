//
//  CommentInfoCell.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-3-28.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "CommentInfoCell.h"

@implementation CommentInfoCell

- (void)awakeFromNib
{
    // Initialization code
}
-(void)setData:(CommentInfo *)info{
    _textFormUserName.text = info.fromUserName;
    _textToUserName.text = info.toUserName;
    _textTime.text = info.timeString;
    _textConent.text = info.Conents;
    if (info.isHaveToUser) {
        _textToUserName.hidden = NO;
        _textCommentBackLabel.hidden = NO;
        CGFloat w = [info.fromUserName sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, 200)].width;
        CGRect  frame = _textCommentBackLabel.frame;
        frame.origin.x = w +9;
        _textCommentBackLabel.frame = frame;
        frame = _textToUserName.frame;
        frame.origin.x = w + 39;
        _textToUserName.frame = frame;
    }else{
        _textToUserName.hidden = YES;
        _textCommentBackLabel.hidden = YES;
    }
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
