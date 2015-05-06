//
//  EntityCallRecord.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-2.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "EntityCallRecord.h"
#import "EntityManagerOperation.h"
#import "EntityManagerAddressBook.h"
@interface EntityCallRecord()
@property bool entityUserFlag;
@end
@implementation EntityCallRecord
- (int) getEntityId{
    return _recordId;
}

-(EntityUser*) getEntityUser{
    @synchronized(_entityUser){
        if(!_entityUserFlag){
            __weak typeof(self) tempself = self;
            EntityManagerOperation *em = COMMON_EM;
            _entityUser = [em excueSpecialTarget:^NSString *(id target) {
                return [NSString stringWithFormat:@"select u.* from EntityUser as u where (EXISTS (select 0 from EntityPhone as mp where mp.entityUserId = u.userId and mp.phoneNum = '%@') )",tempself.callPhoneNum];
            } ExcuCallBackBindValue:nil ExcuCallBackSetValue:^id(sqlite3_stmt *statement) {
                EntityUser *user = [EntityUser new];
                while (sqlite3_step(statement)==SQLITE_ROW){
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
                }
                return user;
            }];
            if(!_entityUser){
                EntityManagerAddressBook *em = COMMON_EMAB;
                _entityUser = [em findByPhone:self.callPhoneNum];
            }
            _entityUserFlag = true;
        }
    }
    return _entityUser;
}
-(void) setEntityUser:(EntityUser *) entityUser{
    _entityUser = entityUser;
}
@end
