//
//  SROpereationService.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-13.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "SROpereationService.h"
#import "EntityManagerOperation.h"
@interface SROpereationService()
@property EntityManagerOperation *em;
@end
@implementation SROpereationService
-(id) init{
    self = [self init];
    if(self){
        _em = COMMON_EM;
    }
    return self;
}
-(EntityCallRecord*) persist:(EntityCallRecord*) record{
    if ([NSString isEnabled:record.callPhoneNum]) {
        @throw [[NSException alloc] initWithName:@"EntityCallRecord persist" reason:@"callPhoneNum Can't be null!" userInfo:nil];
    }
    return [_em persist:record];
}
-(EntityCallRecord*) merge:(EntityCallRecord*) record{
    if ([NSString isEnabled:record.callPhoneNum]) {
        @throw [[NSException alloc] initWithName:@"EntityCallRecord merge" reason:@"callPhoneNum Can't be null!" userInfo:nil];
    }
    return [_em persist:record];
}
-(bool) removes:(EntityCallRecord*) record{
    return [_em remove:record];
}
/**
 params主要是匹配longPingYing shortPingYing userName  callPhoneNum
 */
-(NSArray*) queryByParams:(NSString*) params{
    id v = [_em excueSpecialTarget:^NSString *(id target) {
        return @"select * from EntityCallRecord where callPhoneNum like '%?%'";
    } ExcuCallBackBindValue:^id(sqlite3_stmt *statement) {
        sqlite3_bind_text(statement, 3, [params UTF8String],-1,SQLITE_TRANSIENT);
        return nil;
    } ExcuCallBackSetValue:^id(sqlite3_stmt *statement) {
        NSMutableArray *temp1 = [[NSMutableArray alloc] init];
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            EntityCallRecord *recode = [[EntityCallRecord alloc]init];
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
            [temp1 addObject:recode];
        }
        NSMutableArray *temp2 = [[NSMutableArray alloc] init];
        for (EntityCallRecord *record in temp1) {
            EntityUser *user = [record getEntityUser];
            if(!user) continue;
            if([user.longPingYing hasPrefix:params]||[user.longPingYing hasSuffix:params]||[user.shortPingYing hasSuffix:params]||[user.shortPingYing hasPrefix:params]||[user.userName hasPrefix:params]||[user.userName hasSuffix:params]){
                [temp2 addObject:user];
            }
        }
        [temp1 removeAllObjects];
        return temp2;
    }];
    return v;
}
/**
 status:0 无当前记录对应的联系人 1 反之
 */
-(NSArray*) query:(NSString*) userName Phone:(NSString*) phone Status:(int) status{
    id v = [_em excueSpecialTarget:^NSString *(id target) {
        return [NSString isEnabled:phone]?[NSString stringWithFormat:@"select * from EntityCallRecord where callPhoneNum like '%%%@%%' order by createTime desc",phone]:@"select * from EntityCallRecord order by createTime desc";
    } ExcuCallBackBindValue:nil ExcuCallBackSetValue:^id(sqlite3_stmt *statement) {
        NSMutableArray *temp1 = [[NSMutableArray alloc] init];
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            EntityCallRecord *recode = [[EntityCallRecord alloc]init];
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
            [temp1 addObject:recode];
        }
        NSMutableArray *temp2 = [[NSMutableArray alloc] init];
        if(status){
            for (EntityCallRecord *record in temp1) {
                EntityUser *user = [record getEntityUser];
                if(!user) continue;
                if([NSString isEnabled:userName]){
                    if([user.userName hasSuffix:userName]||[user.userName hasPrefix:userName]){
                        [temp2 addObject:user];
                    }
                }
            }
        }else{
            for (EntityCallRecord *record in temp1) {
                EntityUser *user = [record getEntityUser];
                if(user) continue;
                [temp2 addObject:user];
            }
        }
        [temp1 removeAllObjects];
        return temp2;
    }];
    return v;
}
@end
