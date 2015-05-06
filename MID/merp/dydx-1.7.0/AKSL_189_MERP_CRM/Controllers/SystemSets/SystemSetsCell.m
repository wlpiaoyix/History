//
//  SystemSetsCell.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-1.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "SystemSetsCell.h"

@implementation SystemSetsCell

+(id)init{
    SystemSetsCell *ssc = [[[NSBundle mainBundle] loadNibNamed:@"SystemSetsCell" owner:self options:nil] lastObject];
    return ssc;
}
+(id)initWithText:(NSString*) text{
    SystemSetsCell *ssc = [SystemSetsCell init];
    ssc.lableSets.text = text;
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

- (IBAction)clickbuttionSets:(id)sender {
}
@end
