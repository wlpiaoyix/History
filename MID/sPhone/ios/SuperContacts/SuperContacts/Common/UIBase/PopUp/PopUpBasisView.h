//
//  PopUpBasisView.h
//  DXAlertView
//
//  Created by wlpiaoyi on 14-4-9.
//  Copyright (c) 2014年 xiekw. All rights reserved.
// 

#import <Foundation/Foundation.h>

@interface PopUpBasisView : UIView
+(PopUpBasisView*) initWithTargetView:(UIView*) targetView;
-(void) initParam;
-(void) setHasCloseButton:(bool) hasCloseButton;
-(void) setAfterCloseBolock:(dispatch_block_t) afterCloseBolock;
-(void) close;
- (void)show;
@end
@interface UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color;

@end
