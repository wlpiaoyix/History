//
//  TrafficQueryCell.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-4-28.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "TrafficQueryCell.h"

@implementation TrafficQueryCell

- (void)awakeFromNib
{
    // Initialization code
}
-(void)setData:(NSString *)phoneNum Date:(NSDate *)date AppCount:(int)app PackCount:(int)pack NumForSell:(double)sell{
    _textPhoneNum.text = phoneNum;
    _textTime.text = [date getFriendlyTime2];
    _textAppCount.text= [NSString stringWithFormat:@"%d",app];
    _textPackCount.text = [NSString stringWithFormat:@"%d",pack];
    _textPayment.text = [NSString stringWithFormat:@"%0.2f",sell];
    NSString * imageUrl = app==0?@"flowmanage_type02.png":@"flowmanage_type11.png";
    [_image02 setImage:[UIImage imageNamed:imageUrl]];
    imageUrl = pack==0?@"flowmanage_type01.png":@"flowmanage_type10.png";
    [_image03 setImage:[UIImage imageNamed:imageUrl]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
