//
//  FlowInfoAppCell.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-2-25.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "FlowInfoAppCell.h"

@implementation FlowInfoAppCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setData:(NSString *)name Number:(NSNumber *)num{
    _textName.text = name;
    _textNum.text = [num stringValue];//[NSString stringWithFormat:@"%ld",num];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
