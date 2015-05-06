//
//  RegistUserController.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-17.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface RegistUserController : BaseViewController
+(id) getNewInstance;
-(void) setModelUser:(ModleUser*) user;
@end
