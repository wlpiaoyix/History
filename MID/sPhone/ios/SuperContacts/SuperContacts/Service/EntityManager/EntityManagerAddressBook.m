//
//  EntityManagerAddressBook.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-6.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "EntityManagerAddressBook.h"
#import "LocationAddressBook.h"
#import "EntityPhone.h"
#import "ChineseToPinyin.h"
#import <AddressBook/AddressBook.h>
@interface EntityManagerAddressBook(){
@private
@private
    NSMutableArray *datas;
    LocationAddressBook *lab;
    
}
@end
@implementation EntityManagerAddressBook
@synthesize pys;
-(id) init{
    if(self=[super init]){
        lab = [LocationAddressBook new];
        datas = [NSMutableArray new];
        pys = [NSMutableArray new];
    }
    return self;
}
/**
 保存通信录
 */
-(EntityUser*) merge:(EntityUser*) entity{
    entity.longPingYing = [ChineseToPinyin pinyinFromChiniseString:entity.userName];
    entity.shortPingYing = [ChineseToPinyin pinyinFromChiniseStringHead:entity.userName];
    id json = [EntityManagerAddressBook parseEntityToJson:entity];
    if(entity.userKey){
        [self->lab mergeContent:json UserRef:CFBridgingRetain(entity.userKey)];
        return entity;
    }else{
        entity.userKey = (__bridge id)([self->lab persistContent:json]);
        if(entity.userKey){
            return entity;
        }
    }
    return nil;
}
/**
 新增通信录
 */
-(EntityUser*) persist:(EntityUser*) entity{
    entity.longPingYing = [ChineseToPinyin pinyinFromChiniseString:entity.userName];
    entity.shortPingYing = [ChineseToPinyin pinyinFromChiniseStringHead:entity.userName];
    id json = [EntityManagerAddressBook parseEntityToJson:entity];
    entity.userKey = (__bridge id)([self->lab persistContent:json]);
    if(entity.userKey){
        return entity;
    }
    return nil;
}
/**
 删除通信录
 */
-(bool) remove:(EntityUser*) entity{
    if(entity.userKey){
        return [self->lab removeContent:(__bridge ABRecordRef)(entity.userKey)];
    }
    return false;
}
/**
 得到当前通信录
 */
-(EntityUser*) findByName:(NSString*) userName{
    NSArray *tempArray = [self->lab queryContentByName:userName];
    if ([tempArray count]) {
        EntityUser *user = nil;
        for (NSDictionary *json in tempArray) {
            user = [EntityManagerAddressBook parseJsonToEntity:json];
            if([user.userName isEqual:userName]){
                return user;
            }
        }
        return user;
    }
    return nil;
}
/**
 得到当前通信录
 */
-(EntityUser*) findByPhone:(NSString*) phone{
    if(!datas)
        datas = [self queryContentsByParams:phone];
    EntityUser *user = nil;
    for (NSDictionary *json in datas) {
        user = [EntityManagerAddressBook parseJsonToEntity:json];
        for (EntityPhone *ep in user.telephones) {
            if([ep.phoneNum isEqual:phone]){
                return user;
            }
        }
    }
    return nil;
}
-(void) refreshContents{
    NSArray *tempArray = [lab queryContent];
    NSMutableArray *contents = [NSMutableArray new];
    for (NSDictionary *json in tempArray) {
        [contents addObject:[EntityManagerAddressBook parseJsonToEntity:json]];
    }
    datas = contents;
    [pys removeAllObjects];
    for (EntityUser *user in datas) {
        NSString *py = user.shortPingYing;
        if([NSString isEnabled:py]){
            [pys addObject:py];
        }
    }
}
/**
 查询出所有的记录
 */
-(NSMutableArray*) queryContentsByParams:(NSString*) params{
    if(!datas||![datas count]){
        [self refreshContents];
    }
    NSMutableArray *contents = [NSMutableArray new];
    NSArray *chekPy = nil;
    if([NSString isEnabled:params]&&params.length>0&&params.length<5){
        char *cs = (char*)[params UTF8String];
        bool flag =false;
        for (int i=0;i<strlen(cs);i++) {
            char cx = cs[i];
            if(cx<48||cx>57){
                flag = true;
                break;
            }
        }
        if(flag){
            chekPy = [NSArray arrayWithObjects:[params uppercaseString], nil];
        }else{
            chekPy = (NSArray*)COMMON_CHECKNUMTOPYFORARRAY(cs);
        }
    }

    for (EntityUser *user in datas) {
        bool flag = false;
        for (NSString *argx in chekPy) {
            if([user.shortPingYing hasPrefix:argx]){
                [contents addObject:user];
                flag = true;
                break;
            }
        }
        if(flag){
            continue;
        }
        if(![NSString isEnabled:params]){[contents addObject:user];continue;};
        if([user.userName hasPrefix:params]){
            [contents addObject:user];
            flag = true;
        }
        if(flag){
            continue;
        }
        for (EntityPhone *ep in user.telephones) {
            if([ep.phoneNum hasPrefix:params]){
                [contents addObject:user];
                flag = true;
                break;
            }
        }
        if(flag){
            continue;
        }
    }
    return contents;
}
-(NSMutableArray*) queryContentsByPhone:(NSString *) phone Flag:(bool) flag{
    NSMutableArray *data = [NSMutableArray new];
    for (EntityUser *user in datas) {
        for (EntityPhone *ep in user.telephones) {
            if(flag){
                if([ep.phoneNum hasPrefix:phone]||[ep.phoneNum hasPrefix:phone]){
                    [data addObject:user];
                }
            }else{
                if([ep.phoneNum isEqual:phone]){
                    [data addObject:user];
                }
            }
        }
    }
    return data;
}
/**
 查询出所有的记录
 */
