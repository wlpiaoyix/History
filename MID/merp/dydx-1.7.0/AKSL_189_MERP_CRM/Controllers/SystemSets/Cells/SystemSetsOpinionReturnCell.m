//
//  SystemSetsOpinionReturnCell.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-6.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "SystemSetsOpinionReturnCell.h"

@implementation SystemSetsOpinionReturnCell
+(id)init{
    SystemSetsOpinionReturnCell *ssc = [[[NSBundle mainBundle] loadNibNamed:@"SystemSetsOpinionReturnCell" owner:self options:nil] lastObject];
    ssc._view.backgroundColor = [UIColor colorWithRed:0.914 green:0.914 blue:0.914 alpha:1];
    ssc.textViewOpinion.layer.cornerRadius = 2;
    ssc.textViewOpinion.layer.masksToBounds = YES;
    ssc.textViewOpinion.layer.borderWidth = 1;
    ssc.textViewOpinion.layer.borderColor = [[UIColor colorWithRed:0.800 green:0.800 blue:0.800 alpha:1]CGColor];
    return ssc;
}
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

@end
