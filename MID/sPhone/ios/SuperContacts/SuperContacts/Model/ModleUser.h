//
//  ModleUser.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-10.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModleUser : NSObject
@property (strong, nonatomic) NSNumber *key;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *vcode;
@property (strong, nonatomic) NSString *defaultPicUrl;
@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSString *phoneNum;
@property (strong, nonatomic) NSString *qq;
@property (strong, nonatomic) NSString *weixin;
@property (strong, nonatomic) NSString *weibo;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *homeAddress;
@property (strong, nonatomic) NSString *companyAddress;
-(ModleUser*) copyUser;
+(id) modelInitWithJSON:(NSDictionary*) json;
-(NSMutableDictionary*) toJSON;
@end
