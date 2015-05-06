//
//  UICheckBox.h
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-2-20.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModleCheckBox.h"

@interface UICheckBox : UIView
+(id) getNewInstance;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
-(void) setCheckText:(NSString*) text;
-(bool) isSelected;
-(void) setSelected:(bool) flag;
-(void) setButtonTargetHidden:(bool) flag;
-(CGSize)setModleCheckBox:(ModleCheckBox*) model;

@end
