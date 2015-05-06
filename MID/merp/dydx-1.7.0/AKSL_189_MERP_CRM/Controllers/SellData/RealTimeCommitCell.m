//
//  RealTimeCommitCell.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-8.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "RealTimeCommitCell.h"
#import "AKUIGrayBackgroundView.h"

@implementation RealTimeCommitCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setData:(NSString *)username Row:(NSInteger)row headerImage:(NSString *)headerImageuil SetString:(NSString *)setstring valueForCommit:(NSInteger)commitvalue valueForSale:(NSString *)valueForSale{
    _username.text= username;
    _labelSetString.text = setstring;
    _lablevalue.text = valueForSale;
    _labelCommit.text = [NSString stringWithFormat:@"%d",commitvalue];
    _headerImage.imageUrl = nil;
    _headerImage.imageUrl =API_IMAGE_URL_GET2(headerImageuil);
    _lableSetRank.hidden =YES;
    if(row >= 1 && row<=3){
        [_lableSetRank setHidden:NO];
        _lableSetRank.text = [NSString stringWithFormat:@"NO.%d",row];
        switch (row) {
            case 1:
                _lableSetRank.backgroundColor =  [UIColor colorWithRed:1.000 green:0.451 blue:0.471 alpha:0.8];
                break;
            case 2:
                _lableSetRank.backgroundColor = [UIColor colorWithRed:0.278 green:0.169 blue:0.557 alpha:0.8];
                break;
            case 3:
                _lableSetRank.backgroundColor = [UIColor colorWithRed:0.478 green:0.863 blue:0.627 alpha:0.8];
                break;
        }}

    
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    self.selectedBackgroundView = [[AKUIGrayBackgroundView alloc]initWithFrame:self.frame];
    _lableSetRank.layer.cornerRadius = 27;
    _headerImage.layer.cornerRadius = 27;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
