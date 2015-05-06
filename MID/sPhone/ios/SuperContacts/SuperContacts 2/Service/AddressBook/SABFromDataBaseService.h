//
//  SABFromDataBaseService.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-7.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityUser.h"
#import "EntityCallRecord.h"

@interface SABFromDataBaseService : NSObject
-(NSArray*) queryEntityUserByPhone:(NSString*) phone;
-(NSArray*) queryEntityUserByName:(NSString *)name;
-(NSArray*) queryEntityUserByParams:(NSString*) params IfChekNum:(bool) ifCheckNum;
-(NSArray*) queryEntityCallRecordByPhone:(NSString*) phone;
-(NSArray*) queryEntityCallRecordByName:(NSString *)name;
/**
 params主要是匹配longPingYing shortPingYing userName  callPhoneNum
 */
-(NSArray*) queryRecordByParams:(NSString*) params;
-(EntityUser*) persistEntityUser:(EntityUser*) user;
-(EntityCallRecord*) persistEntityCallRecord:(EntityCallRecord*) record;
-(EntityUser*) mergeEntityUser:(EntityUser*) user;
-(EntityCallRecord*) mergeEntityCallRecord:(EntityCallRecord*) record;
-(EntityUser*) findEntityUser:(int) userId;
-(EntityUser*) findEntityCallRecord:(int) recordeId;
-(bool) removeEntityUser:(EntityUser*) user;
-(bool) removeEntityCallRecord:(EntityCallRecord*) record;
-(bool) removeAllEntityUser;

@end
