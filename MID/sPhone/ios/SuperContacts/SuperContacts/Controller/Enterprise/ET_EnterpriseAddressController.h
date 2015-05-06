//
//  ET_EnterpriseAddressController.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-12.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ET_EnterpriseAddressController : BaseViewController
+(id) getNewInstance;
-(void) setData:(NSString*) enterpriseNamex EnterpriseAddress:(NSString*) enterpriseAddressx EnterprisePhone:(NSString*) enterprisePhonex Point:(CGPoint) pointx;

@end
