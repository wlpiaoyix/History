//
//  CollectDataCell.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-7.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "CollectDataCell.h"

@implementation CollectDataCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setData:(NSString *)namestr Value:(int)valueforcollect{
    _name.text = namestr;
    _value.text = [NSString stringWithFormat:@"%d",valueforcollect];
    [self setBorder:_name];
    [self setBorder:_value];
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
