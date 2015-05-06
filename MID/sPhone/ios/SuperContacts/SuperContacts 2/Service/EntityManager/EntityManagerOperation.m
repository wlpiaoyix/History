//
//  EntityManagerOperation.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-2.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "EntityManagerOperation.h"
#import "EntityUser.h"
#import "EntityCallRecord.h"
#import "EntityPhone.h"
static const NSString *DBCHECK_SUFFIX = @".sqlite3";
static NSArray *EMOP_enityArray;
@interface EntityManagerOperation()
@property bool ifOpenDataBase;
@property id synflag;
@end
@implementation EntityManagerOperation
+(void) initialize{
    EMOP_enityArray = [[NSArray alloc] initWithObjects:[EntityPhone class], nil];
}
//<==db method
-(id) initDataBaseName:(NSString*) dataBaseName{
    NSString *cachesPath =
    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    __strong NSString *suffix = [DBCHECK_SUFFIX copy];
    NSFileManager *fileManager = [NSFileManager defaultManager] ;
    if(![fileManager fileExistsAtPath:cachesPath]){
        return nil;
    }
    NSString * realPath = [[cachesPath stringByAppendingPathComponent:dataBaseName]
                           stringByAppendingString:suffix];
    // Check if the database has already been created in the users filesystem
    bool success = [fileManager fileExistsAtPath:realPath];
    if (!success) NSLog(@"has no database at [ %@] \n",realPath);
    self = [self init];
    if (self) {
        _databasePath = realPath;
    }
    return self;
}
-(bool) openDataBase
{
    @synchronized(_synflag){
        if(_ifOpenDataBase){
            return true;
        }
        _ifOpenDataBase = true;
    }
    int status = sqlite3_open([_databasePath UTF8String],&_database);
    switch (status) {
        case SQLITE_OK:
        {
            printf("open the database successfully\n");
            return YES;
        }
            break;
        default:
        {
            sqlite3_close(_database);
            @synchronized(_synflag){
                _ifOpenDataBase = false;;
            }
            printf("failed to open the database\n");
            return NO;
        }
            break;
    }
}
//==>db method


//==>opt method
-(id<EntityInterface>) merge:(id<EntityInterface>) entity{
    if([entity getEntityId]==0){
        return [self persist:entity];
    }else{
        if([entity class]==[EntityUser class]){
            return [self updateEntityUser:entity];
        }else if([entity class]==[EntityCallRecord class]){
            return [self updateEntityCallRecord:entity];
        }else if([entity isKindOfClass:[EntityPhone class]]){
            return [self updateEntityPhone:entity];
        }
    }
    return nil;
}
-(id<EntityInterface>) persist:(id<EntityInterface>) entity{
    if([entity class]==[EntityUser class]){
        return [self persistEntityUser:entity];
    }else if([entity class]==[EntityCallRecord class]){
        return [self persistEntityCallRecord:entity];
    }else if([entity isKindOfClass:[EntityPhone class]]){
        return [self persistEntityPhone:entity];
    }
    return nil;
}
-(bool) remove:(id<EntityInterface>) entity{
    return [self removeById:[entity class] EntityId:[entity getEntityId]];
}
-(bool) removeEntityPhoneByUserId:(int) userId{
    sqlite3_stmt *statement = NULL;
    if ([self openDataBase]==NO)return false;
    char* deleteSql = "DELETE FROM EntityPhone WHERE entityUserId=?";
    int excuStatus = sqlite3_prepare_v2(self.database,deleteSql,-1,&statement,NULL);
    if (excuStatus==SQLITE_ERROR)return false;
    if (excuStatus!= SQLITE_OK)
    {
        printf("Error:Failed to delete entity\n");
        return NO;
    }else{
        sqlite3_bind_int(statement,1,userId);
        int success=sqlite3_step(statement);
        sqlite3_finalize(statement);
        if(success==SQLITE_ERROR)
        {
            printf("Error:fail to delete into the database with message\n");
            sqlite3_close(_database);
            @synchronized(_synflag){
                _ifOpenDataBase = false;;
            }
            return NO;
        }
        printf("delete one Entity\n");
        return YES;
    }
    return false;
}
-(bool) removeById:(Class) clazz EntityId:(int) entityId{
    sqlite3_stmt *statement = NULL;
    if ([self openDataBase]==NO)return false;
    char* deleteSql = [EntityManagerOperation deleteEntitySql:clazz];
    int excuStatus = sqlite3_prepare_v2(self.database,deleteSql,-1,&statement,NULL);
    if (excuStatus==SQLITE_ERROR)return false;
    if (excuStatus!= SQLITE_OK)
    {
        printf("Error:Failed to delete entity\n");
        return NO;
    }else{
        sqlite3_bind_int(statement,1,entityId);
        int success=sqlite3_step(statement);
        sqlite3_finalize(statement);
        if(success==SQLITE_ERROR)
        {
            printf("Error:fail to delete into the database with message\n");
            sqlite3_close(_database);
            @synchronized(_synflag){
                _ifOpenDataBase = false;;
            }
            return NO;
        }
        printf("delete one Entity\n");
        return YES;
    }
    return false;
}
-(id<EntityInterface>) find:(Class) clazz EntityId:(int) entityId{
    if(clazz==[EntityUser class]){
        return [self getEntityUser:entityId];
    }else if(clazz==[EntityCallRecord class]){
        return [self getEntityCallRecord:entityId];
    }else if(clazz==[EntityPhone class]){
        return [self getEntityPhone:entityId];
    }
    return nil;
}
-(bool) checkEntityCreate{
    char* createSql = [EntityUser getCreateSql];
    if ([self excuSQL:createSql]==YES)
    {
        printf("EntityUser was checked \n");
    }else{
        return false;
    }
    createSql = [EntityManagerOperation createEntitySql:[EntityCallRecord class]];
    if ([self excuSQL:createSql]==YES)
    {
        printf("EntityCallRecord was checked \n");
    }else{
        return false;
    }
    createSql = [EntityPhone getCreateSql];
    if ([self excuSQL:createSql]==YES)
    {
        printf("EntityPhone was checked \n");
    }else{
        return false;
    }
    return true;
}




