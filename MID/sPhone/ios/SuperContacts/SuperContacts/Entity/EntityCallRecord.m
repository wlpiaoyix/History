//
//  EntityCallRecord.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-2.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "EntityCallRecord.h"
#import "EntityPhone.h"
#import "SABFromLocationContentService.h"
#import "SABFromDataBaseService.h"
#import "EntityManagerAddressBook.h"
@interface EntityCallRecord()
@property bool entityUserFlag;
@end
@implementation EntityCallRecord

-(EntityUser*) getEntityUser{
    @synchronized(_entityUser){
        if(!_entityUserFlag){
            SABFromLocationContentService *flcs =  COMMON_FLCS
            SABFromDataBaseService *fdbs = COMMON_FDBS;
            NSMutableArray *tempArray = (NSMutableArray*)[fdbs queryEntityUserByPhone:self.callPhoneNum];
            if(!tempArray||![tempArray count])
                [tempArray addObjectsFromArray:[flcs queryByPhone:self.callPhoneNum]];
            EntityUser *user = nil;
            bool flagb = false;
            for (EntityUser *eu in tempArray) {
                for (EntityPhone *ep in eu.telephones) {
                    if([ep.phoneNum isEqual:self.callPhoneNum]){
                        user = eu;
                        flagb = true;
                        break;
                    }
                }
                if (flagb) {
                    break;
                }
            }
            return user;
        }
    }
    return _entityUser;
}
-(void) setEntityUser:(EntityUser *) entityUser{
    _entityUser = entityUser;
}
-(void) setJsonInfo:(id)jsonInfo{
    if ([jsonInfo isKindOfClass:[NSString class]]&&[NSString isEnabled:jsonInfo]) {
        _jsonInfo = [((NSString*)jsonInfo) JSONValue];
    }else{
        _jsonInfo = jsonInfo;
    }
}
+(NSString*) getKey{
    return @"recordId";
}
+ (NSArray*) getColums{
    return [NSArray arrayWithObjects:@"callPhoneNum",@"recordTime",@"statusCall",@"createTime",@"jsonInfo", nil];
}
+(long long int) getTypes{
    return 31113;
}
+(NSString*) getTable{
    return @"EntityCallRecord";
}
@end
