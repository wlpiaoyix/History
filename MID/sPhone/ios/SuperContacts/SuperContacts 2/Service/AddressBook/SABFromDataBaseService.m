//
//  SABFromDataBaseService.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-7.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "SABFromDataBaseService.h"
#import "EntityManagerOperation.h"
#import "ChineseToPinyin.h"
#import "MADE_COMMON.h"
@interface SABFromDataBaseService()
@property (strong, nonatomic) EntityManagerOperation *em;
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
    id v = [_em excueSpecialTarget:^NSString *(id target) {
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
            return [NSString isEnabled:params]?[NSString stringWithFormat:@"SELECT u.* FROM EntityUser u WHERE (u.defaultPhone LIKE '%@%%' %@)  or EXISTS (select 1 from EntityPhone as mp where mp.entityUserId = u.userId and mp.phoneNum like '%%%@%%')",params,([NSString isEnabled:temp2]?[NSString stringWithFormat:@"or %@",temp2]:@""),params]:@"SELECT * FROM EntityUser";
        }else{
            return [NSString isEnabled:params]?[NSString stringWithFormat:@"SELECT u.* FROM EntityUser u WHERE (shortPingYing LIKE '%@%%' or longPingYing LIKE '%@%%' or userName LIKE '%@%%' or defaultPhone LIKE '%@%%')  or EXISTS (select 1 from EntityPhone as mp where mp.entityUserId = u.userId and mp.phoneNum like '%%%@%%')",params,params,params,params,params]:@"SELECT * FROM EntityUser";
        }
    } ExcuCallBackBindValue:false ExcuCallBackSetValue:^id(sqlite3_stmt *statement) {
        NSMutableArray *users = [[NSMutableArray alloc]init];
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            EntityUser *user = [[EntityUser alloc]init];
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
            [users addObject:user];
        }
        return users;
    }];
    return v;
}
-(NSArray*) queryEntityUserByPhone:(NSString*) phone{
    id v = [_em excueSpecialTarget:^NSString *(id target) {
//        sql	__NSCFString *	@"SELECT u.* FROM EntityUser as u WHERE u.defaultPhone LIKE '%18228088049%'  or (EXISTS select 0 from EntityPhone as mp where mp.entityUserId = u.userId and mp.phoneNum like '%18228088049%' )"	0x201cd930
        return 	[NSString isEnabled:phone]?[NSString stringWithFormat:@"SELECT u.* FROM EntityUser as u WHERE u.defaultPhone LIKE '%%%@%%'  or (EXISTS (select 0 from EntityPhone as mp where mp.entityUserId = u.userId and mp.phoneNum like '%%%@%%') )",phone,phone]:@"SELECT * FROM EntityUser";
    } ExcuCallBackBindValue:false ExcuCallBackSetValue:^id(sqlite3_stmt *statement) {
        NSMutableArray *users = [[NSMutableArray alloc]init];
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            EntityUser *user = [[EntityUser alloc]init];
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
            [users addObject:user];
        }
        return users;
    }];
    return v;
}
-(NSArray*) queryEntityUserByName:(NSString *)name{
    id v = [_em excueSpecialTarget:^NSString *(id target) {
        return name?[NSString stringWithFormat:@"SELECT * FROM EntityUser WHERE userName LIKE '%%%@%%'",name]:@"SELECT * FROM EntityUser";
    } ExcuCallBackBindValue:false ExcuCallBackSetValue:^id(sqlite3_stmt *statement) {
        NSMutableArray *users = [[NSMutableArray alloc]init];
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            EntityUser *user = [[EntityUser alloc]init];
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
            [users addObject:user];
        }
        return users;
    }];
    return v;
}
-(NSArray*) queryEntityCallRecordByPhone:(NSString*) phone{
    id v = [_em excueSpecialTarget:^NSString *(id target) {
        return [NSString isEnabled:phone]?[NSString stringWithFormat:@"SELECT * FROM EntityCallRecord WHERE callPhoneNum like '%%%@%%' ORDER BY createTime DESC",phone]:@"SELECT * FROM EntityCallRecord ORDER BY createTime DESC";
    } ExcuCallBackBindValue:false ExcuCallBackSetValue:^id(sqlite3_stmt *statement) {
        NSMutableArray *recodes = [[NSMutableArray alloc]init];
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            EntityCallRecord *recode = [[EntityCallRecord alloc]init];
            
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
            recode.jsonInfo = (jsonInfo&&strlen((const char*)(char*)jsonInfo))?[[NSString stringWithFormat:@"%s",jsonInfo] JSONValue]:nil;
            [recodes addObject:recode];
        }
        return recodes;
    }];
    return v;
}

