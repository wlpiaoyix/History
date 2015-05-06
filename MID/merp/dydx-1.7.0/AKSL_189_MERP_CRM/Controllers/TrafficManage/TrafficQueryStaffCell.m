//
//  TrafficQueryStaffCell.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-4-29.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "TrafficQueryStaffCell.h"

@implementation TrafficQueryStaffCell

- (void)awakeFromNib
{
    // Initialization code
}

-(void)setData:(NSString *)userName AppCount:(int)app PackCount:(int)pack UseCount:(int)use NumForSell:(double)sell{
    _textUserName.text = userName;
    
    _textAppCount.text= [NSString stringWithFormat:@"%d",app];
    _textPackCount.text = [NSString stringWithFormat:@"%d",pack];
    _textUseCount.text =[NSString stringWithFormat:@"%d",use];
    _textPayment.text = [NSString stringWithFormat:@"%0.2f",sell];
    NSString * imageUrl =use==0?@"flowmanage_type131.png":@"flowmanage_type13.png";
    [_image01 setImage:[UIImage imageNamed:imageUrl]];
    imageUrl = app==0?@"flowmanage_type02.png":@"flowmanage_type11.png";
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
