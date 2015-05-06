//
//  SingleDateScheduleCell.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-1.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "SingleDateScheduleCell.h"

@implementation SingleDateScheduleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
 //_timeLabel.text = @"10:10";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
