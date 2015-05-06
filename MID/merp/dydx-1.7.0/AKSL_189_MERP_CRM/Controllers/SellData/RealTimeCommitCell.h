//
//  RealTimeCommitCell.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-8.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"

@interface RealTimeCommitCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lableSetRank;
@property (weak, nonatomic) IBOutlet EMAsyncImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *labelSetString;
@property (weak, nonatomic) IBOutlet UILabel *labelCommit;
@property (weak, nonatomic) IBOutlet UILabel *lablevalue;

-(void)setData:(NSString *)username Row:(NSInteger)row headerImage:(NSString *)headerImageuil SetString:(NSString*)setstring valueForCommit:(NSInteger)commitvalue valueForSale:(NSString *)valueForSale;
@end
