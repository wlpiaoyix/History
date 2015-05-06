//
//  EntityManagerAddressBook.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-6.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityUser.h"

@interface EntityManagerAddressBook : NSObject
/**
 保存通信录
 */
-(EntityUser*) merge:(EntityUser*) entity;
/**
 新增通信录
 */
-(EntityUser*) persist:(EntityUser*) entity;
/**
 删除通信录
 */
-(bool) remove:(EntityUser*) entity;
/**
 得到当前通信录
 */
-(EntityUser*) findByName:(NSString*) userName;
/**
 得到当前通信录
 */
-(EntityUser*) findByPhone:(NSString*) phone;
/**
 查询出所有的记录
 */
-(NSMutableArray*) queryAllRecord;
@end
