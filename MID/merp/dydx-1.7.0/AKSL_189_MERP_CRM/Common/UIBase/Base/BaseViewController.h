//
//  BaseViewController.h
//  YLJOAIpad
//
//  Created by robin on 13-3-19.
//  Copyright (c) 2013年 robin. All rights reserved.
//

#import <UIKit/UIKit.h>  
#import "MBProgressHUD.h"  

@interface BaseViewController : UIViewController<MBProgressHUDDelegate>{
    UIActivityIndicatorView *myActivityIndicator;
    MBProgressHUD* myMBProgressHUD;  
}
- (void) topButtonClick:(id)sender;
- (void) showActivityIndicator;
- (void) hideActivityIndicator;
-(void)setKeyboardNotification;
-(void)setCornerRadiusAndBorder:(UIView*)view;
@end
 
