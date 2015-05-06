//
//  UIFlowYestodayCell.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-3-10.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "UIFlowYestodayCell.h"

@implementation UIFlowYestodayCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setData:(NSDictionary *)dataDic{
  _lablePhone.text  = [dataDic valueForKey:@"phoneNum"];
  _lableDate.text = [[[dataDic valueForKey:@"reportTime"]substringFromIndex:10]substringToIndex:6];
    NSDictionary * temp = [dataDic valueForKey:@"trafficPack"];
    [self setImageAndPaymentToView:_image01 Label:_textPayment01 Payment:[[temp valueForKey:@"trafficPackPayment"] doubleValue] Stats:[[temp valueForKey:@"dealStatus"] intValue]];
    temp = [dataDic valueForKey:@"trafficApp"];
    [self setImageAndPaymentToView:_image02 Label:_textPayment02 Payment:[[temp valueForKey:@"trafficAppPayment"] doubleValue] Stats:[[temp valueForKey:@"dealStatus"] intValue]];
    temp = [dataDic valueForKey:@"active"];
    [self setImageAndPaymentToView:_image03 Label:_textPayment03 Payment:[[temp valueForKey:@"activePayment"] doubleValue] Stats:[[temp valueForKey:@"dealStatus"] intValue]];
}
-(void)setImageAndPaymentToView:(UIImageView *)view Label:(UILabel *)label Payment:(double)payment Stats:(int)stats{
    [view setHidden:NO];
    [label setHidden:NO];
    [label setText:[NSString stringWithFormat:@"%.1f",payment]];
    switch (stats) {
        case 1:
            [view setImage:[UIImage imageNamed:[[@"flowmanage_type" stringByAppendingString:[NSString stringWithFormat:@"%d",view.tag]]stringByAppendingString:@".png"]]];
            break;
        case 3:
           [view setImage:[UIImage imageNamed:[[@"flowmanage_type" stringByAppendingString:[NSString stringWithFormat:@"%d",(view.tag*10+1)]]stringByAppendingString:@".png"]]];
            break;
        case 2:
         [view setImage:[UIImage imageNamed:[[@"flowmanage_type" stringByAppendingString:[NSString stringWithFormat:@"%d",(view.tag*10+2)]]stringByAppendingString:@".png"]]];
            break;
        default:
            [view setHidden:YES];
            [label setHidden:YES];
            break;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
