//
//  CustomerBirthdayDetailTableViewCell.h
//  FDC
//
//  Created by NewDoone on 15/1/22.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerBirthdayDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *payStatus;
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;

@property (nonatomic,strong) NSString* phoneNumber;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn_stars;
@property (nonatomic,assign) NSUInteger starsCount;
@end
