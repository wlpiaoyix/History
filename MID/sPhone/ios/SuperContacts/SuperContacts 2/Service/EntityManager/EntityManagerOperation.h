//
//  EntityManagerOperation.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-2.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityInterface.h"
#import <sqlite3.h>
typedef NSString* (^excueM1)(id target);
typedef id (^excueM2)(sqlite3_stmt *statement);
@protocol EntityManagerImpProtocol
-(id<EntityInterface>) merge:(id<EntityInterface>) entity;
-(id<EntityInterface>) persist:(id<EntityInterface>) entity;
-(bool) remove:(int) entityId;
-(id<EntityInterface>) find:(int) entityId;
@end
@interface EntityManagerOperation : NSObject
@property (strong, nonatomic) NSString *databasePath;//数据库物理地址
@property sqlite3 *database;//当前数据库对象
@property id target;//目标实体
/**
 初始化数据库
 */
-(id) initDataBaseName:(NSString*) dataBaseName;
/**
 打开数据库
 */
-(bool) openDataBase;
/**
 保存实体
 */
-(id<EntityInterface>) merge:(id<EntityInterface>) entity;
/**
 新增实体
 */
-(id<EntityInterface>) persist:(id<EntityInterface>) entity;
/**
 删除实体
*/
-(bool) remove:(id<EntityInterface>) entity;
/**
 删除实体
 */
-(bool) removeById:(Class) clazz EntityId:(int) entityId;
/**
 得到当前实体
 */
-(id<EntityInterface>) find:(Class) clazz EntityId:(int) entityId;
/**
 执行特殊sql
 excuCallBackGetSql;//通用查询执行块
 excuCallBackBindValue;//通用查询执行块
 excuCallBackSetValue;//通用查询执行块
 */
-(id) excueSpecialTarget:(excueM1) excuCallBackGetSql ExcuCallBackBindValue:(excueM2)excuCallBackBindValue ExcuCallBackSetValue:(excueM2)excuCallBackSetValue;
/**
 创建数据表
 */
-(bool) checkEntityCreate;
+(char*) createEntitySql:(Class) clazz;
+(char*) insertEntitysql:(Class) clazz;
+(char*) updateEntitySql:(Class) clazz;
+(char*) deleteEntitySql:(Class) clazz;
+(char*) getEntitySql:(Class) clazz;
@end
