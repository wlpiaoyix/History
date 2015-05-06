//
//  UIPersonalFlowManagerView2.h
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-2-23.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPersonalFlowManagerView2 : UIView<UITableViewDataSource,UITableViewDelegate>
-(void) setController:(UIViewController*) vc;
+(id) getNewInstance;

@end
