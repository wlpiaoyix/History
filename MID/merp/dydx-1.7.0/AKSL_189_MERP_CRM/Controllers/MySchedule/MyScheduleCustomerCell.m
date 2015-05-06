//
//  MyScheduleCustomerCell.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-10.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "MyScheduleCustomerCell.h"

@implementation MyScheduleCustomerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) willMoveToSuperview:(UIView *)newSuperview{
    self.imageHead.layer.masksToBounds = YES;
    self.imageHead.layer.cornerRadius = self.imageHead.frame.size.height/2;
}

@end
