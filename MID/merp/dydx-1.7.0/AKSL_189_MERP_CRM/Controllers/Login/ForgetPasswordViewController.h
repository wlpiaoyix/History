//
//  ForgetPasswordViewController.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-10-20.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *inputText;
- (IBAction)toServer:(id)sender;

@end
