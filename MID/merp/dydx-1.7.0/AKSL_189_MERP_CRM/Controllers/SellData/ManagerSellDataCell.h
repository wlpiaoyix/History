//
//  ManagerSellDataCell.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-7.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"

@interface ManagerSellDataCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelUserOverJob;
@property (weak, nonatomic) IBOutlet UILabel *labelUserplam;
@property (weak, nonatomic) IBOutlet UILabel *labelForMyselfRank;
@property (weak, nonatomic) IBOutlet EMAsyncImageView *headerImages;
@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@property (weak, nonatomic) IBOutlet UILabel *lableUserSaleForJob;
@property (weak, nonatomic) IBOutlet UILabel *labelUserSet;
@property (weak, nonatomic) IBOutlet UILabel *labelForRankSet;

-(void)setData:(NSString *)userName Loaction:(NSString *)loaction Row:(NSInteger)row HeaderImages:(NSString *)headerImages JobPlam:(NSString *)plam OverJob:(NSString *)overjob saleForJob:(NSString *)saleForJob;
@end
