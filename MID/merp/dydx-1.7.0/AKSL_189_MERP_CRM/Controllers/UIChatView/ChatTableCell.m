//
//  ChatTableCell.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-13.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "ChatTableCell.h"
#import "EMAsyncImageView.h"

@implementation ChatTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setData:(NSString *)haderImage Content:(NSString *)content DateForMessage:(NSDate *)date{
    _labelForContent.text = content;
    _ImageForHader.imageUrl = nil;
    _ImageForHader.imageUrl = haderImage;
     _labelForDate.text = [date getFriendlyTime:YES];
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    _ImageForHader.layer.cornerRadius = 25;
    _ViewForTextContent.layer.cornerRadius = 5;
    _ViewForTextContent.layer.borderWidth = 0.5;
    _ViewForTextContent.layer.borderColor = [[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor];
    _labelForDate.layer.cornerRadius = 5;
    _labelForDate.layer.borderWidth = 0.5;
    _labelForDate.layer.borderColor = [[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.2]CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
