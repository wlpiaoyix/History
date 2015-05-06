//
//  NotesLeaderShipViewCell.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-26.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"
@interface NotesLeaderShipViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet EMAsyncImageView *imageHead;
@property (retain, nonatomic) IBOutlet UILabel *lableUserName;
@property (retain, nonatomic) IBOutlet UILabel *lableAdress;
@property (retain, nonatomic) IBOutlet UILabel *lableDate;
@property (retain, nonatomic) IBOutlet UILabel *lableNotesShopName;
//@property NSString *valueImageHead;
//@property NSString *valueLableUserName;
//@property NSString *valueLableAdress;
//@property NSString *valueLableNotesShopName;

@end
