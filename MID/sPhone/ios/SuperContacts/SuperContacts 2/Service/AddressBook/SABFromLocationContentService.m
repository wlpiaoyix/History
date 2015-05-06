//
//  SABFromLocationContentService.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-8.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "SABFromLocationContentService.h"
#import "EntityManagerAddressBook.h"
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
-(NSArray*) query:(NSString*) name Phone:(NSString*) phone{
    NSMutableArray *temp = COMMON_ADDRESSBOOKARRAY;
    NSMutableArray *temp1 = [[NSMutableArray alloc]init];
    if([NSString isEnabled:name]){
        for (EntityUser *user in temp) {
            if([NSString isEnabled:user.userName]&&([user.userName hasPrefix:name]||[user.userName hasSuffix:name])){
                [temp1 addObject:user];
            }
        }
    }else{
        temp1 = [[NSMutableArray alloc]initWithArray:temp];
    }
    [temp removeAllObjects];
    if([temp1 count]==0)return temp1;
    if([NSString isEnabled:phone]){
        for (EntityUser *user in temp1) {
            for (NSString *_phone in user.telephones) {
                if(([_phone hasPrefix:phone]||[_phone hasSuffix:phone])){
                    [temp addObject:user];
                }
            }
        }
    }else{
        temp = [[NSMutableArray alloc]initWithArray:temp1];
    }
    [temp1 removeAllObjects];
    return temp;
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
@end
