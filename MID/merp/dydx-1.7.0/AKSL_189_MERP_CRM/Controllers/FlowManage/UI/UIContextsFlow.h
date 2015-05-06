//
//  UIContextsFlow.h
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-2-21.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIContextsFlow : UIView
+(id) getNewInstance;
- (void)addEventTouchUp:(id)target action:(SEL)action;
-(void) setDatas:(NSArray*) datas;
-(void) setButtonTargetHidden:(bool) flag;
-(void) setButtonTargetSelect:(bool) flag;
-(void) excuViewThread;
-(CGSize) excuView;
@end
