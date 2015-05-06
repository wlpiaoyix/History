//
//  CTM_ViewContentControllerViewController.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-21.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityUser.h"
#import "BaseViewController.h"
@interface CTM_ViewContentControllerViewController : BaseViewController
+(id) getSingleInstance;
@property (strong, nonatomic) EntityUser *entityUser;
@end
