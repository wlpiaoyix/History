//
//  TrafficSummaryCell.m
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-5-19.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "TrafficSummaryCell.h"

@implementation TrafficSummaryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setData:(NSString *)setString Pnum:(int)pnum Pack:(int)pack App:(int)app Useage:(int)useage Payment:(double)payment{
    
    _viewMain.layer.borderWidth = 0.5;
    _viewMain.layer.borderColor = [[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor];
    __lblApp.text = [NSString stringWithFormat:@"%d",app];
    __lblPack.text = [NSString stringWithFormat:@"%d",pack];
    __lblPnum.text = [NSString stringWithFormat:@"%d",pnum];
    __lblUsage.text = [NSString stringWithFormat:@"%d",useage];
    __lblPayment.text= [NSString stringWithFormat:@"%.2f",payment];
    _lbSetString.text = setString;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
