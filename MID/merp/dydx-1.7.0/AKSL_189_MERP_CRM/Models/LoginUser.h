//
//  LoginUser.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-19.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginUser : NSObject

@property (assign) long userDataId;
@property (assign,nonatomic)int roelId;
@property long long userkey;
@property (strong,nonatomic)NSString *username;
@property (strong,nonatomic)NSString *type;
@property (strong,nonatomic)NSString *setString;
@property (strong,nonatomic)NSString *headerImageUrl;
@property (strong,nonatomic)NSString *userId;
@property (strong,nonatomic)NSString *mobilePhone;
@property (strong,nonatomic)NSString *sexName;
@property (strong,nonatomic)NSString *rankString;
@property (assign,nonatomic)int task;
@property (assign,nonatomic)int complete;
@property (strong,nonatomic)NSString *progressString;
@property (assign,nonatomic) int sexValue;
@property (assign,nonatomic) int userage;
@property (assign,nonatomic) float progressFloat;
@property (strong,nonatomic) NSString * organizationID;
@property (assign,nonatomic) int organizationType;
@property (strong,nonatomic) NSString * organizationTypeName;
@property (assign,nonatomic) bool isTrafficAdmin;
@property (strong,nonatomic) NSString *userBgImg;
@property (strong,nonatomic) NSString *userCode;
@property (strong,nonatomic) NSDictionary * userObj;
+(LoginUser *)getLoginUserFromJson:(NSString *)json;
+(LoginUser *)getLoginUserFromDic:(NSDictionary *)dic;

@end
