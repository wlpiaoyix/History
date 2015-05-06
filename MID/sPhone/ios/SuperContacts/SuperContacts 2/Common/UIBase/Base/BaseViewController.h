//
//  BaseViewController.h
//  YLJOAIpad
//
//  Created by robin on 13-3-19.
//  Copyright (c) 2013年 robin. All rights reserved.
//

#import <UIKit/UIKit.h>  
#import "MBProgressHUD.h"
typedef enum{
    ENUM_BVCLEFT = 0,
    ENUM_BVCRIGTH = 1
} ENUM_BVC;
@interface BaseViewController : UIViewController<MBProgressHUDDelegate>{
    UIActivityIndicatorView *myActivityIndicator;
    MBProgressHUD* myMBProgressHUD;
    @protected id target;
    @protected SEL  methodIntputshow;
    @protected SEL  methodIntputhidden;
}
/**
 显示等待框
 */
- (void) showActivityIndicator;
- (void) showActivityIndicator:(NSString*) msg;
/**
 隐藏等待框
 */
- (void) hideActivityIndicator;
- (void) setKeyboardNotification;
- (void) setCornerRadiusAndBorder:(UIView*)view;
-(void)setCornerRadiusAndBorder:(UIView *)view CornerRadius:(float) cornerRadius;
- (void) setCornerRadiusAndBorder:(UIView *)view CornerRadius:(float) cornerRadius BorderWidth:(float) borderWidth BorderColor:(CGColorRef) borderColor;
- (void) topLeftOrRight:(ENUM_BVC) bvc;
@end
 
