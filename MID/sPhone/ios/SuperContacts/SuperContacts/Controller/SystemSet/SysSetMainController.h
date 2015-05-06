//
//  SysSetMainController.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-1.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PopUpDialogView.h"
@interface SysSetMainController : BaseViewController<PopUpDialogViewDelegate>
+(id) getSingleInstance;
@end
