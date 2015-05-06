//
//  EntityUser.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-2.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "EntityUser.h"
#import "EntityPhone.h"
#import "FDEntityManager.h"
@interface EntityUser(){
}
@end
@implementation EntityUser
//-(void) setDataImage:(id)dataImage{
//    if(dataImage&&_useRefint&&[dataImage isKindOfClass:[NSData class]]){
//        NSString *path = [NSString stringWithFormat:@"%@/%d.jpg",[ConfigManage getDocumentsDirectory],_useRefint];
//        NSFileManager *f = [NSFileManager defaultManager];
//        if(![f fileExistsAtPath:path]){
//            NSData* imageData =UIImageJPEGRepresentation(dataImage, 1.0f);
//            [imageData writeToFile:path atomically:NO];
//        }
//    }
//    _dataImage = dataImage;
//}
-(NSArray*) getTelephones{
    @synchronized(_telephones){
        if(!_telephones){
            if(self.userId){
                FDEntityManager *em = COMMON_EM;
                _telephones = [em queryBySql:@"select p.* from EntityPhone as p where p.entityUserId = ?" Clazz:[EntityPhone class]  Params:[NSArray arrayWithObjects:_userId, nil]];
            }
        }
    }
    return _telephones;
}
-(void) setJsonInfo:(id)jsonInfo{
    if ([jsonInfo isKindOfClass:[NSString class]]&&[NSString isEnabled:jsonInfo]) {
        _jsonInfo = [((NSString*)jsonInfo) JSONValue];
    }else{
        _jsonInfo = jsonInfo;
    }
}
+(NSString*) getKey{
    return @"userId";
}
+ (NSArray*) getColums{
    return [NSArray arrayWithObjects:@"userName",@"longPingYing",@"shortPingYing",@"tag",@"locationStatus",@"updateTime",@"jsonInfo", nil];
}
+(long long int) getTypes{
    return 3333113;
}
+(NSString*) getTable{
    return @"EntityUser";
}



+(char*) getCreateSql{
    return "CREATE TABLE IF NOT EXISTS EntityUser (userId INTEGER PRIMARY KEY AUTOINCREMENT,userName TEXT,dataImage TEXT, longPingYing TEXT,shortPingYing TEXT,defaultPhone TEXT,updateTime TEXT, locationStatus INTEGER,jsonInfo TEXT)";
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
