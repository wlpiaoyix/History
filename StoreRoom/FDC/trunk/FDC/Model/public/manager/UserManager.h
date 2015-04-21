//
//  UserManager.h
//  FDC
//
//  Created by wlpiaoyi on 15/1/16.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "FDCBaseManger.h"

@interface UserManager : FDCBaseManger
-(void) loginWithUserName:(NSString*) userName password:(NSString*) password success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;

@end
