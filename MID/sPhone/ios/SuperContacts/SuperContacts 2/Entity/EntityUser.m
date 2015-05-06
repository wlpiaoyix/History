//
//  EntityUser.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-2.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "EntityUser.h"
#import "EntityManagerOperation.h"
#import "EntityPhone.h"
@interface EntityUser(){
}
@end
@implementation EntityUser
- (int) getEntityId{
    return _userId;
}
-(void) setUserRef:(ABRecordRef)userRef{
    _userRef = userRef;
    _useRefint = (int32_t)CFBridgingRelease(userRef);
}
-(void) setDataImage:(id)dataImage{
    if(dataImage&&_useRefint&&[dataImage isKindOfClass:[NSData class]]){
        NSString *path = [NSString stringWithFormat:@"%@/%d.jpg",[ConfigManage getDocumentsDirectory],_useRefint];
        NSFileManager *f = [NSFileManager defaultManager];
        if(![f fileExistsAtPath:path]){
            NSData* imageData =UIImageJPEGRepresentation(dataImage, 1.0f);
            [imageData writeToFile:path atomically:NO];
        }
    }
    _dataImage = dataImage;
}
-(NSArray*) getTelephones{
    @synchronized(_telephones){
        if(!_telephones){
            if(!self.userId){
                _telephones = [NSMutableArray new];
                return _telephones;
            }
            EntityManagerOperation *em = COMMON_EM;
            __weak typeof(self) tempSelf = self;
            _telephones = [em excueSpecialTarget:^NSString *(id target) {
                return @"select p.* from EntityPhone as p where p.entityUserId = ?";
            } ExcuCallBackBindValue:^id(sqlite3_stmt *statement) {
                sqlite3_bind_int(statement, 1, tempSelf.userId);
                return nil;
            } ExcuCallBackSetValue:^id(sqlite3_stmt *statement) {
                NSMutableArray *phones = [[NSMutableArray alloc]init];
                while (sqlite3_step(statement)==SQLITE_ROW){
                    EntityPhone *mp = [EntityPhone new];
                    mp.phoneId = sqlite3_column_int(statement, 0);
                    mp.entityUser = tempSelf;
                    mp.type = sqlite3_column_int(statement, 2);
                    const unsigned char *phoneNum = sqlite3_column_text(statement, 3);
                    mp.phoneNum = [NSString stringWithFormat:@"%s",phoneNum];
                    const unsigned char *jsonInfo= sqlite3_column_text(statement,4);
                    if(jsonInfo&&strlen((char*) jsonInfo))
                        mp.jsonInfo = strlen((const char*)(char*)jsonInfo)?[[NSString stringWithUTF8String:(char*)jsonInfo] JSONValue]:nil;
                    [phones addObject:mp];
                }
                return phones;
            }];
        }
    }
    return _telephones;
}

+(char*) getCreateSql{
    return "CREATE TABLE IF NOT EXISTS EntityUser (userId INTEGER PRIMARY KEY AUTOINCREMENT,userName TEXT,dataImage, longPingYing TEXT,shortPingYing TEXT,defaultPhone TEXT,updateTime TEXT, locationStatus INTEGER,jsonInfo TEXT)";
}
+(char*) getPersistSql{
    return "INSERT INTO EntityUser (userName,dataImage, longPingYing,shortPingYing,defaultPhone,updateTime,locationStatus,jsonInfo) VALUES (?,?,?,?,?,?,?,?)";
}
+(char*) getMergeSql{
    return "UPDATE EntityUser SET userName = ?, dataImage = ?, longPingYing = ?, shortPingYing = ?, defaultPhone = ?,updateTime = ?, locationStatus=?, jsonInfo = ? WHERE userId=?";
}
+(char*) getDeleteSql{
    return "DELETE FROM EntityUser WHERE userId = ?";
}
+(char*) getFindSql{
    return "Select * From EntityUser WHERE userId = ?";
}
@end
