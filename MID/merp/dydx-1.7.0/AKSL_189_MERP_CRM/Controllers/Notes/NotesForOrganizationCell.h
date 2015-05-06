//
//  NotesForOrganizationCell.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-25.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"
@interface NotesForOrganizationCell : UITableViewCell
@property (retain, nonatomic) IBOutlet EMAsyncImageView *imageOrgPic;
@property (retain, nonatomic) IBOutlet UILabel *lableOrgName;

@end
