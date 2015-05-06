//
//  LoginViewController.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-10-18.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WTReTextField.h"

@interface LoginViewController : BaseViewController<UIScrollViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewForMain;
@property (weak, nonatomic) IBOutlet WTReTextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

+(UINavigationController *)getMainNav;

@end
