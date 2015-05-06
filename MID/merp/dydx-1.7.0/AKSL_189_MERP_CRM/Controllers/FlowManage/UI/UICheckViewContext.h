//
//  UICheckViewContext.h
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-2-21.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModleCheckType.h"

@interface UICheckViewContext : UIView
+(id) getNewInstance;
- (void)addEventTouchUp:(id)target action:(SEL)action;
-(void) setDatas:(ModleCheckType*) type;
-(void) setButtonTargetHidden:(bool) flag;
-(void) excuViewThread;
-(CGSize) excuView;
@end
