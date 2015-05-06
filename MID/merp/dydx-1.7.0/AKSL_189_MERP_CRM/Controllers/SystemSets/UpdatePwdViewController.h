//
//  UpdatePwdViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-5-13.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface UpdatePwdViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *textOne;

@property (weak, nonatomic) IBOutlet UITextField *textTwo;
@property (weak, nonatomic) IBOutlet UITextField *textThree;
- (IBAction)back:(id)sender;
- (IBAction)updatePwd:(id)sender;

@end
