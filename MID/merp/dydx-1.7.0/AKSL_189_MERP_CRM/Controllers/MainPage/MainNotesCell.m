//
//  MainNotesCell.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-10-30.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "MainNotesCell.h"
#import "UIView+convenience.h"

@implementation MainNotesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}
-(void)setData:(NSString *)content Type:(NSInteger)celltype Time:(NSDate *)date{
    _Content.text = content;
    if (celltype) {
        _TimeText.hidden = NO;
        _ImageToNotes.hidden = YES;
    }else{
        _TimeText.hidden = YES;
        _ImageToNotes.hidden = NO;
    }
    _TimeText.text = [NSDate dateFormateDate:date FormatePattern:@"HH:mm"];
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    _TimeText.layer.cornerRadius  = 17;
    [_mainview setCornerRadiusAndBorder:5 BorderWidth:0.5 BorderColor:[UIColor colorWithRed:0.557 green:0.557 blue:0.557 alpha:1]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
