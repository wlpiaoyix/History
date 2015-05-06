//
//  ModleUser.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-10.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ModleUser.h"
@implementation ModleUser
+(id) modelInitWithJSON:(NSDictionary*) json{
    if(!json) return nil;
    ModleUser *user = [ModleUser new];
    user.key = (NSNumber*)[json valueForKey:@"key"];
    user.name = [json valueForKey:@"name"];
    user.defaultPicUrl = [json valueForKey:@"defaultPicUrl"];
    user.sex = [json valueForKey:@"sex"];
    user.phoneNum = [json valueForKey:@"phoneNum"];
    user.qq = [json valueForKey:@"qq"];
    user.weixin = [json valueForKey:@"weixin"];
    user.email = [json valueForKey:@"email"];
    user.homeAddress = [json valueForKey:@"homeAddress"];
    user.companyAddress = [json valueForKey:@"companyAddress"];
    user.weixin = [json valueForKey:@"weixin"];
    return user;
}
-(NSMutableDictionary*) toJSON{
    NSMutableDictionary *json = [NSMutableDictionary new];
    [json setValue:_key forKey:@"key"];
    [json setValue:_name forKey:@"name"];
    [json setValue:_defaultPicUrl forKey:@"defaultPicUrl"];
    [json setValue:_sex forKey:@"sex"];
    [json setValue:_phoneNum forKey:@"phoneNum"];
    [json setValue:_qq forKey:@"qq"];
    [json setValue:_weixin forKey:@"weixin"];
    [json setValue:_email forKey:@"email"];
    [json setValue:_homeAddress forKey:@"homeAddress"];
    [json setValue:_companyAddress forKey:@"companyAddress"];
    return json;
}

-(ModleUser*) copyUser{
    ModleUser *u = [ModleUser new];
    u.key = self.key;
    u.name = self.name;
    u.defaultPicUrl = self.defaultPicUrl;
    u.sex = self.sex;
    u.phoneNum = self.phoneNum;
    u.qq = self.qq;
    u.weixin = self.weixin;
    u.weibo = self.weibo;
    u.email = self.email;
    u.homeAddress = self.homeAddress;
    u.companyAddress = self.companyAddress;
    return u;
}

@end
