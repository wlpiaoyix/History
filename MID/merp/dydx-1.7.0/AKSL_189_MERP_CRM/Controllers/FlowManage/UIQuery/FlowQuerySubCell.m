//
//  FlowQuerySubCell.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-2-25.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "FlowQuerySubCell.h"

@implementation FlowQuerySubCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setData:(NSDictionary *)dataDic{
    _textUserName.text = [dataDic valueForKey:@"userName"];
    _textPaymatCount.text = [NSString stringWithFormat:@"%ld",[[dataDic valueForKey:@"payment"]longValue]];
    _textLiuliangApp.text = [NSString stringWithFormat:@"%ld",[[dataDic valueForKey:@"trafficAppNum"]longValue]];
    _textLiuliangbao.text = [NSString stringWithFormat:@"%ld",[[dataDic valueForKey:@"trafficPackNum"]longValue]];
    _textShouriJihuo.text = [NSString stringWithFormat:@"%ld",[[dataDic valueForKey:@"firstDayActiveNum"]longValue]];
    
 _textDate.text = [[[dataDic valueForKey:@"reportTime"]substringFromIndex:5]substringToIndex:11];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
