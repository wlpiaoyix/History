//
//  TrafficTodayReportCell.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-4-21.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "TrafficTodayReportCell.h"

@implementation TrafficTodayReportCell

- (void)awakeFromNib
{
    // Initialization code
}

-(void)setData:(NSString *)phoneNum Date:(NSDate *)date{
    _textForPhoneNum.text = phoneNum;
    _textForTime.text = [NSDate dateFormateDate:date FormatePattern:@"HH:mm"];
    _imageForIconMeony.hidden = YES;
    _imageForIconType.hidden = YES;
    _textForTotal.hidden =YES;
    _textForNum.hidden = YES;
    
}
-(void)setData:(NSString *)phoneNum Type:(int)type Date:(NSDate *)date NumForTotal:(int)total NumForSell:(double)sell{
    _textForPhoneNum.text = phoneNum;
    _textForTime.text = [date getFriendlyTime2];
    _textForNum.text= [NSString stringWithFormat:@"%d",total];
    _textForTotal.text = [NSString stringWithFormat:@"%0.2f",sell];
    
    [_imageForIconType setImage:[UIImage imageNamed:[NSString stringWithFormat:@"flowmanage_type%d.png",type]]];
    if (type==13) {
        _imageForIconType.hidden = YES;
        _textForNum.hidden = YES;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
