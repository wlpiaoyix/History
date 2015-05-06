//
//  KnowledgeDataCell.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-16.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "KnowledgeDataCell.h"

@implementation KnowledgeDataCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setData:(NSString *)title ImageUrl:(NSString *)url Content:(NSString *)content Date:(NSDate *)date readNum:(int)readnum{
    _textReadNum.layer.cornerRadius = 6;
    _textReadNum.layer.borderWidth = 0.5;
    _textReadNum.layer.borderColor = [[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.4]CGColor];
    _mainView.layer.cornerRadius = 5;
    _mainView.layer.borderWidth = 0.5;
    _mainView.layer.borderColor = [[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor];
    _textTitle.text = title;
    _textContent.text = content;
    _textDate.layer.cornerRadius = 5;
    _mainView.layer.borderWidth = 0.5;
    _mainView.layer.borderColor = [[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor];
    _textReadNum.text = [NSString stringWithFormat:@"浏览 %d",readnum];
    if (date) {
        _textDate.text =[date getFriendlyTime:NO];
    }else{
       _textDate.text = @"时间不详";
    }
    if (url&&![url isEqualToString:@""]) {
        _imageContent.imageUrl = url;
    }
    _imageContent.layer.cornerRadius=0;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
