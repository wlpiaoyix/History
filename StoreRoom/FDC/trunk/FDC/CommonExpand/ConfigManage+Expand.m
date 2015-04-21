//
//  ConfigManage+Expand.m
//  FDC
//
//  Created by wlpiaoyi on 15/1/16.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "ConfigManage+Expand.h"
NSString *LoginUserName;
NSString *LoginUserPassoword;
static UserEntity *STATIC_LOGIN_USER;

@implementation ConfigManage(Expand)


+(void) initialize{
    LoginUserName = [self getConfigValue:@"LoginUserName"];
    LoginUserPassoword = [self getConfigValue:@"LoginUserPassoword"];
}

+(UserEntity*) getLoginUser{
    return STATIC_LOGIN_USER;
}
+(void) setLoginUser:(UserEntity*) user{
    STATIC_LOGIN_USER = user;
    [self setConfigValue:LoginUserName Key:@"LoginUserName"];
    [self setConfigValue:LoginUserPassoword Key:@"LoginUserPassoword"];
}
+(id) getConfigValueByUser:(NSString *)key{
    NSString *userKey = [NSString stringWithFormat:@"%@_%@",LoginUserName,key];
    return [self getConfigValue:userKey];
}
+(void) setConfigValueByUser:(id) value Key:(NSString*) key{
    NSString *userKey = [NSString stringWithFormat:@"%@_%@",LoginUserName,key];
    [self setConfigValue:value Key:userKey];
}

@end
