//
//  SellDataCell.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-7.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "SellDataCell.h"

@implementation SellDataCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setData:(NSString *)namestr Plan:(int)plan Today:(int)today Month:(int)month Over:(NSString *)over isCommit:(bool)isCommit{
    _name.text = namestr;
    _planValue.text = [NSString stringWithFormat:@"%d",plan];
    _todayValue.text = [NSString stringWithFormat:@"%d",today];
    _monthValue.text = [NSString stringWithFormat:@"%d",month];
    _overValue.text = over;
    [_tagCommit setHidden:!isCommit];
    [self setBorder:_name];
    [self setBorder:_planValue];
    [self setBorder:_todayValue];
    [self setBorder:_monthValue];
    [self setBorder:_overValue];
}
-(void)setBorder:(UIView *)view{
    view.layer.borderWidth =0.5;
    view.layer.borderColor = [UIColor colorWithRed:0.557 green:0.557 blue:0.557 alpha:1].CGColor;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