-(bool) excuSQL:(char*) sql
{
    if ([self openDataBase]==NO)return NO;
    char *erroMsg;
    if (sqlite3_exec(self.database, sql, NULL, NULL, &erroMsg)!= SQLITE_OK)
    {
        sqlite3_close(self.database);
        printf("excue sql faild [%s]\n",erroMsg);
        return NO;
    }
    else
    {
        printf("excue sql success\n");
        return YES;
    }
}
-(EntityUser*) persistEntityUser:(EntityUser*) entity{
    char* insertSql = [EntityManagerOperation insertEntitysql:[entity class]];
    sqlite3_stmt *statement;
    if ([self openDataBase]==NO)return nil;
    
    const char ** erroMsg = NULL;
    int excuStatus = sqlite3_prepare_v2(_database,insertSql,-1,&statement,erroMsg);
    if (excuStatus==SQLITE_ERROR)return nil;
    if (excuStatus!= SQLITE_OK)
    {
        printf("Error:Failed to insert EntityUser\n");
        return false;
    }
    sqlite3_bind_text(statement,1,[entity.userName UTF8String],-1,SQLITE_TRANSIENT);
    if([NSString isEnabled:entity.dataImage]&&[entity.dataImage isKindOfClass:[NSString class]])
        sqlite3_bind_text(statement,2,[entity.dataImage UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,3,[entity.longPingYing UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,4,[entity.shortPingYing UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,5,[entity.defaultPhone UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,6,[[entity.updateTime dateFormateDate:nil] UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 7, entity.locationStatus);
    if([NSString isEnabled:entity.jsonInfo])
        sqlite3_bind_text(statement,8,entity.jsonInfo?[[entity.jsonInfo JSONRepresentation] UTF8String]:"",-1,SQLITE_TRANSIENT);
    int success=sqlite3_step(statement);
    sqlite3_prepare_v2(self.database,"select last_insert_rowid()",-1,&statement,NULL);
    int _id = 0;
    while (sqlite3_step(statement)==SQLITE_ROW){
        _id = sqlite3_column_int(statement, 0);
    }
    entity.userId = _id;
    if([entity getTelephones]&&[[entity getTelephones] count]){
        for (EntityPhone *mp in [entity getTelephones]) {
            mp.phoneId = 0;
            [mp setEntityUserX:entity];
            [self merge:mp];
        }
    }
    sqlite3_finalize(statement);
    if(success==SQLITE_ERROR)
    {
        printf("Error:fail to insert into the database with message\n");
        return NO;
    }
    
    printf("inserted one EntityUser");
    return entity;
}
-(EntityCallRecord*) persistEntityCallRecord:(EntityCallRecord*) entity{
    char* insertSql = [EntityManagerOperation insertEntitysql:[entity class]];
    sqlite3_stmt *statement;
    if ([self openDataBase]==NO)return nil;
    int excuStatus = sqlite3_prepare_v2(_database,insertSql,-1,&statement,NULL);
    if (excuStatus==SQLITE_ERROR)return nil;
    if (excuStatus!= SQLITE_OK)
    {
        printf("Error:Failed to insert EntityCallRecord\n");
        return false;
    }
    sqlite3_bind_int(statement, 1, entity.recordTime);
    sqlite3_bind_int(statement, 2, entity.statusCall);
     const char* phoneNum = [entity.callPhoneNum UTF8String];
    sqlite3_bind_text(statement, 3, phoneNum,-1,SQLITE_TRANSIENT);
    long long int createTime = [entity.createTime timeIntervalSince1970]*1000;
    sqlite3_bind_int64(statement, 4, createTime);
    sqlite3_bind_int(statement, 5, 0);
    if([NSString isEnabled:entity.jsonInfo])sqlite3_bind_text(statement,6,[[entity.jsonInfo JSONRepresentation] UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_int(statement,7,[entity getEntityId]);
    int success=sqlite3_step(statement);
    sqlite3_finalize(statement);
    if(success==SQLITE_ERROR)
    {
        printf("Error:fail to insert into the database with message\n");
        return NO;
    }
    printf("inserted one EntityCallRecord\n");
    return entity;
}
-(EntityPhone*) persistEntityPhone:(EntityPhone*) entity{
    @try {
        [self excueSpecialTarget:^NSString *(id target) {
            return [NSString stringWithFormat:@"%s",[EntityPhone getPersistSql]];
        } ExcuCallBackBindValue:^id(sqlite3_stmt *statement) {
            sqlite3_bind_int(statement, 1, [entity getEntityUser].userId);
            sqlite3_bind_int(statement, 2, entity.type);
            sqlite3_bind_text(statement, 3, [entity.phoneNum UTF8String], -1, SQLITE_TRANSIENT);
            if([NSString isEnabled:entity.jsonInfo])
                sqlite3_bind_text(statement,4,entity.jsonInfo?[[entity.jsonInfo JSONRepresentation] UTF8String]:"",-1,SQLITE_TRANSIENT);
            return nil;
        } ExcuCallBackSetValue:^id(sqlite3_stmt *statement) {
            int success=sqlite3_step(statement);
            sqlite3_prepare_v2(self.database,"select last_insert_rowid()",-1,&statement,NULL);
            int _id = 0;
            while (sqlite3_step(statement)==SQLITE_ROW){
                _id = sqlite3_column_int(statement, 0);
            }
            entity.phoneId = _id;
            if(success==SQLITE_ERROR)
            {
                printf("Error:fail to update into the database with message\n");
                return NO;
            }
            printf("insert one EntityPhone\n");
            return nil;
        }];
    }
    @catch (NSException *exception) {
        return nil;
    }
    return entity;
}
-(EntityUser*) updateEntityUser:(EntityUser*) entity{
    char* updateSql = [EntityManagerOperation updateEntitySql:[entity class]];
    sqlite3_stmt *statement;
    if ([self openDataBase]==NO)return nil;
    int excuStatus = sqlite3_prepare_v2(_database,updateSql,-1,&statement,NULL);
    if (excuStatus==SQLITE_ERROR)return nil;
    if (excuStatus!= SQLITE_OK)
    {
        printf("Error:Failed to update EntityUser\n");
        return false;
    }
    sqlite3_bind_text(statement,1,[entity.userName UTF8String],-1,SQLITE_TRANSIENT);
    if([NSString isEnabled:entity.dataImage]&&[entity.dataImage isKindOfClass:[NSString class]])
        sqlite3_bind_text(statement,2,[entity.dataImage UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,3,[entity.longPingYing UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,4,[entity.shortPingYing UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,5,[entity.defaultPhone UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,6,[[entity.updateTime dateFormateDate:nil] UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 7, entity.locationStatus);
    if([NSString isEnabled:entity.jsonInfo])
        sqlite3_bind_text(statement,8,entity.jsonInfo?[[entity.jsonInfo JSONRepresentation] UTF8String]:"",-1,SQLITE_TRANSIENT);
    sqlite3_bind_int(statement,9,[entity getEntityId]);
    int success=sqlite3_step(statement);
    sqlite3_finalize(statement);
    if(success==SQLITE_ERROR)
    {
        printf("Error:fail to update into the database with message\n");
        return NO;
    }
    if([entity getTelephones]&&[[entity getTelephones] count]){
        bool flag = [self removeEntityPhoneByUserId:entity.userId];
        if(!flag){
            printf("delete EntityPhone by userId faild!!!");
        }
        for (EntityPhone *mp in [entity getTelephones]) {
            mp.phoneId = 0;
            [mp setEntityUserX:entity];
            [self merge:mp];
        }
    }
    printf("update one EntityUser\n");
    return entity;
}
-(EntityCallRecord*) updateEntityCallRecord:(EntityCallRecord*) entity{
    char* updateSql = [EntityManagerOperation updateEntitySql:[entity class]];
    sqlite3_stmt *statement;
    if ([self openDataBase]==NO)return nil;
    int excuStatus = sqlite3_prepare_v2(_database,updateSql,-1,&statement,NULL);
    if (excuStatus==SQLITE_ERROR)return nil;
    if (excuStatus!= SQLITE_OK)
    {
        printf("Error:Failed to update EntityCallRecord\n");
        return false;
    }
    sqlite3_bind_int(statement, 1, entity.recordTime);
    sqlite3_bind_int(statement, 2, entity.statusCall);
    sqlite3_bind_text(statement, 3, [entity.callPhoneNum UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_text(statement,4,[[entity.createTime dateFormateDate:nil] UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_int(statement, 5, 0);
    if([NSString isEnabled:entity.jsonInfo])sqlite3_bind_text(statement,6,[[entity.jsonInfo JSONRepresentation] UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_int(statement,7,[entity getEntityId]);
    int success=sqlite3_step(statement);
    sqlite3_finalize(statement);
    if(success==SQLITE_ERROR)
    {
        printf("Error:fail to update into the database with message\n");
        return NO;
    }
    printf("update one EntityCallRecord\n");
    return entity;
}
-(id) updateEntityPhone:(EntityPhone*) entity{
    @try {
        [self excueSpecialTarget:^NSString *(id target) {
            return [NSString stringWithFormat:@"%s",[EntityPhone getMergeSql]];
        } ExcuCallBackBindValue:^id(sqlite3_stmt *statement) {
            sqlite3_bind_int(statement, 1, [entity getEntityUser].userId);
            sqlite3_bind_int(statement, 2, entity.type);
            sqlite3_bind_text(statement, 3, [entity.phoneNum UTF8String], -1, SQLITE_TRANSIENT);
            if([NSString isEnabled:entity.jsonInfo])
                sqlite3_bind_text(statement,4,entity.jsonInfo?[[entity.jsonInfo JSONRepresentation] UTF8String]:"",-1,SQLITE_TRANSIENT);
            sqlite3_bind_int(statement, 5, entity.phoneId);
            return nil;
        } ExcuCallBackSetValue:^id(sqlite3_stmt *statement) {
            int success=sqlite3_step(statement);
            if(success==SQLITE_ERROR)
            {
                printf("Error:fail to update into the database with message\n");
                return NO;
            }
            printf("update one EntityPhone\n");
            return nil;
        }];
    }
    @catch (NSException *exception) {
        return nil;
    }
    return entity;
}
-(EntityUser*) getEntityUser:(int) userId{
    char *getSql = [EntityManagerOperation getEntitySql:[EntityUser class]];
    EntityUser *user = nil;
    sqlite3_stmt *statement;
    if ([self openDataBase]==NO)return nil;
    int excuStatus = sqlite3_prepare_v2(self.database,getSql,-1,&statement,NULL);
    sqlite3_bind_int(statement,1,userId);
    if (excuStatus==SQLITE_ERROR)return nil;
    if (excuStatus!= SQLITE_OK)
    {
        printf("Failed to get all EntityUser!\n");
    }
    else
    {
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            user = [[EntityUser alloc]init];
            user.userId =sqlite3_column_int(statement,0);
            const unsigned char *userName=sqlite3_column_text(statement,1);
            user.userName = [NSString stringWithUTF8String:(char*)userName];
            const unsigned char *dataImage= sqlite3_column_text(statement, 2);
            if(dataImage&&strlen((char*) dataImage))
                user.dataImage = [NSString stringWithUTF8String:(char*)dataImage];
            const unsigned char *longPingYing=sqlite3_column_text(statement,3);
            user.longPingYing = [NSString stringWithUTF8String:(char*)longPingYing];
            const unsigned char *shortPingYing=sqlite3_column_text(statement,4);
            user.shortPingYing = [NSString stringWithUTF8String:(char*)shortPingYing];
            const unsigned char *defaultPhone=sqlite3_column_text(statement,5);
            user.defaultPhone = [NSString stringWithUTF8String:(char*)defaultPhone];
            const unsigned char *updateTime=sqlite3_column_text(statement,6);
            user.updateTime = [[NSString stringWithUTF8String:(char*)updateTime] dateFormateString:nil];
            user.locationStatus = sqlite3_column_int(statement,7);
            const unsigned char *jsonInfo= sqlite3_column_text(statement,8);
            if(jsonInfo&&strlen((char*) jsonInfo))
                user.jsonInfo = strlen((const char*)(char*)jsonInfo)?[[NSString stringWithUTF8String:(char*)jsonInfo] JSONValue]:nil;
            break;
        }
    }
    sqlite3_finalize(statement);
    return user;
}
-(EntityCallRecord*) getEntityCallRecord:(int) userId{
    char *getSql = [EntityManagerOperation getEntitySql:[EntityCallRecord class]];
    EntityCallRecord *recode = nil;
    sqlite3_stmt *statement;
    if ([self openDataBase]==NO)return nil;
    int excuStatus = sqlite3_prepare_v2(self.database,getSql,-1,&statement,NULL);
    sqlite3_bind_int(statement,1,userId);
    if (excuStatus==SQLITE_ERROR)return nil;
    if (excuStatus!= SQLITE_OK)
    {
        printf("Failed to get all EntityCallRecord!\n");
    }
    else
    {
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            recode = [[EntityCallRecord alloc]init];
            recode.recordId =sqlite3_column_int(statement,0);
            recode.recordTime = sqlite3_column_int(statement, 1);
            recode.statusCall = sqlite3_column_int(statement, 2);
            const unsigned char *callPhoneNum=sqlite3_column_text(statement,3);
            recode.callPhoneNum = [NSString stringWithFormat:@"%s",callPhoneNum];
            long long int createTime=sqlite3_column_int64(statement,4);
            recode.createTime = [[NSDate alloc] initWithTimeIntervalSince1970:createTime/1000];
            EntityUser *modelUser = [[EntityUser alloc]init];
            modelUser.userId = sqlite3_column_int(statement, 5);
            recode.entityUser = modelUser;
            const unsigned char *jsonInfo=sqlite3_column_text(statement,6);
            recode.jsonInfo = strlen((const char*)(char*)jsonInfo)?[[NSString stringWithFormat:@"%s",jsonInfo] JSONValue]:nil;
            break;
        }
    }
    sqlite3_finalize(statement);
    return recode;
}
-(id) getEntityPhone:(int) phoneId{
    NSMutableArray *_phones =[self excueSpecialTarget:^NSString *(id target) {
        return [NSString stringWithFormat:@"%s",[EntityPhone getFindSql]];
    } ExcuCallBackBindValue:^id(sqlite3_stmt *statement) {
        sqlite3_bind_int(statement, 1, phoneId);
        return nil;
    } ExcuCallBackSetValue:^id(sqlite3_stmt *statement) {
        NSMutableArray *phones = [[NSMutableArray alloc]init];
        while (sqlite3_step(statement)==SQLITE_ROW){
            EntityPhone *mp = [EntityPhone new];
            mp.phoneId = sqlite3_column_int(statement, 0);
            EntityUser *u = [EntityUser new];
            u.userId = sqlite3_column_int(statement, 1);
            mp.entityUser = u;
            mp.type = sqlite3_column_int(statement, 2);
            const unsigned char *phoneNum = sqlite3_column_text(statement, 3);
            mp.phoneNum = [NSString stringWithFormat:@"%s",phoneNum];
            const unsigned char *jsonInfo= sqlite3_column_text(statement,4);
            if(jsonInfo&&strlen((char*) jsonInfo))
                mp.jsonInfo = strlen((const char*)(char*)jsonInfo)?[[NSString stringWithUTF8String:(char*)jsonInfo] JSONValue]:nil;
            [phones addObject:mp];
            break;
        }
        return phones;
    }];
    if(_phones&&[_phones count]){
        return [_phones objectAtIndex:0];
    }
    return nil;
}
-(id) excueSpecialTarget:(excueM1) excuCallBackGetSql ExcuCallBackBindValue:(excueM2)excuCallBackBindValue ExcuCallBackSetValue:(excueM2)excuCallBackSetValue{
    if ([self openDataBase]==NO)return nil;
    if(!excuCallBackGetSql){
        printf("No sql return!\n");
        return nil;
    }
    
    NSString *sql = excuCallBackGetSql(self.target);
    sqlite3_stmt *statement;
    int excuStatus = sqlite3_prepare_v2(self.database,[sql UTF8String],-1,&statement,NULL);
    id results = nil;
    @try {
        if(excuCallBackBindValue)excuCallBackBindValue(statement);
        if (excuStatus==SQLITE_ERROR)return nil;
        if (excuStatus!= SQLITE_OK){
            printf("Failed to get all DataInfo!\n");
        } else if(excuCallBackSetValue){
            results = excuCallBackSetValue(statement);
        }else{
            printf("No set value method!\n");
        }
    }
    @finally {
        sqlite3_finalize(statement);
    }
    return results;
}
//<==opt method


//==>static method
+(char*) createEntitySql:(Class) clazz{
    char* sql;
    if(clazz==[EntityUser class]){
        sql = [EntityUser getCreateSql];
    }else if(clazz==[EntityCallRecord class]){
        sql = "CREATE TABLE IF NOT EXISTS EntityCallRecord (recordId INTEGER PRIMARY KEY AUTOINCREMENT,recordTime INTEGER,statusCall INTEGER,callPhoneNum TEXT, createTime BIGINT,entityUserId INTEGER,jsonInfo TEXT)";
    }else if(clazz==[EntityPhone class]){
        return [EntityPhone getCreateSql];
    } else{
        sql = NULL;
    }
    return sql;
}
+(char*) insertEntitysql:(Class) clazz{
    char* sql;
    if(clazz==[EntityUser class]){
        sql = [EntityUser getPersistSql];
    }else if(clazz==[EntityCallRecord class]){
        sql = "INSERT INTO EntityCallRecord (recordTime,statusCall,callPhoneNum,createTime,entityUserId,jsonInfo) VALUES (?,?,?,?,?,?)";
    }else if(clazz==[EntityPhone class]){
        return [EntityPhone getPersistSql];
    }else{
        sql = NULL;
    }
    return sql;
}
+(char*) updateEntitySql:(Class) clazz{
    char* sql;
    if(clazz==[EntityUser class]){
        sql = [EntityUser getMergeSql];
    }else if(clazz==[EntityCallRecord class]){
        sql = "UPDATE EntityCallRecord SET recordTime = ?,statusCall = ?,callPhoneNum = ?, createTime = ?, entityUserId = ?, jsonInfo = ? WHERE recordId=?";
    }else if(clazz==[EntityPhone class]){
        return [EntityPhone getMergeSql];
    }else{
        sql = NULL;
    }
    return sql;
}
+(char*) deleteEntitySql:(Class) clazz{
    char* sql;
    if(clazz==[EntityUser class]){
        sql = [EntityUser getDeleteSql];
    }else if(clazz==[EntityCallRecord class]){
        sql = "DELETE FROM EntityCallRecord WHERE recordId=?";
    }else if(clazz==[EntityPhone class]){
        return [EntityPhone getDeleteSql];
    }else{
        sql = NULL;
    }
    return sql;
}
+(char*) getEntitySql:(Class) clazz{
    char* sql;
    if(clazz==[EntityUser class]){
        sql = [EntityUser getFindSql];
    }else if(clazz==[EntityCallRecord class]){
        sql = "Select * From EntityCallRecord WHERE recordId=?";
    }else if(clazz==[EntityPhone class]){
        return [EntityPhone getFindSql];
    } else{
        sql = NULL;
    }
    return sql;
}
//<==static method
@end
