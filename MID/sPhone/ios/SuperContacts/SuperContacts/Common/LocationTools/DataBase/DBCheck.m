//
//  DBCheck.m
//  ST-ME
//
//  Created by wlpiaoyi on 13-12-27.
//  Copyright (c) 2013年 wlpiaoyi. All rights reserved.
//

#import "DBCheck.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <sqlite3.h>
static const NSString *DBCHECK_SUFFIX = @".sqlite3";
@interface DBCheck()
@property sqlite3 *database;
@end
@implementation DBCheck
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
    if (!success) NSLog(@"has no database at [ %@]",realPath);
    self = [self init];
    if (self) {
        self.databasePath = realPath;
    }
    return self;
}
-(bool) openDataBase
{
    if(self.database){
    }else{
    }
    int status = sqlite3_open([self.databasePath UTF8String],&_database);
    switch (status) {
        case SQLITE_OK:
        {
            printf("open the database successfully");
            return YES;
        }
            break;
        default:
        {
            sqlite3_close(self.database);
            printf("failed to open the database");
            return NO;
        }
            break;
    }
}
-(bool) excuSQL:(const char*) sql
{
    if ([self openDataBase]==NO)return NO;
    char *erroMsg;
    if (sqlite3_exec(self.database, sql, NULL, NULL, &erroMsg)!= SQLITE_OK)
    {
        sqlite3_close(self.database);
        printf("excue sql faild");
        return NO;
    }
    else
    {
        printf("excue sql success");
        return YES;
    }
}
-(int) prepareSQL:(const char*) sql Statement:(sqlite3_stmt*) statement;{
    if ([self openDataBase]==NO)return SQLITE_ERROR;
    int excuStatus = sqlite3_prepare_v2(self.database,sql,-1,&statement,NULL);
    return excuStatus;
}
-(bool)createTimerTable
{
    NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(id INTEGER PRIMARY KEY AUTOINCREMENT,time INTEGER,remaintime INTEGER,iconuri BLOB,vibrate INTEGER,status INTEGER,message TEXT)",@"table002"];
    if ([self excuSQL:[createSQL UTF8String]]==YES)
    {
        printf("table was created");
        sqlite3_close(_database);
        return YES;
    }else{
        sqlite3_close(_database);return NO;
    }
}
-(bool) insertTableValue{
    char *insertTimerSql="INSERT INTO table002 (time,remaintime,iconuri,vibrate,status,message) VALUES (?,?,?,?,?,?)";
    sqlite3_stmt *statement;
    if ([self openDataBase]==NO)return SQLITE_ERROR;
    int excuStatus = sqlite3_prepare_v2(self.database,insertTimerSql,-1,&statement,NULL);
    if (excuStatus==SQLITE_ERROR)return false;
    if (excuStatus!= SQLITE_OK)
    {
        NSLog(@"Error:Failed to insert timer");
        return false;
    }
    sqlite3_bind_int(statement,1,12345);//timerInfo是一个封装了相关属性的实体类对象
    sqlite3_bind_int(statement,2,12346);
    sqlite3_bind_text(statement,3,[@"adfadf" UTF8String],-1,SQLITE_TRANSIENT);
    sqlite3_bind_int(statement,4,1232);
    sqlite3_bind_int(statement,5,1);
    sqlite3_bind_text(statement,6,[@"sdfdsfgsdgsgh" UTF8String],-1,SQLITE_TRANSIENT);
    int success=sqlite3_step(statement);
    sqlite3_finalize(statement);
    if(success==SQLITE_ERROR)
    {
        NSLog(@"Error:fail to insert into the database with message.");
        return NO;
    }
    NSLog(@"inserted one timer");
    sqlite3_close(_database);
    return YES;
    
}
-(bool) deleteTable{
    char *deleteStr = "delete from table002 where id = ?";
    sqlite3_stmt *statement = NULL;
    if ([self openDataBase]==NO)return SQLITE_ERROR;
    int excuStatus = sqlite3_prepare_v2(self.database,deleteStr,-1,&statement,NULL);
    if (excuStatus==SQLITE_ERROR)return false;
    if (excuStatus!= SQLITE_OK)
    {
        NSLog(@"Error:Failed to delete timer");
        return NO;
    }else{
        sqlite3_bind_int(statement,1,2);
        int success=sqlite3_step(statement);
        sqlite3_finalize(statement);
        if(success==SQLITE_ERROR)
        {
            NSLog(@"Error:fail to insert into the database with message.");
            sqlite3_close(_database);
            return NO;
        }
        NSLog(@"inserted one timer");
        sqlite3_close(_database);
        return YES;
    }
}
-(void) queryTable{
    char *queryStr="SELECT * FROM table002";
    sqlite3_stmt *statement = NULL;
    if ([self openDataBase]==NO)return;
    int excuStatus = sqlite3_prepare_v2(self.database,queryStr,-1,&statement,NULL);
    if (excuStatus==SQLITE_ERROR)return;
    if (excuStatus!= SQLITE_OK)
    {
        printf("Failed to get all timers!\n");
    }
    else
    {
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            int int1 =sqlite3_column_int(statement,0);
            int int2 =sqlite3_column_int(statement,1);
            int int3=sqlite3_column_int(statement,2);
            int int4 =sqlite3_column_int(statement,4);
            const unsigned char *messageChar2=sqlite3_column_text(statement,3);
            int int5= sqlite3_column_int(statement,5);
            const unsigned char *messageChar=sqlite3_column_text(statement,6);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(_database);
}

@end
