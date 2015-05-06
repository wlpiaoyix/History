//
//  CountForMsgCell.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-4-3.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "CountForMsgCell.h"

@implementation CountForMsgCell

- (void)awakeFromNib
{
    // Initialization code
}

-(void)setData:(int)count{
    _textForCount.text = [NSString stringWithFormat:@"%d",count];
    _MainLableView.layer.cornerRadius = 5;
    _MainLableView.layer.borderWidth = 0.5;
    _MainLableView.layer.borderColor = [[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
