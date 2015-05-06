//
//  CuostmSellDataCell.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-8.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h" 

@interface CuostmSellDataCell : UITableViewCell{
    CGFloat valueForJob;
}

@property (weak, nonatomic) IBOutlet UILabel *lableSetRank;
@property (weak, nonatomic) IBOutlet EMAsyncImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *labelSetString;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *labelValueText;

-(void)setData:(NSString *)userName headerImage:(NSString *)headerimage SetString:(NSString *)set Row:(NSInteger)row ValueForJob:(CGFloat)value progress:(NSString *)progress;

@end
