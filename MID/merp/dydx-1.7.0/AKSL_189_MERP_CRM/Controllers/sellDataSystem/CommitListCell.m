//
//  CommitListCell.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-8.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "CommitListCell.h"

@implementation CommitListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setData:(NSString *)name Value:(int)value{
    _name.text = name;
    _NumberForCommit.text = [NSString stringWithFormat:@"%d",value];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
