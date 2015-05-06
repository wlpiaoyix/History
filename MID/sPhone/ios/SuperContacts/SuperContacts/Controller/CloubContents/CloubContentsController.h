//
//  CloubContentsController.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-5.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "BaseViewController.h"
#import "PopUpDialogView.h"
@interface CloubContentsController : BaseViewController<NSURLConnectionDelegate,PopUpDialogViewDelegate>
+(id) getNewleInstance;

@end
