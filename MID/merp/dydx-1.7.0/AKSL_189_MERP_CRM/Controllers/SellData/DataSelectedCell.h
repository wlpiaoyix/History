//
//  DataSelectedCell.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-27.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataSelectedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *selectedSwitch;
@property (weak, nonatomic) IBOutlet UILabel *lableForName;

@end
