//
//  DetailedSellInfoViewController.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-9.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface DetailedSellInfoViewController : BaseViewController
- (IBAction)goBack:(id)sender;
@property (copy,nonatomic) NSString *userCode;
@end
