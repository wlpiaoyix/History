//
//  SABFromDataBaseService.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-7.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "SABFromDataBaseService.h"
#import "FDEntityManager.h"
#import "ChineseToPinyin.h"
@interface SABFromDataBaseService()
@property (strong, nonatomic) FDEntityManager *em;
@property char* headHX;
@end
@implementation SABFromDataBaseService
-(id) init{
    self = [super init];
    if(self){
        _em = COMMON_EM;
        _headHX = "BCDFGHJKLMNPQRSTVWXYZ";
    }
    return self;
}
-(NSArray*) checkEntityUsers:(NSArray*) us{
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    for(EntityUser *u in us){
        
    }
    return temp;
}
-(NSArray*) queryEntityUserByParams:(NSString*) params IfChekNum:(bool) ifCheckNum{
    
    NSString *sql;
    if(ifCheckNum){
        NSArray *temp = COMMON_CHECKNUMTOPYFORARRAY((char*)[params UTF8String]);
        NSString *temp2 = @"";
        bool flag = false;
        for (NSString *s in temp) {
            if(!flag){
                temp2 = [temp2 stringByAppendingString:[NSString stringWithFormat:@" u.shortPingYing like '%@%%' ",s]];
                flag = true;
            }else{
                temp2 = [temp2 stringByAppendingString:[NSString stringWithFormat:@" or u.shortPingYing like '%@%%' ",s]];
            }
        }
        sql = [NSString isEnabled:params]?[NSString stringWithFormat:@"SELECT u.* FROM EntityUser u WHERE (1=1 %@)  or EXISTS (select 1 from EntityPhone as mp where mp.entityUserId = u.userId and mp.phoneNum like '%%%@%%')",([NSString isEnabled:temp2]?[NSString stringWithFormat:@"or %@",temp2]:@""),params]:@"SELECT * FROM EntityUser";
    }else{
        sql = [NSString isEnabled:params]?[NSString stringWithFormat:@"SELECT u.* FROM EntityUser u WHERE (shortPingYing LIKE '%@%%' or longPingYing LIKE '%@%%' or userName LIKE '%@%%' or defaultPhone LIKE '%@%%')  or EXISTS (select 1 from EntityPhone as mp where mp.entityUserId = u.userId and mp.phoneNum like '%%%@%%')",params,params,params,params,params]:@"SELECT * FROM EntityUser";
    }
    
    id v = [_em queryBySql:sql Clazz:[EntityUser class] Params:nil];
    if(!v)v = [NSMutableArray new];
    return v;
}
-(NSArray*) queryEntityUserByPhone:(NSString*) phone{
    NSString *sql = [NSString isEnabled:phone]?[NSString stringWithFormat:@"SELECT u.* FROM EntityUser as u WHERE (EXISTS (select 0 from EntityPhone as mp where mp.entityUserId = u.userId and mp.phoneNum like '%%%@%%') )",phone]:@"SELECT * FROM EntityUser";
    id v = [_em queryBySql:sql Clazz:[EntityUser class] Params:nil];
    return v;
}
-(NSArray*) queryEntityUserByName:(NSString *)name{
    NSString *sql = name?[NSString stringWithFormat:@"SELECT * FROM EntityUser WHERE userName LIKE '%%%@%%'",name]:@"SELECT * FROM EntityUser";
    id v = [_em queryBySql:sql Clazz:[EntityUser class] Params:nil];
    return v;
}
-(NSArray*) queryEntityCallRecordByPhone:(NSString*) phone{
    NSString *sql =  [NSString isEnabled:phone]?[NSString stringWithFormat:@"SELECT * FROM EntityCallRecord WHERE callPhoneNum like '%%%@%%' ORDER BY createTime DESC",phone]:@"SELECT * FROM EntityCallRecord ORDER BY createTime DESC";
    id v = [_em queryBySql:sql Clazz:[EntityUser class] Params:nil];
    return v;
}

-(NSArray*) queryEntityCallRecordByName:(NSString *)name{
    NSArray* temp = [self queryEntityUserByName:name];
    if(!temp||temp == nil||[temp count]==0){
        return nil;
    }
    NSString *ids = @"-1";
    for (EntityUser *user in temp) {
        ids = [ids stringByAppendingString:[NSString stringWithFormat:@",%d",user.userId.intValue]];
    }
    NSString *sql =  [NSString stringWithFormat:@"SELECT * FROM EntityCallRecord WHERE entityUserId in( %@) ORDER BY createTime DESC",ids];
    id v = [_em queryBySql:sql Clazz:[EntityUser class] Params:nil];
    return v;
}

/**
 params主要是匹配longPingYing shortPingYing userName  callPhoneNum
 */
