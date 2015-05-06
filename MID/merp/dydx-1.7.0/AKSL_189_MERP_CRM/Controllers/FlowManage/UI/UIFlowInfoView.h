//
//  UIFlowInfoView.h
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-2-23.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFlowInfoView : UIView<UITableViewDataSource,UITableViewDelegate>
+(id) getNewInstance;
-(void) setController:(UIViewController*) vc;
-(void) reloadAllData;

@end
