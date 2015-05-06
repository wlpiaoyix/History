//
//  SABFromLocationContentService.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-8.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "SABFromLocationContentService.h"
#import "EntityManagerAddressBook.h"
#import "EntityPhone.h"
@interface SABFromLocationContentService()
@property EntityManagerAddressBook* em;
@end
@implementation SABFromLocationContentService
-(id)init{
    self = [super init];
    if(self){
        _em = COMMON_EMAB;
    }
    return self;
}
-(bool) remove:(EntityUser*) user{
    return [_em remove:user];
}
-(EntityUser*) persist:(EntityUser*) user{
    if(!user.telephones||[user.telephones count]==0){
        @throw [[NSException alloc]initWithName:@"新增异常" reason:@"电话号码不能为空" userInfo:nil];
    }
    if(![NSString isEnabled:user.userName]){
        @throw [[NSException alloc]initWithName:@"新增异常" reason:@"姓名不能为空" userInfo:nil];
    }
    [_em persist:user];
    return user;
}
-(EntityUser*) merge:(EntityUser*) user{
    if(!user.telephones||[user.telephones count]==0){
        @throw [[NSException alloc]initWithName:@"更新异常" reason:@"电话号码不能为空" userInfo:nil];
    }
    if(![NSString isEnabled:user.userName]){
        @throw [[NSException alloc]initWithName:@"更新异常" reason:@"姓名不能为空" userInfo:nil];
    }
    [_em merge:user];
    return user;
}
-(NSArray*) queryByParams:(NSString*) params{
    return [_em queryContentsByParams:params];
}
-(NSArray*) queryByPhone:(NSString*) phone{
    NSArray *tempArray = [_em queryContentsByPhone:phone Flag:YES];
    return tempArray;
}
-(NSArray*) queryByName:(NSString *)name{
    return [_em queryContentsByName:name];
}
@end