-(NSMutableArray*) queryContentsByName:(NSString*) name{
    NSArray *tempArray =  [lab queryContentByName:name];
    NSMutableArray *contents = [NSMutableArray new];
    for (NSDictionary *json in tempArray) {
        [contents addObject:[EntityManagerAddressBook parseJsonToEntity:json]];
    }
    return contents;
}
+(NSDictionary*) parseEntityToJson:(EntityUser*) user{
    NSMutableDictionary *json = [NSMutableDictionary new];
    id recordKey = user.userKey;
    NSString *name = user.userName;
    NSMutableArray *phones = [NSMutableArray new];
    NSString *note = [user.jsonInfo JSONRepresentation];
    for (EntityPhone *ep in user.telephones) {
        NSString *type = [Enum_PhoneType valueByEnum:ep.type.intValue];
        NSString *value = ep.phoneNum;
        NSArray *array = [NSArray arrayWithObjects:type, value, nil];
        [phones addObject:array];
    }
   if(recordKey) [json setObject:recordKey forKey:@"recordKey"];
    [json setObject:name forKey:@"name"];
    [json setObject:phones forKey:@"phone"];
    [json setObject:note?note:@"" forKey:@"note"];
    if([NSString isEnabled:user.shortPingYing])
        [json setObject:user.shortPingYing forKey:@"shortPy"];
    if([NSString isEnabled:user.longPingYing])
        [json setObject:user.longPingYing forKey:@"longPy"];
    if(user.dataImage)[json setObject:user.dataImage forKey:@"dataImage"];
    return json;
}
+(EntityUser*) parseJsonToEntity:(NSDictionary*) json{
    EntityUser *user = [EntityUser new];
    user.userKey = [json objectForKey:@"recordKey"];
    user.userName = [json objectForKey:@"name"];
    user.shortPingYing = [json objectForKey:@"shortPY"];
    user.longPingYing = [json objectForKey:@"longPY"];
    NSArray *tempArray = [json objectForKey:@"phone"];
    if(tempArray&&[tempArray count]){
        NSMutableArray *phones = [NSMutableArray new];
        for (NSArray *array in tempArray) {
            if([array count]==0)continue;
            EntityPhone *phone = [EntityPhone new];
            phone.type = [NSNumber numberWithInt:[Enum_PhoneType enumByValue:array[0]]] ;
            phone.phoneNum = array[1];
            [phone setEntityUserX:user];
            [phones addObject:phone];
        }
        user.telephones = phones;
    }
//    tempArray = [json objectForKey:@"email"];
//    if(tempArray&&[tempArray count]){
//        NSMutableArray *phones = [NSMutableArray new];
//        for (NSArray *array in tempArray) {
//            EntityPhone *email = [EntityPhone new];
//            email.type = [Enum_PhoneType enumByValue:array[0]];
//            email.phoneNum = array[1];
//            [email setEntityUserX:user];
//            [phones addObject:email];
//        }
//        user.emails = phones;
//    }
    user.emails = [NSMutableArray new];
    NSString *note = [json objectForKey:@"note"];
    if(note){
        user.jsonInfo = [note JSONValue];
    }
    if(![NSString isEnabled:user.longPingYing]){
        user.longPingYing = [ChineseToPinyin pinyinFromChiniseString:user.userName];
    }
    if(![NSString isEnabled:user.shortPingYing]){
        user.shortPingYing = [ChineseToPinyin pinyinFromChiniseStringHead:user.userName];
    }
    return user;
}

/**
 得到可以用于显示头像的图片
 */
-(UIImage*) findImageHeadByRef:(id) userKey{
    NSData *data = [self->lab findDataImage1ByRef:userKey];
    UIImage *imageHead = nil;
    if(data)imageHead = [UIImage imageWithData:data];
    return imageHead;
}
/**
 得到可以用于显示背景的图片
 */
-(UIImage*) findImageBgByRef:(id) userKey{
    NSData *data = [self->lab findDataImageByRef:userKey];
    UIImage *imageBG = nil;
    if(data){
        imageBG = [UIImage imageWithData:data];
        if (imageBG.size.height/imageBG.size.width!=(COMMON_SCREEN_H-44)/COMMON_SCREEN_W) {
            imageBG = COMMON_CUTIMG(imageBG);
        }
    }
    return imageBG;
}
@end
