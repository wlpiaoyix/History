//
//  ManagerInspectListCell.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-10-31.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"
@interface ManagerInspectListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *DateTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *DateMTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *setTextLabel;
@property (weak, nonatomic) IBOutlet EMAsyncImageView *imagePhones;

-(void)setData:(NSDate*)date DateFlag:(bool) dateFlag ShopName:(NSString *)shopname Set:(NSString *)settext;

@end