-(NSArray*) queryEntityCallRecordByName:(NSString *)name{
    NSArray* temp = [self queryEntityUserByName:name];
    if(!temp||temp == nil||[temp count]==0){
        return nil;
    }
    NSString *ids = @"-1";
    for (EntityUser *user in temp) {
        ids = [ids stringByAppendingString:[NSString stringWithFormat:@",%d",user.userId]];
    }
    id v = [_em excueSpecialTarget:^NSString *(id target) {
        return [NSString stringWithFormat:@"SELECT * FROM EntityCallRecord WHERE entityUserId in( %@) ORDER BY createTime DESC",ids];
    } ExcuCallBackBindValue:false ExcuCallBackSetValue:^id(sqlite3_stmt *statement) {
        NSMutableArray *recodes = [[NSMutableArray alloc]init];
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            EntityCallRecord *recode = [[EntityCallRecord alloc]init];
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
            recode.jsonInfo = (jsonInfo&&strlen((const char*)(char*)jsonInfo))?[[NSString stringWithFormat:@"%s",jsonInfo] JSONValue]:nil;
            [recodes addObject:recode];
        }
        return recodes;
    }];
    return v;
}

/**
 params主要是匹配longPingYing shortPingYing userName  callPhoneNum
 */
-(NSArray*) queryRecordByParams:(NSString*) params{
    id v = [_em excueSpecialTarget:^NSString *(id target) {
        if(![NSString isEnabled:params]){
            return @"select t.* from EntityCallRecord as t order by createTime desc";
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
            return [NSString stringWithFormat:@"select r.* from EntityCallRecord as r where  EXISTS (select 0 from EntityPhone as mp where mp.phoneNum = r.callPhoneNum and (r.callPhoneNum like '%%%@%%'  %@)) or r.callPhoneNum like '%%%@%%' order by createTime desc",params,temp3,params];
        }
        // or u.userName like '%?' or u.longPingYing like '%?' or u.shortPingYing like '%?' or u.longPingYing like '%?'
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
            recode.jsonInfo = (jsonInfo&&strlen((const char*)(char*)jsonInfo))?[[NSString stringWithFormat:@"%s",jsonInfo] JSONValue]:nil;
            [temp1 addObject:recode];
        }
        return temp1;
    }];
    return v;
}
-(EntityUser*) findEntityUser:(int) userId{
    return [_em find:[EntityUser class] EntityId:userId];
}
-(EntityUser*) findEntityCallRecord:(int) recordeId{
    return [_em find:[EntityCallRecord class] EntityId:recordeId];
}
-(EntityUser*) persistEntityUser:(EntityUser*) user{
    if(![NSString isEnabled:user.userName]){
        @throw [[NSException alloc]initWithName:@"新增异常" reason:@"用户名不能为空" userInfo:nil];
    }
    if(![NSString isEnabled:user.defaultPhone]){
        @throw [[NSException alloc]initWithName:@"新增异常" reason:@"用户号码不能为空" userInfo:nil];
    }
    if(![user.telephones count]){
        @throw [[NSException alloc]initWithName:@"操作异常" reason:@"请至少填写一个电话号码" userInfo:nil];
    }
    if([user.userName hasPrefix:@"#"]||[user.userName hasPrefix:@"*"]||[user.userName hasPrefix:@"@"]){
        @throw [[NSException alloc]initWithName:@"操作异常" reason:@"不能使用特殊字符开头" userInfo:nil];
    }
    user.longPingYing = [ChineseToPinyin pinyinFromChiniseString:user.userName];
    user.shortPingYing = [ChineseToPinyin pinyinFromChiniseStringHead:user.userName];
    user.updateTime = [NSDate new];
    return [_em persist:user];
}
-(EntityCallRecord*) persistEntityCallRecord:(EntityCallRecord*) record{
    if(![NSString isEnabled:record.callPhoneNum]){
        @throw [[NSException alloc]initWithName:@"新增异常" reason:@"电话号码不能为空" userInfo:nil];
    }
    record.createTime = [NSDate new];
    return [_em persist:record];
}
-(EntityUser*) mergeEntityUser:(EntityUser*) user{
    if(![NSString isEnabled:user.userName]){
        @throw [[NSException alloc]initWithName:@"更新异常" reason:@"用户名不能为空" userInfo:nil];
    }
    if(![user.telephones count]){
        @throw [[NSException alloc]initWithName:@"操作异常" reason:@"请至少填写一个电话号码" userInfo:nil];
    }
    if(![NSString isEnabled:user.defaultPhone]){
        @throw [[NSException alloc]initWithName:@"更新异常" reason:@"用户号码不能为空" userInfo:nil];
    }
    if([user.userName hasPrefix:@"#"]||[user.userName hasPrefix:@"*"]||[user.userName hasPrefix:@"@"]){
        @throw [[NSException alloc]initWithName:@"操作异常" reason:@"不能使用特殊字符开头" userInfo:nil];
    }
    user.longPingYing = [ChineseToPinyin pinyinFromChiniseString:user.userName];
    user.shortPingYing = [ChineseToPinyin pinyinFromChiniseStringHead:user.userName];
    user.updateTime = [NSDate new];
    return [_em merge:user];
}
-(EntityCallRecord*) mergeEntityCallRecord:(EntityCallRecord*) record{
    if(![NSString isEnabled:record.callPhoneNum]){
        @throw [[NSException alloc]initWithName:@"更新异常" reason:@"电话号码不能为空" userInfo:nil];
    }
    record.createTime = [NSDate new];
    return [_em merge:record];
}
-(bool) removeEntityUser:(EntityUser*) user{
    return [_em remove:user];
}
-(bool) removeEntityCallRecord:(EntityCallRecord*) record{
    return [_em remove:record];
}
-(bool) removeAllEntityUser{
    NSArray *files = [_em excueSpecialTarget:^NSString *(id target) {
        return @"SELECT dataImage FROM EntityUser";
    } ExcuCallBackBindValue:nil ExcuCallBackSetValue:^id(sqlite3_stmt *statement) {
        NSMutableArray *__files= [[NSMutableArray alloc]init];
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            const unsigned char *filePath=sqlite3_column_text(statement,0);
            NSFileManager *f = [NSFileManager defaultManager];
            if(filePath&&strlen((char*)filePath)){
                [MADE_COMMON deleteImage110ak640:[NSString stringWithUTF8String:(const char *)filePath]];
            }
        }
        return __files;
    }];
    NSFileManager *fmanager = [NSFileManager defaultManager];
    for (NSString*filePath in files) {
        if([fmanager fileExistsAtPath:filePath]){
            [fmanager removeItemAtPath:filePath error:NULL];
        }
    }
    bool result = [_em excueSpecialTarget:^NSString *(id target) {
        return @"DELETE FROM EntityUser";
    } ExcuCallBackBindValue:nil ExcuCallBackSetValue:nil];
    return result;
}
@end
