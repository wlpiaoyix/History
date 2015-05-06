//
//  EntityPhone.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-18.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "EntityPhone.h"
#import "EntityManagerOperation.h"
#import "EntityManagerAddressBook.h"

@interface EntityPhone()
@property bool entityUserFlag;
@end
@implementation EntityPhone
- (int) getEntityId{
    return _phoneId;
}

-(void) setEntityUserX:(EntityUser *)modelUser{
    @synchronized(_entityUser){
        _entityUser = modelUser;
        _entityUserFlag = true;
    }
    
}
-(EntityUser*) getEntityUser{
    @synchronized(_entityUser){
        if(!_entityUserFlag){
            if(_entityUser){
                EntityManagerOperation *em = COMMON_EM;
                _entityUser = [em find:[EntityUser class] EntityId:self.entityUser.userId];
            }else{
                EntityManagerAddressBook *em = COMMON_EMAB;
                _entityUser = [em findByPhone:_phoneNum];
            }
            _entityUserFlag = true;
        }
    }
    return _entityUser;
}

+(char*) getCreateSql{
    return "CREATE TABLE IF NOT EXISTS EntityPhone (phoneId INTEGER PRIMARY KEY AUTOINCREMENT,entityUserId INTEGER,type INTEGER,phoneNum TEXT, jsonInfo TEXT)";
}
+(char*) getPersistSql{
    return "INSERT INTO entityPhone (entityUserId,type, phoneNum,jsonInfo) VALUES (?,?,?,?)";
}
+(char*) getMergeSql{
    return "UPDATE entityPhone SET entityUserId = ?,type = ?,phoneNum = ?, jsonInfo = ? WHERE phoneId=?";
}
+(char*) getDeleteSql{
    return "DELETE FROM EntityPhone WHERE phoneId = ?";
}

+(char*) getFindSql{
    return "SELECT * FROM EntityPhone WHERE phoneId = ?";
}
@end
