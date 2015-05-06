//
//  ManagerSellDataCell.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-7.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "ManagerSellDataCell.h"
#import "AKUIGrayBackgroundView.h"
@implementation ManagerSellDataCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setData:(NSString *)userName Loaction:(NSString *)loaction Row:(NSInteger)row HeaderImages:(NSString *)headerImages JobPlam:(NSString *)plam OverJob:(NSString *)overjob saleForJob:(NSString *)saleForJob{
    _labelUsername.text = userName;
    _labelUserSet.text= loaction;
    _headerImages.imageUrl = nil;
    _headerImages.imageUrl = headerImages;
    _labelUserplam.text = plam;
    _lableUserSaleForJob.text = saleForJob;
    _labelUserOverJob.text = overjob;
    _labelForMyselfRank.hidden = YES;
    _labelForRankSet.hidden = YES;
    if (row<=0) {
        [_labelForMyselfRank setHidden:NO];
        _labelForMyselfRank.text = [NSString stringWithFormat:@"%d",row*-1];
    }
    if(row >= 1 && row<=3){
        [_labelForRankSet setHidden:NO];
        _labelForRankSet.text = [NSString stringWithFormat:@"NO.%d",row];
        switch (row) {
            case 1:
                _labelForRankSet.backgroundColor =  [UIColor colorWithRed:1.000 green:0.451 blue:0.471 alpha:0.8];
                break;
            case 2:
                 _labelForRankSet.backgroundColor = [UIColor colorWithRed:0.278 green:0.169 blue:0.557 alpha:0.8];
                break;
            case 3:
                _labelForRankSet.backgroundColor = [UIColor colorWithRed:0.478 green:0.863 blue:0.627 alpha:0.8];
                break;
        }
        
      
       // _labelForRankSet.backgroundColor =
    }
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    self.selectedBackgroundView = [[AKUIGrayBackgroundView alloc]initWithFrame:self.frame];
    _headerImages.layer.cornerRadius = 27;
    _labelForRankSet.layer.cornerRadius = 27;
    _labelForMyselfRank.layer.cornerRadius = 10;
    _labelForMyselfRank.layer.borderColor = [UIColor colorWithRed:0.000 green:0.969 blue:0.502 alpha:1].CGColor;
    _labelForMyselfRank.layer.borderWidth = 1;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
