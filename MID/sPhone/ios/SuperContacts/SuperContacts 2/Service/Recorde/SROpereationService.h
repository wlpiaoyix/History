//
//  SROpereationService.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-13.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityCallRecord.h"
#import "EntityUser.h"
@interface SROpereationService : NSObject
-(EntityCallRecord*) persist:(EntityCallRecord*) record;
-(EntityCallRecord*) merge:(EntityCallRecord*) record;
-(bool) removes:(EntityCallRecord*) record;
/**
 params主要是匹配longPingYing shortPingYing userName  callPhoneNum
 */
-(NSArray*) queryByParams:(NSString*) params;
/**
 status:0 无当前记录对应的联系人 1 反之
 */
-(NSArray*) query:(NSString*) userName Phone:(NSString*) phone Status:(int) status;
@end
