//
//  SelectCell.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-Apple on 14/6/25.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchSelected.h"

@interface SelectCell : UITableViewCell
@property (weak,nonatomic) IBOutlet UIButton * mainButton;
@property (weak,nonatomic) IBOutlet UILabel * textForName;

-(void)setData:(SwitchSelected *)obj;
@end
