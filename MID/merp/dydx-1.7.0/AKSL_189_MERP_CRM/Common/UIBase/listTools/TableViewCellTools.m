//
//  TableViewCellTools.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-10-25.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "TableViewCellTools.h"

@implementation TableViewCellTools
+(id)init{
    TableViewCellTools *tvct = [[[NSBundle mainBundle] loadNibNamed:@"TableViewCellTools" owner:self options:nil] lastObject];
    return tvct;
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
}

@end
