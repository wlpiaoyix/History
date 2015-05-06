//
//  FlowInfoSetCell.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-2-25.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "FlowInfoSetCell.h"

@implementation FlowInfoSetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setData:(NSDictionary *)dataDic isShowNum:(BOOL)isshownum{
   NSString * labetype= [dataDic valueForKey:@"trafficPackTypeName"];
    _textType.text = @"";
    CGRect   frame = _lineshow.frame;
    if (labetype && labetype.length > 0) {
        _textType.text = labetype;
        frame.origin.x = 0;
    }else{
    _textType.text = @"";
        frame.origin.x = 112;
    }
    _lineshow.frame = frame;
    _textName.text = [dataDic valueForKey:@"itemName"];
    if (isshownum) {
        _textNum.text = [NSString stringWithFormat:@"%ld",[[dataDic valueForKey:@"count"] longValue]];
    }else{
     _textNum.text = [NSString stringWithFormat:@"%.1f",[[dataDic valueForKey:@"payment"] doubleValue]];
    }
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