-(NSArray*) queryRecordByParams:(NSString*) params{
    NSString *sql;
    id v;
    if(![NSString isEnabled:params]){
        sql = @"select t.* from EntityCallRecord as t order by createTime desc";
        v = [_em queryBySql:sql Clazz:[EntityCallRecord class] Params:nil];
    }else{
        NSArray *temp = COMMON_CHECKNUMTOPYFORARRAY((char*)[params UTF8String]);
        NSString *temp2 = @"";
        bool flag = false;
        for (NSString *s in temp) {
            if(!flag){
                temp2 = [temp2 stringByAppendingString:[NSString stringWithFormat:@" u.shortPingYing like '%@%%' ",s]];
                flag = true;
            }else{
                temp2 = [temp2 stringByAppendingString:[NSString stringWithFormat:@" or u.shortPingYing like '%@%%' ",s]];
            }
        }
        NSString *temp3 = [NSString isEnabled:temp2]?[NSString stringWithFormat:@"or EXISTS (select 0 from EntityUser as u where u.userId = mp.entityUserId %@) ",[NSString isEnabled:temp2]?[NSString stringWithFormat:@" and (%@)",temp2]:@""]:@"";
        sql = [NSString stringWithFormat:@"select r.* from EntityCallRecord as r where  EXISTS (select 0 from EntityPhone as mp where mp.phoneNum = r.callPhoneNum and (r.callPhoneNum like '%%%@%%'  %@)) or r.callPhoneNum like '%%%@%%' order by createTime desc",params,temp3,params];
        v = [_em queryBySql:sql Clazz:[EntityCallRecord class] Params:nil];
    }
    return v;
}
-(EntityUser*) findEntityUser:(NSNumber*) userId{
    return [_em find:userId Clazz:[EntityUser class]];
}
-(EntityUser*) findEntityCallRecord:(NSNumber*) recordeId{
    return [_em find:recordeId Clazz:[EntityCallRecord class]];
}
-(EntityUser*) persistEntityUser:(EntityUser*) user{
    if(![NSString isEnabled:user.userName]){
        @throw [[NSException alloc]initWithName:@"新增异常" reason:@"用户名不能为空" userInfo:nil];
    }
    if(![user.telephones count]){
        @throw [[NSException alloc]initWithName:@"操作异常" reason:@"请至少填写一个电话号码" userInfo:nil];
    }
    if([user.userName hasPrefix:@"#"]||[user.userName hasPrefix:@"*"]||[user.userName hasPrefix:@"@"]){
        @throw [[NSException alloc]initWithName:@"操作异常" reason:@"不能使用特殊字符开头" userInfo:nil];
    }
    user.longPingYing = [ChineseToPinyin pinyinFromChiniseString:user.userName];
    user.shortPingYing = [ChineseToPinyin pinyinFromChiniseStringHead:user.userName];
    user.updateTime = [NSNumber numberWithLong:[[NSDate new] timeIntervalSince1970]];
    return [_em persist:user];
}
-(EntityCallRecord*) persistEntityCallRecord:(EntityCallRecord*) record{
    if(![NSString isEnabled:record.callPhoneNum]){
        @throw [[NSException alloc]initWithName:@"新增异常" reason:@"电话号码不能为空" userInfo:nil];
    }
    record.createTime = [NSNumber numberWithLong:[[NSDate new] timeIntervalSince1970]];
    return [_em persist:record];
}
-(EntityUser*) mergeEntityUser:(EntityUser*) user{
    if(![NSString isEnabled:user.userName]){
        @throw [[NSException alloc]initWithName:@"更新异常" reason:@"用户名不能为空" userInfo:nil];
    }
    if(![user.telephones count]){
        @throw [[NSException alloc]initWithName:@"操作异常" reason:@"请至少填写一个电话号码" userInfo:nil];
    }
    if([user.userName hasPrefix:@"#"]||[user.userName hasPrefix:@"*"]||[user.userName hasPrefix:@"@"]){
        @throw [[NSException alloc]initWithName:@"操作异常" reason:@"不能使用特殊字符开头" userInfo:nil];
    }
    user.longPingYing = [ChineseToPinyin pinyinFromChiniseString:user.userName];
    user.shortPingYing = [ChineseToPinyin pinyinFromChiniseStringHead:user.userName];
    user.updateTime = [NSNumber numberWithLong:[[NSDate new] timeIntervalSince1970]];
    return [_em merge:user];
}
-(EntityCallRecord*) mergeEntityCallRecord:(EntityCallRecord*) record{
    if(![NSString isEnabled:record.callPhoneNum]){
        @throw [[NSException alloc]initWithName:@"更新异常" reason:@"电话号码不能为空" userInfo:nil];
    }
    record.createTime = [NSNumber numberWithLong:[[NSDate new] timeIntervalSince1970]];
    return [_em merge:record];
}
-(bool) removeEntityUser:(EntityUser*) user{
    return [_em remove:user];
}
-(bool) removeEntityCallRecord:(EntityCallRecord*) record{
    return [_em remove:record];
}
-(bool) removeAllEntityUser{
    NSArray *files = [_em queryBySql:@"SELECT dataImage FROM EntityUser" Params:nil];
    NSFileManager *fmanager = [NSFileManager defaultManager];
    for (NSString*filePath in files) {
        if([fmanager fileExistsAtPath:filePath]){
            [fmanager removeItemAtPath:filePath error:NULL];
        }
    }
    bool result = [_em excuSql:@"DELETE FROM EntityUser" Params:nil];
    return result;
}
@end
