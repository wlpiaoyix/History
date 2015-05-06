//
//  SystemSetsCell.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-1.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"
@interface SystemSetsCell : UITableViewCell
+(id)initWithText:(NSString*) text;
//@property (retain, nonatomic) IBOutlet EMAsyncImageView *imageTitle;
@property (retain, nonatomic) IBOutlet UILabel *lableSets;
@property (retain, nonatomic) IBOutlet UIButton *buttonSets;
@end
