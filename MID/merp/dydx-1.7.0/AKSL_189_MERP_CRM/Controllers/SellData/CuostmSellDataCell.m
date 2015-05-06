//
//  CuostmSellDataCell.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-8.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "CuostmSellDataCell.h"
#import "AKProgressView.h"
#import "AKUIGrayBackgroundView.h"

@implementation CuostmSellDataCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)setData:(NSString *)userName headerImage:(NSString *)headerimage SetString:(NSString *)set Row:(NSInteger)row ValueForJob:(CGFloat)value progress:(NSString *)progress{
    _labelSetString.text = set;
    _username.text = userName;
    _headerImage.imageUrl = nil;
    _headerImage.imageUrl = headerimage;
    _labelValueText.text = progress;
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
    valueForJob =value;
    if (valueForJob>1) {
        valueForJob=1;
    }
    AKProgressView *progressview = (AKProgressView *)[_progressView viewWithTag:2574];
    if(progressview){
      double value = [[NSNumber numberWithFloat:valueForJob]doubleValue];
      [progressview setProgress:value];
    }
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    self.selectedBackgroundView = [[AKUIGrayBackgroundView alloc]initWithFrame:self.frame];
    _lableSetRank.layer.cornerRadius = 27;
    _headerImage.layer.cornerRadius = 27;
    _progressView.backgroundColor = [UIColor clearColor];
    AKProgressView *progress = (AKProgressView *)[_progressView viewWithTag:2574];
    if (!progress) {
        progress = [[AKProgressView alloc]initWithFrame:CGRectMake(0, 0, _progressView.frame.size.width, _progressView.frame.size.height)];
        progress.tag = 2574;
        [_progressView addSubview:progress];
    }
    double value = [[NSNumber numberWithFloat:valueForJob]doubleValue];
    [progress setProgress:value];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
