//
//  SystemSetsPasswordEditCell.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-5.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "SystemSetsPasswordEditCell.h"
@implementation SystemSetsPasswordEditCell
+(id)init{
    SystemSetsPasswordEditCell *ssc = [[[NSBundle mainBundle] loadNibNamed:@"SystemSetsPasswordEditCell" owner:self options:nil] lastObject];
    ssc.buttonPassword.layer.cornerRadius = 2;
    ssc.buttonPassword.layer.masksToBounds = YES;
    ssc.buttonPassword.layer.borderWidth = 1;
    ssc.buttonPassword.layer.borderColor = [[UIColor colorWithRed:0.580 green:0.784 blue:0.200 alpha:1]CGColor];
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
